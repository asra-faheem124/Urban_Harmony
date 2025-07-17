import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:laptop_harbor/model/category_model.dart';
import 'package:laptop_harbor/userPanel/Widgets/SnackBar.dart';

class Categorycontroller extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  var CategoryList = <CategoryModel>[].obs;
  var CategoryMap = <String, String>{}.obs;

  // Add Category
  Future<void> AddCategory({
    required String categoryName,
    required Uint8List categoryImage,
  }) async {
    try {
      final image = base64Encode(categoryImage);
      DocumentReference docRef = firestore.collection('category').doc();
      CategoryModel newCategory = CategoryModel(
        categoryId: docRef.id,
        categoryName: categoryName,
        categoryImage: image,
      );

      await docRef.set(newCategory.toMap());
      greenSnackBar('✅ Success!', 'Category added successfully');
    } catch (e) {
      redSnackBar('❌ Error', 'Something went wrong $e');
    }
  }

  // Fetch Category
  Future<void> FetchCategory() async {
    try {
      QuerySnapshot snapshot = await firestore.collection('category').get();
      var catList =
          snapshot.docs.map((doc) {
            var data = doc.data() as Map<String, dynamic>;
            CategoryMap[data['categoryId']] = data['categoryName'];
            return CategoryModel.fromMap(doc.data() as Map<String, dynamic>);
          }).toList();
      CategoryList.value = catList;
    } catch (e) {
      redSnackBar('❌ Error', 'Something went wrong $e');
    }
  }
}
