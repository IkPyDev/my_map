// import 'dart:io';
// import 'dart:typed_data';
//
// import 'package:flutter_image_compress/flutter_image_compress.dart';
// import 'package:bloc/bloc.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:yandex_map/data/src/local.dart';
// import 'package:yandex_map/model/user_model.dart';
// import 'package:image/image.dart' as ui;
//
// import '../../../model/user_location.dart';
//
// part 'open_camera_event.dart';
// part 'open_camera_state.dart';
//
// class OpenCameraBloc extends Bloc<OpenCameraEvent, OpenCameraState> {
//   OpenCameraBloc() : super(OpenCameraState()) {
//     final _auth = FirebaseAuth.instance;
//     final CollectionReference contactsCollection = FirebaseFirestore.instance.collection("/my_yandex");
//
//     on<SelectImageOpenCameraEvent>((event, emit) {
//       emit(state.copyWith(image: event.image, selectImage: event.selectImage, status: DownloadOpenCameraState.loading));
//     });
//
//     on<UserLocationOpenCameraEvent>((event, emit) {
//       emit(state.copyWith(userLocation: event.userLocation, status: DownloadOpenCameraState.loading));
//     });
//
//     on<UploadOpenCameraEvent>((event, emit) async {
//       try {
//         // Create user with a unique email and password
//         emit(state.copyWith(status: DownloadOpenCameraState.upload));
//         UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
//           email: "email${DateTime.now().microsecondsSinceEpoch}@gmail.com",
//           password: "dsjcndskc,dsbcljsbdc",
//         );
//
//
//         // Upload photo to Firebase Storage
//         String url = await uploadPhotoToFirebase(state.selectImage!);
//         print("URL received: $url");
//
//         // Create a new user ID
//         final String userId = DateTime.now().microsecondsSinceEpoch.toString();
//
//         print(state.userLocation);
//         // Create a user model
//         UserModel user = UserModel(
//           name: event.name,
//           id: userId,
//           imageUrl: url,
//           userLocation: state.userLocation ?? UserLocation(lat: 4.0, lon: 4.0),
//         );
//
//         // Save user to Firestore
//         await contactsCollection.doc(user.id).set(user.toJson());
//         print("Data uploaded to Firestore: $user");
//
//         SharedPrefsManager().addUser(userId);
//         emit(state.copyWith(status: DownloadOpenCameraState.success));
//       } catch (e) {
//         print("Error occurred: $e");
//         emit(state.copyWith(status: DownloadOpenCameraState.fail));
//       }
//     });
//   }
//
//
//   Future<String> uploadPhotoToFirebase(File photo) async {
//     try {
//       // Rasmni o'qish
//       final image = await photo.readAsBytes();
//
//       // Rasmni 100x100 piksel o'lchamda qayta o'lchash
//       final resizedImage = await FlutterImageCompress.compressWithList(
//         image,
//         minHeight: 100,
//         minWidth: 100,
//         quality: 100,
//       );
//
//       // Rasmni ui.Image obyektiga aylantirish
//       final ui.Image imageCircle = ui.decodeImage(resizedImage)!;
//
//       // Rasmni aylana shaklida qirqish
//       final ui.Image imageRe = ui.copyCropCircle(imageCircle, radius: 50);
//
//       // Shaffof fonli yangi rasm yaratish
//       final ui.Image outputImage = ui.Image(imageRe.width, imageRe.height);
//       ui.fill(outputImage, ui.getColor(0,0,0,0)); // Shaffof fon yaratish
//       ui.drawImage(outputImage, imageRe);
//
//       // Aylana shaklida qirqilgan rasmni PNG formatida saqlash
//       final compressedFile = File('${photo.path}.png')
//         ..writeAsBytesSync(ui.encodePng(outputImage));
//
//       // Firebase Storage'ga yuklash
//       String ref = 'images/img-${DateTime.now().toString()}.png';
//       final storageRef = FirebaseStorage.instance.ref().child(ref);
//       UploadTask uploadTask = storageRef.putFile(compressedFile);
//       var url = await uploadTask.then((task) => task.ref.getDownloadURL());
//       return url;
//     } on FirebaseException catch (e) {
//       print(e);
//       throw Exception('Error on upload: ${e.code}');
//     }
//   }
//
// }
