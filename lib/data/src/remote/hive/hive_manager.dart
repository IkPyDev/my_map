
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';

import 'contact_model_hive.dart';

class HiveManager {
  static const String contactBoxName = 'contactsBox';
  static const String userBoxName = 'userBox';

  // static final box = Hive.box<ContactModelHive>(contactBoxName);

  //
  // Future<void> initHive() async {
  //   final appDocumentDir = await getApplicationDocumentsDirectory();
  //    Hive.init(appDocumentDir.path);
  //   Hive.registerAdapter(ContactModelHiveAdapter());
  //   await Hive.open
  //
  //   Box<ContactModelHive>(contactBoxName);
  //   await Hive.openBox(userBoxName);
  // }

  addContact(String name,String number) async {
    final box = Hive.box<ContactModelHive>(contactBoxName);
    var con = ContactModelHive(name: name, number:number,id:DateTime.now().millisecondsSinceEpoch & 0xFFFFFFFF,  );
     box.add(con);
  }

  updateContact(ContactModelHive contact)  {
    // final box = Hive.box<ContactModelHive>(contactBoxName);
    // final Map<dynamic, ContactModelHive> deliveriesMap = box.toMap();
    // dynamic desiredKey;
    // deliveriesMap.forEach((key, value){
    //   if (value.id == contact.id) {
    //     desiredKey = key;
    //   }
    // });
    //  box.put(desiredKey, contact);
    contact.save();
  }

  deleteContact(int id)  {

    void delete(int key) {
      final box = Hive.box('contact');
      box.delete(key);
    }
    // print("delete $id  bolmoqda "  );
    final box = Hive.box<ContactModelHive>(contactBoxName);
    // print("all keys ${box.keys.toList()} " );
    //  box.delete(box.values.firstWhere((element) => element.id == id));
    final Map<dynamic, ContactModelHive> contacts = box.toMap();
    dynamic desiredKey;
    contacts.forEach((key, value){
      if (value.id == id) {
        desiredKey = key;
      }
    });
    box.delete(desiredKey);
  }

  List<ContactModelHive> getContacts()  {
    final box = Hive.box<ContactModelHive>(contactBoxName);
    // print(box.keys.toList());
    var a = List.generate(box.length, (index) => box.getAt(index)!);
    // print("get contacts $a");
    return a;
  }

  close()  {
     Hive.close();
  }

  deleteAll()  {
    final boxContact = Hive.box<ContactModelHive>(contactBoxName);
    final boxUser = Hive.box(userBoxName);
    boxContact.deleteFromDisk();
     boxUser.deleteFromDisk();

  }

  bool isLogin()  {
    final box = Hive.box(userBoxName);
    return box.isNotEmpty;
  }

  bool addUser(String login, String password)  {
    final box = Hive.box(userBoxName);
    var a =  box.add({'login': login, 'password': password});
    // print("add $a user $login $password");
    return true;
  }

  deleteAllUser()  {
    final box = Hive.box(userBoxName);
     box.clear();
  }

  bool checkUser(String login, String password)  {
    final box = Hive.box(userBoxName);
    var map = box.values.where((element) => element['login'] == login && element['password'] == password);
    // print("check user $map"  );
    return map.isNotEmpty;
  }


}