import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laptop_harbor/Admin/add_design.dart';
import 'package:laptop_harbor/Admin/add_product.dart';
import 'package:laptop_harbor/Admin/edit_design.dart';
import 'package:laptop_harbor/Admin/products_edit.dart';
import 'package:laptop_harbor/controller/categoryController.dart';
import 'package:laptop_harbor/controller/designController.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laptop_harbor/userPanel/Widgets/SnackBar.dart';
import 'package:laptop_harbor/userPanel/Widgets/button.dart';
import 'package:laptop_harbor/userPanel/constant.dart';

class AdminDesignPage extends StatelessWidget {
  final DesignController designcontroller = Get.put(DesignController());
  final Categorycontroller categorycontroller = Get.put(Categorycontroller());

  AdminDesignPage({super.key});

  Future<double> fetchAverageRating(String productId) async {
    final snapshot =
        await FirebaseFirestore.instance
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
      designcontroller.fetchDesigns();
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
                Admin_Heading(title: 'Design'),
                MyButton(
                  title: 'Add Design',
                  height: 40.0,
                  onPressed: () => Get.to(Adddesign()),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (designcontroller.designList.isEmpty) {
                return const Center(child: Text('No Data Found'));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: designcontroller.designList.length,
                itemBuilder: (context, index) {
                  final product = designcontroller.designList[index];
                  final productImage = base64Decode(product.designImage);

                  return FutureBuilder<double>(
                    future: fetchAverageRating(product.designId),
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
                                      product.designName,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      product.designDesc,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: Colors.grey[700]),
                                    ),
                                    const SizedBox(height: 6),
                                    
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
                                      Get.to(EditDesignPage(product: product));
                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  Tooltip(
                                    message: "Delete Design",
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.redAccent,
                                      ),
                                      onPressed: () async {
                                        final confirm = await showDialog(
                                          context: context,
                                          builder:
                                              (context) => AlertDialog(
                                                title: const Text(
                                                  "Confirm Delete",
                                                ),
                                                content: const Text(
                                                  "Are you sure you want to delete this design?",
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed:
                                                        () => Navigator.pop(
                                                          context,
                                                          false,
                                                        ),
                                                    child: const Text("Cancel"),
                                                  ),
                                                  TextButton(
                                                    onPressed:
                                                        () => Navigator.pop(
                                                          context,
                                                          true,
                                                        ),
                                                    child: const Text("Delete"),
                                                  ),
                                                ],
                                              ),
                                        );
                                        if (confirm == true) {
                                          await designcontroller.deleteDesign(
                                            product.designId,
                                          );
                                          greenSnackBar(
                                            "Deleted",
                                            "Product deleted successfully",
                                          );
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
