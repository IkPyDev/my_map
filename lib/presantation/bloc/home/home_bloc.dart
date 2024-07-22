import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:yandex_map/data/src/remote/firebase_manager.dart';
import 'package:yandex_map/model/user_model.dart';


part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  StreamSubscription<List<UserModel>>? _userSubscription;

  HomeBloc() : super(HomeState(users: Stream<List<UserModel>>.empty())) {
    on<LoadContactsEvent>((event, emit) {
      // Cancel the previous subscription if it exists
      _userSubscription?.cancel();

      // Listen to the new stream and emit state updates
      _userSubscription = FirebaseManager.getAllUser().listen((users) {
        emit(state.copyWith(users: FirebaseManager.getAllUser()));
      });
    });
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}
