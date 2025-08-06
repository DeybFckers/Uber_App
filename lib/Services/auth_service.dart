import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthService{

  final firebaseAuth = FirebaseAuth.instance;
  final firebaseStore = FirebaseFirestore.instance;

  Future<void> registerAccount({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async{
    try{
      UserCredential userCredential = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      String fullName = '${firstName} ${lastName}';

      await userCredential.user?.updateDisplayName(fullName);

      await firebaseStore
      .collection('users')
      .doc(userCredential.user!.uid)
      .set({
        'Name': fullName,
        'Email': email,
        'Photo': userCredential.user?.photoURL??'',
        'createdAt': DateTime.now(),
      });
      String defaultPhotoUrl = userCredential.user?.photoURL ??
          'https://ui-avatars.com/api/?name=${Uri.encodeComponent(fullName)}';

      Get.snackbar("Success", "Account successfully created");

    }catch (e){
      final err = e is FirebaseException ? e.message : e.toString();
      Get.snackbar("Error", err!,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.black,
      );
    }
  }

  Future<void>loginAccount({
    required String email,
    required String password,
  }) async{
    try{
      UserCredential userCredential = await firebaseAuth.signInWithEmailAndPassword
        (email: email, password: password);

      User? user = userCredential.user;

      final userDoc = await firebaseStore
        .collection('users')
        .doc(user!.uid)
        .get();

      String name = userDoc.data()?['Name']??'';
      String Email = userDoc.data()?['Email']??'';
      String photoUrl = userDoc.data()?['Photo'] ?? '';

      Get.snackbar("Success", "Login Successfully");

      // Get.offAll(() => Home(
      //   uid:user.uid,
      //   name: name,
      //   email: Email,
      //   photoUrl: photoUrl.isEmpty
      //       ? 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(name)}' // default avatar
      //       : photoUrl,
      // ));

    }catch(e){
      final err = e is FirebaseException ? e.message : e.toString();
      Get.snackbar("Error", err!,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}