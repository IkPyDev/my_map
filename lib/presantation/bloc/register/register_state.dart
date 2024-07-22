part of 'register_bloc.dart';

enum RegisterStatus { initial, loading, success, fail }

class RegisterState {
  final String email;
  final String username;
  final String password;
  final String confirmPassword;
  final bool isJoinGroup;
  final String groupId;
  final Uint8List? image;
  final File? selectImage;
  final RegisterStatus status;
  final String? errorMessage;
  final double lat;
  final double lon;

  const RegisterState({
    this.email = '',
    this.username = '',
    this.password = '',
    this.confirmPassword = '',
    this.isJoinGroup = false,
    this.groupId = '',
    this.image,
    this.selectImage,
    this.status = RegisterStatus.initial,
    this.errorMessage,
    this.lat=0,
    this.lon=0
  });

  RegisterState copyWith({
    String? email,
    String? username,
    String? password,
    String? confirmPassword,
    bool? isJoinGroup,
    String? groupId,
    Uint8List? image,
    File? selectImage,
    RegisterStatus? status,
    String? errorMessage,
    double? lat,
    double? lon,
  }) {
    return RegisterState(
      email: email ?? this.email,
      username: username ?? this.username,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isJoinGroup: isJoinGroup ?? this.isJoinGroup,
      groupId: groupId ?? this.groupId,
      image: image ?? this.image,
      selectImage: selectImage ?? this.selectImage,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
    );
  }
}
