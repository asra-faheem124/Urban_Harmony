import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class Forgotpasswordcontroller extends GetxController{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> ForgotPassword(String useremail) async{
    try{
      EasyLoading.show(status: 'Please Wait');
      await _auth.sendPasswordResetEmail(email: useremail);
      update();
      EasyLoading.dismiss();
      Get.snackbar('Request sent successfully', 'Password reset link sent to $useremail',
        snackPosition: SnackPosition.TOP,
                                            backgroundColor: Colors.white,
                                            colorText: Colors.black,
                                            margin: EdgeInsets.all(16),
                                            borderRadius: 8,
                                            icon: Icon(
                                              Icons.check_circle,
                                              color: Colors.black,));
    }on FirebaseAuthException catch (e){
      EasyLoading.dismiss();
      Get.snackbar('Error', e.message ?? 'Some error has occured',
       snackPosition: SnackPosition.TOP,
                                          backgroundColor: Colors.black,
                                          colorText: Colors.white,
                                          margin: EdgeInsets.all(16),
                                          borderRadius: 8,
                                          icon: Icon(
                                            Icons.error,
                                            color: Colors.white,));
    }
  }
}