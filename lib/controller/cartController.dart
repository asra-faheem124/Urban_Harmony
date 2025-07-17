import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laptop_harbor/model/product_model.dart';
import 'package:laptop_harbor/userPanel/BottomBar.dart';
import 'package:laptop_harbor/userPanel/Widgets/SnackBar.dart';

class Cartcontroller extends GetxController {
  var cartItems = <ProductModel, int>{}.obs;

  void AddToCart(ProductModel product) {
    if (cartItems.containsKey(product)) {
      cartItems[product] = cartItems[product]! + 1;
    } else {
      cartItems[product] = 1;
    }
    greenSnackBar('✅ Success!', 'Item is added to cart successfully.');
  }

  void RemoveFromCart(ProductModel product) {
    if (cartItems.containsKey(product)) {
      cartItems.remove(product);
    }
    greenSnackBar('✅ Success!', 'Item is removed from cart successfully');
  }

  void ClearCart() {
    cartItems.clear();
  }

  double get totalPrice => cartItems.entries
      .map((e) => double.parse(e.key.productPrice) * e.value)
      .fold(0.0, (a, b) => a + b);
}
