import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laptop_harbor/model/product_model.dart';
import 'package:laptop_harbor/userPanel/BottomBar.dart';

class Cartcontroller extends GetxController {
  var cartItems = <ProductModel, int>{}.obs;

  void AddToCart(ProductModel product) {
    if (cartItems.containsKey(product)) {
      cartItems[product] = cartItems[product]! + 1;
    } else {
      cartItems[product] = 1;
    }
    Get.snackbar(
      '✅ Success',
      'Item is added to cart successfully!',
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

  void RemoveFromCart(ProductModel product) {
    if (cartItems.containsKey(product)) {
      cartItems.remove(product);
    }
    Get.snackbar(
      '✅ Success',
      'Item is removed from cart successfully!',
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

  void ClearCart() {
    cartItems.clear();
  }

  double get totalPrice => cartItems.entries
      .map((e) => double.parse(e.key.productPrice) * e.value)
      .fold(0.0, (a, b) => a + b);
}
