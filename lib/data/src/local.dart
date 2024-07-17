import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsManager {
  static final SharedPrefsManager _instance = SharedPrefsManager._internal();

  factory SharedPrefsManager() {
    return _instance;
  }

  SharedPrefsManager._internal();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }


  Future<void> addUser(String user) async {
    await _prefs?.setString("user", user);
  }
  bool isUser() {
    return _prefs?.containsKey("user") ?? false;
  }

  String getUser(){
    return _prefs?.getString("user") ?? "";
  }
  // Login
  Future<void> login(
      String username, String password, String phoneNumber) async {
    await _prefs?.setString('username', username);
    await _prefs?.setString('password', password);
    await _prefs?.setString('phoneNumber', phoneNumber);
  }
  bool signIn(String username, String password) {
    var storedUsername = _prefs?.getString('username') ?? "";
    var storedPassword = _prefs?.getString('password') ?? "";
    return storedUsername == username && storedPassword == password;
  }

  Future<bool> isLoggedIn() async {
    return (_prefs?.containsKey('username') ?? false) &&
        (_prefs?.containsKey('password') ?? false);
  }

  Future<void> logout() async {
    await _prefs?.remove('username');
    await _prefs?.remove('password');
    await _prefs?.remove('phoneNumber');
  }

  // Contact Operations
  Future<void> addContact(String name, String number) async {
    List<String> contacts = _prefs?.getStringList('contacts') ?? [];
    contacts.add('$name:$number');
    await _prefs?.setStringList('contacts', contacts);
  }

  Future<List<Map<String, String>>> getContacts() async {
    List<String> contacts = _prefs?.getStringList('contacts') ?? [];
    return contacts.map((contact) {
      var parts = contact.split(':');
      return {'name': parts[0], 'number': parts[1]};
    }).toList();
  }

  Future<void> editContact(int index, String name, String number) async {
    List<String> contacts = _prefs?.getStringList('contacts') ?? [];
    if (index < contacts.length) {
      contacts[index] = '$name:$number';
      await _prefs?.setStringList('contacts', contacts);
    }
  }

  Future<void> deleteContact(int index) async {
    List<String> contacts = _prefs?.getStringList('contacts') ?? [];
    if (index < contacts.length) {
      contacts.removeAt(index);
      await _prefs?.setStringList('contacts', contacts);
    }
  }

  Future<void> clearAll() async {
    await _prefs?.clear();
  }
}