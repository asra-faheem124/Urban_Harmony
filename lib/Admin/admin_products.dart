import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laptop_harbor/Admin/add_product.dart';
import 'package:laptop_harbor/controller/categoryController.dart';
import 'package:laptop_harbor/controller/productController.dart';
import 'package:laptop_harbor/model/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laptop_harbor/userPanel/Widgets/button.dart';
import 'package:laptop_harbor/userPanel/constant.dart';

class AdminProductsPage extends StatelessWidget {
  final Productcontroller productcontroller = Get.put(Productcontroller());
  final Categorycontroller categorycontroller = Get.put(Categorycontroller());

  AdminProductsPage({super.key});

  Future<double> fetchAverageRating(String productId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('ratings')
        .where('productId', isEqualTo: productId)
        .get();

    if (snapshot.docs.isEmpty) return 0.0;

    double total = 0;
    for (var doc in snapshot.docs) {
      total += (doc['rating'] ?? 0).toDouble();
    }

    return total / snapshot.docs.length;
  }

  Widget buildRatingStars(double rating) {
    return Row(
      children: List.generate(5, (index) {
        if (index < rating.floor()) {
          return const Icon(Icons.star, size: 16, color: Colors.amber);
        } else if (index < rating && (rating - index) >= 0.5) {
          return const Icon(Icons.star_half, size: 16, color: Colors.amber);
        } else {
          return const Icon(Icons.star_border, size: 16, color: Colors.amber);
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    categorycontroller.FetchCategory().then((_) {
      productcontroller.FetchProduct();
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Admin_Heading(title: 'Products'),
                MyButton(
                  title: 'Add Product',
                  height: 40,
                  onPressed: () => Get.to(AddProduct()),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (productcontroller.ProductList.isEmpty) {
                return const Center(child: Text('No Data Found'));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: productcontroller.ProductList.length,
                itemBuilder: (context, index) {
                  final product = productcontroller.ProductList[index];
                  final productImage = base64Decode(product.productImage);

                  return FutureBuilder<double>(
                    future: fetchAverageRating(product.productId),
                    builder: (context, snapshot) {
                      final avgRating = snapshot.data ?? 0.0;

                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.memory(
                                  productImage,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.productName,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      product.productDesc,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: Colors.grey[700]),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      "Rs. ${product.productPrice}",
                                      style: TextStyle(
                                        color: Colors.green[700],
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Category: ${categorycontroller.CategoryMap[product.categoryId] ?? 'Unknown'}",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        buildRatingStars(avgRating),
                                        const SizedBox(width: 6),
                                        Text(
                                          avgRating.toStringAsFixed(1),
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      // TODO: Navigate to edit page
                                    },
                                    icon: const Icon(Icons.edit, color: Colors.blue),
                                  ),
                                  Tooltip(
                                    message: "Delete Product",
                                    child: IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                                      onPressed: () async {
                                        final confirm = await showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text("Confirm Delete"),
                                            content: const Text("Are you sure you want to delete this product?"),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context, false),
                                                child: const Text("Cancel"),
                                              ),
                                              TextButton(
                                                onPressed: () => Navigator.pop(context, true),
                                                child: const Text("Delete"),
                                              ),
                                            ],
                                          ),
                                        );
                                        if (confirm == true) {
                                          // TODO: call delete method
                                          // productcontroller.deleteProduct(product.productId);
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
