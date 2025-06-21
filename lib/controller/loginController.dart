import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class Logincontroller extends GetxController{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  //obscure
  var isVisible = false.obs;
  //signup method
  Future<UserCredential?> LogInMethod(
    String email,
    String password,
  ) async {
    try{
      EasyLoading.show(status: 'Please Wait');
      //creating authentication
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      EasyLoading.dismiss();
      return userCredential;
    }on FirebaseAuthException catch(e){
      EasyLoading.dismiss();
      Get.snackbar('Error', e.message ?? 'Some error has occured...',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.black,
      colorText: Colors.white,
      margin: EdgeInsets.all(16),
      borderRadius: 8,
      icon: Icon(Icons.error, color: Colors.white,)
      );
    }
    return null;
  }
}