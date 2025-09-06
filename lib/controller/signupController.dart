import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:laptop_harbor/model/user_model.dart';
import 'package:laptop_harbor/userPanel/Widgets/SnackBar.dart';

class Signupcontroller extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  var isVisible = false.obs;

  Future<UserCredential?> signUpMethod(
    String name,
    String email,
    String password,
    String phoneNumber,
    String role, {
    String? bio,
    String? profilePic,
  }) async {
    try {
      EasyLoading.show(status: 'Please Wait');

      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user!.sendEmailVerification();

      UserModel usermodel = UserModel(
        id: userCredential.user!.uid,
        name: name,
        email: email,
        password: password,
        phoneNumber: phoneNumber,
        role: role,
        bio: bio,
        profilePic: profilePic,
        portfolio: [],
        availability: [],
      );

      await _firebaseFirestore
          .collection('User')
          .doc(userCredential.user!.uid)
          .set(usermodel.toMap());

      EasyLoading.dismiss();
      return userCredential;
    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();
      redSnackBar('Error!', e.message ?? 'Some error has occured');
    }
    return null;
  }
}
