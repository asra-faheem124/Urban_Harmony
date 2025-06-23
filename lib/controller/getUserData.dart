import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class Getuserdatacontroller extends GetxController {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  Future<List<QueryDocumentSnapshot>> getuserdata(String uid) async{
    final QuerySnapshot userData = await firebaseFirestore.collection('User').where('id', isEqualTo: uid).get();
    return userData.docs;
  }
}