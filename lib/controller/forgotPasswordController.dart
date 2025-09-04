import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:laptop_harbor/userPanel/Widgets/SnackBar.dart';

class Forgotpasswordcontroller extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> ForgotPassword(String useremail) async {
    try {
      EasyLoading.show(status: 'Please Wait');
      await _auth.sendPasswordResetEmail(email: useremail);
      update();
      EasyLoading.dismiss();
      greenSnackBar(
        'Request sent successfully',
        'Password reset link sent to $useremail',
      );
    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();
      redSnackBar('Error', e.message ?? 'Some error has occured');
    }
  }
}
