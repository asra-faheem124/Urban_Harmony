import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:laptop_harbor/model/user_model.dart';

class Signupcontroller extends GetxController{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  //obscure
  var isVisible = false.obs;
  //signup method
  Future<UserCredential?> SignUpMethod(
    String name,
    String email,
    String password,
    String phoneNumber
  ) async {
    try{
      EasyLoading.show(status: 'Please Wait');
      //creating authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await userCredential.user!.sendEmailVerification();

      Usermodel usermodel = Usermodel(id: userCredential.user!.uid, name: name, email: email, password: password, phoneNumber: phoneNumber);

      //inserting data
      _firebaseFirestore.collection('User').doc(userCredential.user!.uid).set(usermodel.toMap());
      EasyLoading.dismiss();
      return userCredential;
    }on FirebaseAuthException catch(e){
      EasyLoading.dismiss();
      Get.snackbar('Error', e.message ?? 'Some error has occured...',
      snackPosition: SnackPosition.TOP,
      );
    }
    return null;
  }
}