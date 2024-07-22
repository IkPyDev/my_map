part of 'home_bloc.dart';

class HomeState {
  Stream<List<UserModel>> users;

  HomeState({required this.users});

  HomeState copyWith({
    Stream<List<UserModel>>? users,
  }) {
    return HomeState(
      users: users ?? this.users,
    );
  }
}
