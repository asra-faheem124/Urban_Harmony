import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laptop_harbor/controller/cartController.dart';
import 'package:laptop_harbor/userPanel/Checkout/Bar.dart';
import 'package:laptop_harbor/userPanel/Widgets/button.dart';
import 'package:laptop_harbor/userPanel/constant.dart';

class Cart extends StatelessWidget {
  Cart({super.key});

  final Cartcontroller cartcontroller = Get.put(Cartcontroller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),

      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Obx(() {
          final cartItems = cartcontroller.cartItems;

          if (cartItems.isEmpty) {
            return const Center(
              child: Text("Your cart is empty."),
            );
          }

          return Column(
            children: [
              const Center(
                child: User_Heading(title: 'My Cart',)
              ),
              const SizedBox(height: 20),
              const Divider(color: Colors.grey),
              Expanded(
                child: ListView.separated(
                  itemCount: cartItems.length,
                  separatorBuilder: (context, index) =>
                      const Divider(thickness: 1, color: Colors.grey),
                  itemBuilder: (context, index) {
                    final product = cartItems.keys.toList()[index];
                    final quantity = cartItems[product]!;
                    Uint8List productImage = base64Decode(product.productImage);

                    return ListTile(
                      leading:
                          Image.memory(productImage, width: 50, height: 50),
                      title: Text(
                        product.productName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product.productDesc),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  if (quantity > 1) {
                                    cartcontroller.cartItems[product] =
                                        quantity - 1;
                                  } else {
                                    cartcontroller.RemoveFromCart(product);
                                  }
                                },
                              ),
                              Text(
                                '$quantity',
                                style: const TextStyle(fontSize: 16),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  cartcontroller.cartItems[product] =
                                      quantity + 1;
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: Text(
                        'PKR ${(double.parse(product.productPrice) * quantity).toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Total Price & Checkout
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'PKR ${cartcontroller.totalPrice.toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              MyButton(
                title: 'Go To Checkout',
                height: 50,
                onPressed: () {
                  Get.to(StepperUI());
                },
              ),
              const SizedBox(height: 20),
            ],
          );
        }),
      ),
    );
  }
}
