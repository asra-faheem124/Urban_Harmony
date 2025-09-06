import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laptop_harbor/controller/design_category_controller.dart';
import 'package:laptop_harbor/model/design_category_model.dart';
import 'package:laptop_harbor/userPanel/constant.dart';
import 'package:laptop_harbor/userPanel/design_detail.dart';

class RoomsPage extends StatefulWidget {
  const RoomsPage({super.key});

  @override
  State<RoomsPage> createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> {
  final DesignCategoryController designCategoryController =
      Get.put(DesignCategoryController());

  String selectedCategory = "All";

  @override
  void initState() {
    super.initState();
    designCategoryController.FetchCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          User_Heading(title: 'Rooms Gallery'),

          // 🔹 Category Filter Chips
          Obx(() {
            // Build categories list dynamically
            final categories = [
              "All",
              ...designCategoryController.CategoryList
                  .map((cat) => cat.categoryName)
                  .toList(),
            ];

            return SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: selectedCategory == cat,
                      onSelected: (val) {
                        setState(() {
                          selectedCategory = cat;
                        });
                      },
                    ),
                  );
                },
              ),
            );
          }),

          const SizedBox(height: 10),

          // 🔹 Fetch Designs from Firestore
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: () {
                if (selectedCategory == "All") {
                  return FirebaseFirestore.instance
                      .collection("design")
                      .snapshots();
                } else {
                  // Find categoryId by selectedCategory name
                  final selectedCategoryId =
                      designCategoryController.CategoryList.firstWhere(
                    (cat) => cat.categoryName == selectedCategory,
                    orElse: () => DesignCategoryModel(
                      categoryId: "",
                      categoryName: "",
                    ),
                  ).categoryId;

                  if (selectedCategoryId.isEmpty) {
                    // No valid category found -> return empty stream
                    return const Stream<QuerySnapshot>.empty();
                  }

                  return FirebaseFirestore.instance
                      .collection("design")
                      .where("designCategory", isEqualTo: selectedCategoryId)
                      .snapshots();
                }
              }(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No designs available"));
                }

                final designs = snapshot.data!.docs;

                return GridView.builder(
                  padding: const EdgeInsets.all(10),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: designs.length,
                  itemBuilder: (context, index) {
                    final design =
                        designs[index].data() as Map<String, dynamic>;
                    final imageBase64 = design["designImage"];
                    final imageBytes = base64Decode(imageBase64);

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                DesignDetailPage(designData: design),
                          ),
                        );
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                                child: Image.memory(
                                  imageBytes,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                design["designName"] ?? "",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

