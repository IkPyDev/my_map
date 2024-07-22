part of 'login_bloc.dart';

abstract class LoginEvent {}

final class LoginChangeLoginEvent extends LoginEvent {
  String login;

  LoginChangeLoginEvent({required this.login});
}

final class PasswordChangeLoginEvent extends LoginEvent {
  String password;

  PasswordChangeLoginEvent({required this.password});
}

final class NextButtonLoginEvent extends LoginEvent {}
