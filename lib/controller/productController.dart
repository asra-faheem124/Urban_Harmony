import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laptop_harbor/model/product_model.dart';
import 'package:laptop_harbor/userPanel/Widgets/SnackBar.dart';

class Productcontroller extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  var ProductList = <ProductModel>[].obs;

  Future<void> AddProduct({
    required String productName,
    required String productDesc,
    required String productPrice,
    required Uint8List productImage,
    required String productCategory,
  }) async {
    try {
      final image = base64Encode(productImage);
      DocumentReference docRef = firestore.collection('products').doc();
      ProductModel newProduct = ProductModel(
        productId: docRef.id,
        productName: productName,
        productDesc: productDesc,
        productPrice: productPrice,
        productImage: image,
        categoryId: productCategory,
      );

      await docRef.set(newProduct.toMap());
      greenSnackBar('✅ Success!', 'Product added successfully');
    } catch (e) {
      redSnackBar('❌ Error!', 'Something went wrong $e');
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
      redSnackBar('❌ Error!', 'Something went wrong $e');
    }
  }

  Future<void> updateProduct({
  required String productId,
  required String productName,
  required String productDesc,
  required String productPrice,
  required Uint8List productImage,
  required String productCategory,
}) async {
  await FirebaseFirestore.instance.collection('products').doc(productId).update({
    'productName': productName,
    'productDesc': productDesc,
    'productPrice': productPrice,
    'productImage': base64Encode(productImage),
    'categoryId': productCategory,
  });
  FetchProduct(); // Refresh list
}

Future<void> deleteProduct(String productId) async {
  await FirebaseFirestore.instance.collection('products').doc(productId).delete();
  FetchProduct(); 
}

}
