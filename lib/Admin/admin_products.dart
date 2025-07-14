import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laptop_harbor/Admin/add_product.dart';
import 'package:laptop_harbor/controller/categoryController.dart';
import 'package:laptop_harbor/controller/productController.dart';
import 'package:laptop_harbor/model/product_model.dart';
import 'package:laptop_harbor/userPanel/Widgets/button.dart';
import 'package:laptop_harbor/userPanel/constant.dart';

class AdminProductsPage extends StatelessWidget {
  Productcontroller productcontroller = Get.put(Productcontroller());
  Categorycontroller categorycontroller = Get.put(Categorycontroller());
  AdminProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    categorycontroller.FetchCategory().then((_) {
      productcontroller.FetchProduct();
    });
    productcontroller.FetchProduct();
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
            MyButton(title: 'Add Product', onPressed: () => Get.to(AddProduct())),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (productcontroller.ProductList.isEmpty) {
                return Center(child: Text('No Data Found'));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: productcontroller.ProductList.length,
                itemBuilder: (context, index) {
                  ProductModel productModel =
                      productcontroller.ProductList[index];
                  Uint8List productImage = base64Decode(
                    productModel.productImage,
                  );

                  return Card(
                    elevation: 4,
                    margin: EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product Image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.memory(
                              productImage,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 12),
                          // Product Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  productModel.productName,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  productModel.productDesc,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  "Rs. ${productModel.productPrice}",
                                  style: TextStyle(
                                    color: Colors.green[700],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Category: ${categorycontroller.CategoryMap[productModel.categoryId] ?? 'Unknown'}",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Action Buttons
                          Column(
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.edit, color: Colors.blue),
                              ),
                               Tooltip(
                message: "Delete Category",
                child: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () async {
                    final confirm = await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Confirm Delete"),
                        content: const Text("Are you sure you want to delete this category?"),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
                          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Delete")),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      // TODO: call your delete method from controller
                      // categorycontroller.deleteCategory(categoryModel.categoryId);
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
            }),
          ),
        ],
      ),
    );
  }
}
