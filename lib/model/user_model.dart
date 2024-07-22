




// Define the data class
class UserModel {
  final String username;
  final String email;
  final String password;
  final String userId;
  final String imageUrl;
  final String notificationToken;
  final String groupId;
   double lat;
   double lon;

  UserModel({
    required this.username,
    required this.email,
    required this.password,
    required this.userId,
    required this.imageUrl,
    required this.notificationToken,
    required this.groupId,
    required this.lat,
    required this.lon,
  });

  UserModel.initial()
      : username = '',
        email = '',
        password = '',
        userId = '',
        imageUrl = '',
        notificationToken = '',
        groupId = '',
        lat = 0.0,
        lon = 0.0;

  // Implement the fromJson() function
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'],
      email: json['email'],
      password: json['password'],
      userId: json['userId'],
      imageUrl: json['imageUrl'],
      notificationToken: json['notificationToken'],
      groupId: json['groupId'],
      lat: json['lat'].toDouble(),
      lon: json['lon'].toDouble(),
    );
  }

  // Implement the toJson() function
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'userId': userId,
      'imageUrl': imageUrl,
      'notificationToken': notificationToken,
      'groupId': groupId,
      'lat': lat,
      'lon': lon,
    };
  }
}