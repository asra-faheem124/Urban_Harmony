import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laptop_harbor/model/product_model.dart';

class Cartcontroller extends GetxController{
  var cartItems = <ProductModel>[].obs;

  void AddToCart(ProductModel product){
    cartItems.add(product);
     Get.snackbar(
        '✅ Success',
        'Item added successfully!',
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
  }

  void DeleteFromCart(ProductModel product){
    cartItems.remove(product);
     Get.snackbar(
        '✅ Success',
        'Item removed successfully!',
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
  }

  double get totalPrice => cartItems.fold(0, (sum, item) => sum+ double.parse(item.productPrice));
} 