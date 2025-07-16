import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laptop_harbor/controller/cartController.dart';
import 'package:laptop_harbor/controller/productController.dart';
import 'package:laptop_harbor/model/product_model.dart';
import 'package:laptop_harbor/userPanel/Checkout/Bar.dart';
import 'package:laptop_harbor/userPanel/Widgets/button.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  Productcontroller productcontroller = Get.put(Productcontroller());
  Cartcontroller cartcontroller = Get.put(Cartcontroller());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Center(
              child: Text(
                "My Cart",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            const Divider(color: Colors.grey),
            Expanded(
              child: ListView.separated(
                itemCount: productcontroller.ProductList.length,
                separatorBuilder:
                    (context, index) =>
                        const Divider(thickness: 1, color: Colors.grey),
                itemBuilder: (context, index) {
                  ProductModel productModel= productcontroller.ProductList[index];
                  Uint8List productImage = base64Decode(productModel.productImage);
                  return ListTile(
                    leading: Image.memory(productImage, width: 50, height: 50),
                    title: Text(
                      productModel.productName,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(productModel.productDesc),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.remove),
                            ),
                            // Text(
                            //   '${item.quantity}',
                            //   style: const TextStyle(fontSize: 16),
                            // ),
                            SizedBox(width: 4),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                shape: const CircleBorder(),
                              ),
                              child: Text(
                                "+",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: Text(
                     productModel.productPrice,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),
            MyButton(title: 'Go To Checkout', height: 50, onPressed: () {
              Get.to(StepperUI());
            },),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
