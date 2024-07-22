part of 'login_bloc.dart';

class LoginState {
  String login;
  String password;
  LoginStatus status;

  LoginState({this.login = '', this.password = '', this.status = LoginStatus.loading});

  LoginState copyWith({
    String? login,
    String? password,
    LoginStatus? status,
  }) {
    return LoginState(
      login: login ?? this.login,
      password: password ?? this.password,
      status: status ?? this.status,
    );
  }
}

enum LoginStatus {initial, loading, success, fail}