part of 'register_bloc.dart';

abstract class RegisterEvent {}

class UsernameChanged extends RegisterEvent {
  final String username;

  UsernameChanged(this.username);
}

class EmailChanged extends RegisterEvent {
  final String email;

  EmailChanged(this.email);
}

class PasswordChanged extends RegisterEvent {
  final String password;

  PasswordChanged(this.password);
}

class ConfirmPasswordChanged extends RegisterEvent {
  final String confirmPassword;

  ConfirmPasswordChanged(this.confirmPassword);
}

class GroupSwitchChanged extends RegisterEvent {
  final bool isJoinGroup;

  GroupSwitchChanged(this.isJoinGroup);
}

class GroupIdChanged extends RegisterEvent {
  final String groupId;

  GroupIdChanged(this.groupId);
}

class SelectImageRegisterEvent extends RegisterEvent {
  final Uint8List image;
  final File selectImage;

  SelectImageRegisterEvent({
    required this.image,
    required this.selectImage,
  });
}

class RegisterSubmitted extends RegisterEvent {}

class LocationChanged extends RegisterEvent {
  final double lat;
  final double lon;

  LocationChanged({required this.lat, required this.lon});
}
