import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:yandex_map/data/src/local.dart';
import 'package:yandex_map/data/src/remote/firebase_manager.dart';
import 'package:yandex_map/model/user_model.dart';
part 'regi'
    'ster_event.dart';

part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  RegisterBloc() : super(RegisterState()) {
    on<UsernameChanged>(_onUsernameChanged);
    on<LocationChanged>(_onLocationChanged);
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<ConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<GroupSwitchChanged>(_onGroupSwitchChanged);
    on<GroupIdChanged>(_onGroupIdChanged);
    on<SelectImageRegisterEvent>(_selectImageRegister);
    on<RegisterSubmitted>(_uploadRegister);
  }

  void _onUsernameChanged(UsernameChanged event, Emitter<RegisterState> emit) {
    emit(state.copyWith(username: event.username));
  }

  void _onPasswordChanged(PasswordChanged event, Emitter<RegisterState> emit) {
    emit(state.copyWith(password: event.password));
  }

  void _onConfirmPasswordChanged(ConfirmPasswordChanged event, Emitter<RegisterState> emit) {
    emit(state.copyWith(confirmPassword: event.confirmPassword));
  }

  void _onGroupSwitchChanged(GroupSwitchChanged event, Emitter<RegisterState> emit) {
    if(event.isJoinGroup){
      emit(state.copyWith(isJoinGroup: event.isJoinGroup,groupId: ""));
    }else {
      emit(state.copyWith(isJoinGroup: false,groupId: generateRandomGroupId()));
    }
  }

  void _onGroupIdChanged(GroupIdChanged event, Emitter<RegisterState> emit) {
    emit(state.copyWith(groupId: event.groupId));
  }

  Future<void> _selectImageRegister(SelectImageRegisterEvent event, Emitter<RegisterState> emit) async {
    emit(state.copyWith(image: event.image, selectImage: event.selectImage));
  }

  Future<void> _uploadRegister(RegisterSubmitted event, Emitter<RegisterState> emit) async {
    try {
      emit(state.copyWith(status: RegisterStatus.loading));

      // Check if joining an existing group and the group ID exists
      if (state.isJoinGroup && state.groupId.isNotEmpty && state.groupId.length == 10) {
        if(!await FirebaseManager.checkIfGroupExists(state.groupId)){
          state.copyWith(status: RegisterStatus.fail, errorMessage: 'Group does not exist. Create a new group.');
        }
      }
      print("HHHHHHHHHHHHHHHHHHHHHHH");
      print(state.email);
      print(state.password);
      // Create the user
      UserCredential userCredential ;
      try{
         userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: state.email.trim(),
          password: state.password.trim(),
        );
      }catch(e){
        emit(state.copyWith(status: RegisterStatus.fail,errorMessage: e.toString()));
        return;
      }


      print("AAAAAAAAAAAAAAAAAAAAAAAA");
      print(userCredential.user.toString());

      // Get FCM token
      final String? fcmToken = await FirebaseMessaging.instance.getToken();

      print("TTTTTTTTTTTTT");
      print(fcmToken);

      // Upload image to Firebase Storage
      String imageUrl = '';
      if (state.selectImage != null) {
        imageUrl = await FirebaseManager.uploadPhotoToFirebase(state.selectImage!);
      }

      print("Iiiiiiiiiiiiiiiiiiiiiiiiii");
      print(imageUrl);
      print(state.groupId);
      final userData = UserModel(
        username: state.username,
        email: state.email.trim(),
        password: state.password.trim(),
        userId: userCredential.user!.uid,
        imageUrl: imageUrl,
        notificationToken: fcmToken??"",
        groupId: state.groupId,
        lat: state.lat,
        lon: state.lon,
      );

      // Save user info to Firestore
      await _firebaseFirestore.collection(FirebaseManager.collectionName).doc(userData.email).set(userData.toJson());

      SharedPrefsManager.saveUserData(userData);
      emit(state.copyWith(status: RegisterStatus.success));
    } catch (e) {
      print("EEEEEEEEEE");
      print(e);
      emit(state.copyWith(status: RegisterStatus.fail, errorMessage: e.toString()));
    }
  }

  FutureOr<void> _onEmailChanged(EmailChanged event, Emitter<RegisterState> emit) {
    emit(state.copyWith(email: event.email));
  }



  String generateRandomGroupId() {
    final random = Random();
    String randomString =  List.generate(10, (_) => random.nextInt(10).toString()).join();

    return randomString;

  }

  FutureOr<void> _onLocationChanged(LocationChanged event, Emitter<RegisterState> emit) {
    debugPrint("DDDDDDDDDDDDDDDDDDD");
    print(event.lat);
    print(event.lon);

    emit(state.copyWith(lat: event.lat,lon: event.lon));
  }


}
