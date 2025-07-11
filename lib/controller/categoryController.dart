import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laptop_harbor/model/category_model.dart';

class Categorycontroller extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  var CategoryList = <CategoryModel>[].obs;

  // Add Category
  Future<void> AddCategory(String name) async {
    try {
      DocumentReference docRef = firestore.collection('category').doc();
      CategoryModel newCategory = CategoryModel(
        categoryId: docRef.id,
        categoryName: name,
      );

      await docRef.set(newCategory.toMap());
      Get.snackbar(
        '✅ Success',
        'Category added successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 20,
        icon: const Icon(
          Icons.check_circle_outline,
          color: Colors.white,
          size: 28,
        ),
        shouldIconPulse: false,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        barBlur: 10,
        duration: const Duration(seconds: 4),
        isDismissible: true,
        forwardAnimationCurve: Curves.easeOutBack,
        snackStyle: SnackStyle.FLOATING,
      );
    } catch (e) {
      Get.snackbar(
        '❌ Error',
        'Something went wrong $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 20,
        icon: const Icon(
          Icons.error_outline,
          color: Colors.redAccent,
          size: 28,
        ),
        shouldIconPulse: false,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        barBlur: 10,
        duration: const Duration(seconds: 4),
        isDismissible: true,
        forwardAnimationCurve: Curves.easeOutBack,
        snackStyle: SnackStyle.FLOATING,
      );
    }
  }

  // Fetch Category
  Future<void> FetchCategory() async {
    try {
      QuerySnapshot snapshot = await firestore.collection('category').get();
      var catList =
          snapshot.docs.map((doc) {
            return CategoryModel.fromMap(doc.data() as Map<String, dynamic>);
          }).toList();
      CategoryList.value = catList;
    } catch (e) {
      Get.snackbar(
        '❌ Error',
        'Something went wrong $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 20,
        icon: const Icon(
          Icons.error_outline,
          color: Colors.redAccent,
          size: 28,
        ),
        shouldIconPulse: false,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        barBlur: 10,
        duration: const Duration(seconds: 4),
        isDismissible: true,
        forwardAnimationCurve: Curves.easeOutBack,
        snackStyle: SnackStyle.FLOATING,
      );
    }
  }
}
