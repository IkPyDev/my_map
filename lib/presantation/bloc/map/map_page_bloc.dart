import 'package:bloc/bloc.dart';
import 'package:yandex_map/data/src/remote/firebase_manager.dart';

import '../../../model/user_model.dart';

part 'map_page_event.dart';
part 'map_page_state.dart';

class MapPageBloc extends Bloc<MapPageEvent, MapPageState> {
  MapPageBloc() : super(MapPageState(user: Stream.empty())) {
    on<LoadUserEvent>((event, emit) async {

      emit(state.copyWith(user: FirebaseManager.getUserByEmail(event.email)));
    });
  }
}
