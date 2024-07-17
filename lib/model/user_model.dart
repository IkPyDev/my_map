

import '../presantation/bloc/open_camera/open_camera_bloc.dart';

class UserModel {
  String imageUrl;
  String name;
  String id;
  UserLocation userLocation;

  UserModel({
    required this.imageUrl,
    required this.name,
    required this.id,
    required this.userLocation,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      imageUrl: json['imageUrl'],
      name: json['name'],
      id: json['id'],
      userLocation: UserLocation.fromJson(json['userLocation']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'name': name,
      'id': id,
      'userLocation': userLocation.toJson(),
    };
  }
}