import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laptop_harbor/model/product_model.dart';

class Productcontroller extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ProductList = <ProductModel>[].obs;

  Future<void> AddProduct({
    required String productName,
    required String productDesc,
    required String productPrice,
    required Uint8List productImage,
    required String productCategory,
  } ) async {
    try{
      final image = base64Encode(productImage);
      DocumentReference docRef = firestore.collection('products').doc();
      ProductModel newProduct = ProductModel(productId: docRef.id, productName: productName, productDesc: productDesc, productPrice: productPrice, productImage: image, categoryId: productCategory);

      await docRef.set(newProduct.toMap());
        Get.snackbar(
        '✅ Success',
        'Product added successfully!',
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
    } catch(e){
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

// Fetch Product
  Future<void> FetchProduct() async {
    try {
      QuerySnapshot snapshot = await firestore.collection('products').get();
      var proList =
          snapshot.docs.map((doc) {
            return ProductModel.fromMap(doc.data() as Map<String, dynamic>);
          }).toList();
      ProductList.value = proList;
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

