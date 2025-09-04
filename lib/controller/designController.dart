import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:laptop_harbor/model/design_model.dart';
import 'package:laptop_harbor/userPanel/Widgets/SnackBar.dart';

class DesignController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  var designList = <designModel>[].obs;

  // ✅ Add Design with Category
  Future<void> addDesign({
  required String designName,
  required String designDesc,
  required Uint8List designImage,
  required String designCategory,
}) async {
  try {
    final image = base64Encode(designImage);
    DocumentReference docRef = firestore.collection('design').doc();
    designModel newdesign = designModel(
      designId: docRef.id,
      designName: designName,
      designDesc: designDesc,
      designImage: image,
      designCategory: designCategory,
    );

    await docRef.set(newdesign.toMap());
    greenSnackBar('✅ Success!', 'Design added successfully');
  } catch (e) {
    redSnackBar('❌ Error!', 'Something went wrong $e');
  }
}

  // ✅ Fetch All Designs
  Future<void> fetchDesigns() async {
    try {
      QuerySnapshot snapshot = await firestore.collection('design').get();
      var proList = snapshot.docs.map((doc) {
        return designModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
      designList.value = proList;
    } catch (e) {
      redSnackBar('❌ Error!', 'Something went wrong $e');
    }
  }

  // ✅ Fetch Designs by Category
  Future<void> fetchDesignsByCategory(String category) async {
    try {
      QuerySnapshot snapshot;
      if (category == "All") {
        snapshot = await firestore.collection('design').get();
      } else {
        snapshot = await firestore
            .collection('design')
            .where("designCategory", isEqualTo: category)
            .get();
      }

      var filteredList = snapshot.docs.map((doc) {
        return designModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
      designList.value = filteredList;
    } catch (e) {
      redSnackBar('❌ Error!', 'Something went wrong $e');
    }
  }

  // ✅ Update Design
  Future<void> updateDesign({
    required String designId,
    required String designName,
    required String designDesc,
    required String designCategory, // added
    required Uint8List designImage,
  }) async {
    try {
      await firestore.collection('design').doc(designId).update({
        'designName': designName,
        'designDesc': designDesc,
        'designCategory': designCategory,
        'designImage': base64Encode(designImage),
      });
      fetchDesigns();
    } catch (e) {
      redSnackBar('❌ Error!', 'Update failed $e');
    }
  }

  // ✅ Delete Design
  Future<void> deleteDesign(String designId) async {
    try {
      await firestore.collection('design').doc(designId).delete();
      fetchDesigns();
    } catch (e) {
      redSnackBar('❌ Error!', 'Delete failed $e');
    }
  }
}
