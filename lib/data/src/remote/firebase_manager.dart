import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yandex_map/model/user_model.dart';

class FirebaseManager {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  static var collectionName = "my_yandex";

  final CollectionReference _contactsCollection =
  FirebaseFirestore.instance.collection(FirebaseManager.collectionName);

/*  Future<void> addContact(String name, String phone) {
    return _contactsCollection.add({'name': name, 'phone': phone});
  }

  Future<void> deleteContact(String id) {
    return _contactsCollection.doc(id).delete();
  }*/

  Stream<List<UserModel>> getUsers() {
    return _contactsCollection.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) {
          if (doc.exists) {
            // print(doc.data());
            return UserModel.fromJson(
                doc.data() as Map<String, dynamic>);
          } else {
            throw Exception('Document does not exist');
          }
        }).toList());
  }

 /* Future<void> updateContact(String id, String name, String phone) {
    return _contactsCollection.doc(id).update({'name': name, 'phone': phone});
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();

  }

  Future<void> clearAll() async {
    // Clear all implementation
    // FirebaseFirestore.instance.co
    _contactsCollection.get().then((snapshot) {
      for (DocumentSnapshot contact in snapshot.docs) {
        contact.reference.delete();
      }
    });
    await FirebaseAuth.instance.signOut();
  }

  Future<bool> login (String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> register (String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      return false;
    }
  }*/
}