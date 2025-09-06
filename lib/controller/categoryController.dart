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
  }) async {
    try {
      DocumentReference docRef = firestore.collection('category').doc();
      CategoryModel newCategory = CategoryModel(
        categoryId: docRef.id,
        categoryName: categoryName,
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


Future<void> deleteCategory(String categoryId) async {
  await FirebaseFirestore.instance.collection('category').doc(categoryId).delete();
  FetchCategory(); // Refresh list after deletion
}

Future<void> updateCategory({
  required String categoryId,
  required String categoryName,
}) async {
  await FirebaseFirestore.instance.collection('category').doc(categoryId).update({
    'categoryName': categoryName,
  });
  FetchCategory(); 
}
}
