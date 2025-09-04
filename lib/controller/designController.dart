import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:laptop_harbor/model/design_model.dart';

import 'package:laptop_harbor/userPanel/Widgets/SnackBar.dart';

class Designcontroller extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  var designList = <designModel>[].obs;

  Future<void> Adddesign({
    required String designName,
    required String designDesc,
    required Uint8List designImage,
   
  }) async {
    try {
      final image = base64Encode(designImage);
      DocumentReference docRef = firestore.collection('design').doc();
      designModel newdesign = designModel(
        designId: docRef.id,
        designName: designName,
        designDesc: designDesc,
        designImage: image,
        
      );

      await docRef.set(newdesign.toMap());
      greenSnackBar('✅ Success!', 'design added successfully');
    } catch (e) {
      redSnackBar('❌ Error!', 'Something went wrong $e');
    }
  }

  // Fetch design
  Future<void> Fetchdesign() async {
    try {
      QuerySnapshot snapshot = await firestore.collection('design').get();
      var proList =
          snapshot.docs.map((doc) {
            return designModel.fromMap(doc.data() as Map<String, dynamic>);
          }).toList();
      designList.value = proList;
    } catch (e) {
      redSnackBar('❌ Error!', 'Something went wrong $e');
    }
  }

  Future<void> updatedesign({
    required String designId,
    required String designName,
    required String designDesc,
    required String designPrice,
    required Uint8List designImage,
   
  }) async {
    await FirebaseFirestore.instance
        .collection('designs')
        .doc(designId)
        .update({
          'designName': designName,
          'designDesc': designDesc,
          'designPrice': designPrice,
          'designImage': base64Encode(designImage),
         
        });
    Fetchdesign(); // Refresh list
  }

  Future<void> deletedesign(String designId) async {
    await FirebaseFirestore.instance
        .collection('designs')
        .doc(designId)
        .delete();
    Fetchdesign();
  }
}
