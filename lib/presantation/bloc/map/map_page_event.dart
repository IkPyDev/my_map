part of 'map_page_bloc.dart';

abstract class MapPageEvent {}

final class LoadUserEvent extends MapPageEvent {
  String email;

  LoadUserEvent({required this.email});
}
