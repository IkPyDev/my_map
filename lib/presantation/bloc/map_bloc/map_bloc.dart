import 'package:bloc/bloc.dart';
import 'package:yandex_map/data/src/local.dart';
import 'package:yandex_map/data/src/remote/firebase_manager.dart';

import '../../../model/user_model.dart';

part 'map_event.dart';

part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(MapState(users: [], status: Status.loading)) {
    final SharedPrefsManager sharedPrefsManager = SharedPrefsManager();
    // FirebaseManager firebaseManager = FirebaseManager;
    on<LoadMapEvent>((event, emit) async {
      emit(MapState(users: [], status: Status.loading));
      // firebaseManager.getUsers().listen((users) {
      //   print(users);
      // }
      // );
      List<UserModel> users = [];
      // users = await FirebaseManager().getUsers().first;
      users.where((test) => test.userId == sharedPrefsManager.getUser()).toList();
      emit(MapState(users: users, status: Status.success));
    });
  }
}
