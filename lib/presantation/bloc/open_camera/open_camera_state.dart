part of 'open_camera_bloc.dart';

class OpenCameraState {
  Uint8List? image;
  File? selectImage;

  String? name;
  DownloadOpenCameraState? status;
  UserLocation? userLocation;

  OpenCameraState({this.image, this.selectImage, this.name, this.status,this.userLocation});

  OpenCameraState copyWith({
    Uint8List? image,
    File? selectImage,
    String? selectImageUrl,
    String? name,
    DownloadOpenCameraState? status,
    UserLocation? userLocation
  }) =>
      OpenCameraState(
          image: image ?? this.image,
          selectImage: selectImage ?? this.selectImage,
          name: name ?? this.name,
          status: status ?? this.status,
          userLocation: userLocation ?? this.userLocation
      );
}

enum DownloadOpenCameraState { loading, upload, fail, success }

class UserLocation {
  double lat;
  double lon;

  UserLocation({required this.lat, required this.lon});
  factory UserLocation.fromJson(Map<String, dynamic> json) {
    return UserLocation(
      lat: json['lat'],
      lon: json['lon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lon': lon,
    };
  }

}
