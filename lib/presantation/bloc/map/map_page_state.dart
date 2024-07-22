part of 'map_page_bloc.dart';

class MapPageState {
  Stream<UserModel?> user;

  MapPageState({required this.user});

  MapPageState copyWith({Stream<UserModel?>? user}) => MapPageState(user: user ?? this.user);
}

