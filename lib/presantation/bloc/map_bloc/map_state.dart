part of 'map_bloc.dart';

class MapState {
  List<UserModel> users;

  Status status;

  MapState({required this.users, required this.status});

  MapState copyWith({List<UserModel>? users, Status? status}) {
    return MapState(users: users ?? this.users, status: status ?? this.status);
  }

}

enum Status { loading,success,fail }
