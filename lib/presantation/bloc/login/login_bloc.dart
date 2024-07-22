
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:yandex_map/data/src/local.dart';
import 'package:yandex_map/model/user_model.dart';

import '../../../data/src/remote/firebase_manager.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState(status: LoginStatus.initial, login: 'ikpydev@gmail.com', password: '1234567890')) {
    on<LoginChangeLoginEvent>(_onLoginChange);
    on<PasswordChangeLoginEvent>(_onPasswordChange);
    on<NextButtonLoginEvent>(_onNextButton);
  }


  FutureOr<void> _onLoginChange(LoginChangeLoginEvent event, Emitter<LoginState> emit) {

    emit(state.copyWith(login: event.login));
  }

  FutureOr<void> _onPasswordChange(PasswordChangeLoginEvent event, Emitter<LoginState> emit) {
    emit(state.copyWith(password: event.password));
  }

  Future<FutureOr<void>> _onNextButton(NextButtonLoginEvent event, Emitter<LoginState> emit) async {

    if(state.login.isEmpty || state.password.isEmpty){
      emit(state.copyWith(status: LoginStatus.fail));

    }
    emit(state.copyWith(status: LoginStatus.loading ));

    UserModel ? userdata = await FirebaseManager.loginUser(state.login, state.password);
    if(userdata != null){
      print("AAAAAAAAAAAAAAAAAAAAAAAAAA");
      print(userdata.groupId);
      await SharedPrefsManager.saveUserData(userdata);
      await SharedPrefsManager.saveGroupId(userdata.groupId);
      print("GGGGGGGGGGGGGGGGGGGGGGGG");
      emit(state.copyWith(status: LoginStatus.success));
    }else{
      emit(state.copyWith(status: LoginStatus.fail));
    }
  }
}
