import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart' as ui;
import 'package:yandex_map/model/user_model.dart';

import '../local.dart';

class FirebaseManager {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  static const collectionName = "my_yandex";

  FirebaseManager._();

  static Future<String> uploadPhotoToFirebase(File photo) async {
    try {
      final image = await photo.readAsBytes();
      final resizedImage = await FlutterImageCompress.compressWithList(
        image,
        minHeight: 400,
        minWidth: 400,
        quality: 100,
      );
      final imageCircle = ui.decodeImage(resizedImage)!;
      final imageRe = ui.copyCropCircle(imageCircle, radius: 400);
      final outputImage = ui.Image(400, 400);
      ui.fill(outputImage, ui.getColor(0, 0, 0, 0));
      ui.drawImage(outputImage, imageRe);
      final compressedFile = File('${photo.path}.png')..writeAsBytesSync(ui.encodePng(outputImage));
      final storageRef = FirebaseStorage.instance.ref().child('images/img-${DateTime.now().toString()}.png');
      final uploadTask = storageRef.putFile(compressedFile);
      final url = await uploadTask.then((task) => task.ref.getDownloadURL());
      return url;
    } on FirebaseException catch (e) {
      print(e);
      throw Exception('Error on upload: ${e.code}');
    }
  }

  static Future<bool> checkIfGroupExists(String groupId) async {
    try {
      final groupCollection = await _fireStore.collection(FirebaseManager.collectionName).get();

      // Check if the groupId exists in the collection
      final groupExists = groupCollection.docs.any((doc) => doc.id == groupId);

      return groupExists;
    } catch (e) {
      return false;
    }
  }

  static Future<UserModel?> loginUser(String email, String password) async {
    try {
      // Authenticate with Firebase Auth
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      if (userCredential.user == null) {
        print(userCredential.user);
        return null;
      }

      // Fetch user data from Firestore
      DocumentSnapshot userDoc = await _fireStore
          .collection(FirebaseManager.collectionName) // Assuming you have a 'users' collection
          .doc(email.trim())
          .get();

      if (userDoc.exists) {
        // Convert the Firestore document to UserModel
        UserModel user = UserModel.fromJson(userDoc.data() as Map<String, dynamic>);
        if (user.password == password) {
          return user;
        }
        return null;
      } else {
        return null;
      }
    } catch (e) {
      // Handle errors
      print('Error logging in: $e');
      return null;
    }
  }

  static Stream<List<UserModel>> getAllUser() {
    String groupId = SharedPrefsManager.getGroupId() ?? "";
    return _fireStore.collection(collectionName).where('groupId', isEqualTo: groupId).snapshots().map((snapshot) =>
        snapshot.docs
            .map((doc) => doc.exists ? UserModel.fromJson(doc.data()) : throw Exception('Document does not exist'))
            .toList());
  }

  static Stream<UserModel> getUserByEmail(String email) {
    return _fireStore.collection(collectionName).where('email', isEqualTo: email).snapshots().map((snapshot) {
        var doc = snapshot.docs.first;
        return UserModel.fromJson(doc.data());

    });
  }

  static Future<void> updateLocation(double lat, double lon) async {
    UserModel user = SharedPrefsManager.getUserData();
    user.lat = lat;
    user.lon = lon;
    await _fireStore.collection(collectionName).doc(user.email).update({
      'lat': lat,
      'lon': lon,
    });
    await SharedPrefsManager.saveUserData(user);
  }
}
/*Future<UserModel?> loginUser(String email, String password) async {
    try {
      // Get all collections (group IDs)
      // List<CollectionReference> collections = await _fireStore.collections().toList();

      for (CollectionReference collection in collections) {
        // Query the document with the specified email
        DocumentSnapshot documentSnapshot = await collection.doc(email).get();

        if (documentSnapshot.exists) {
          // Convert document to UserModel
          UserModel user = UserModel.fromJson(documentSnapshot.data() as Map<String, dynamic>);

          // Check password
          if (user.password == password) {
            return user;
          } else {
            // Password does not match
            return null;
          }
        }
      }

      // No matching document found in any collection
      return null;
    } catch (e) {
      print('Error logging in user: $e');
      return null;
    }
  }*/

// Future<void> addContact(String name, String phone) {
//   return _contactsCollection.add({'name': name, 'phone': phone});
// }
//
// Future<void> deleteContact(String id) {
//   return _contactsCollection.doc(id).delete();
// }
//
// Stream<List<UserModel>> getUsers() {
//   return _contactsCollection.snapshots().map((snapshot) => snapshot.docs
//       .map((doc) => doc.exists
//       ? UserModel.fromJson(doc.data() as Map<String, dynamic>)
//       : throw Exception('Document does not exist'))
//       .toList());
// }
//
// Future<void> updateContact(String id, String name, String phone) {
//   return _contactsCollection.doc(id).update({'name': name, 'phone': phone});
// }
//
// Future<void> logout() async {
//   await _auth.signOut();
// }
//
// Future<void> clearAll() async {
//   final snapshot = await _contactsCollection.get();
//   for (final contact in snapshot.docs) {
//     await contact.reference.delete();
//   }
//   await _auth.signOut();
// }
//
// Future<bool> login(String email, String password) async {
//   try {
//     await _auth.signInWithEmailAndPassword(email: email, password: password);
//     return true;
//   } catch (e) {
//     return false;
//   }
// }
//
// Future<bool> register(String email, String password) async {
//   try {
//     await _auth.createUserWithEmailAndPassword(email: email, password: password);
//     return true;
//   } catch (e) {
//     return false;
//   }
// }
