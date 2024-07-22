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