import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laptop_harbor/Admin/admin_products.dart';
import 'package:laptop_harbor/controller/categoryController.dart';
import 'package:laptop_harbor/controller/productController.dart';
import 'package:laptop_harbor/userPanel/Widgets/button.dart';

class AddProduct extends StatefulWidget {
  AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _formKey = GlobalKey<FormState>();
  Categorycontroller categorycontroller = Get.put(Categorycontroller());
  Productcontroller productcontroller = Get.put(Productcontroller());
  final TextEditingController productName = TextEditingController();
  final TextEditingController productDesc = TextEditingController();
  final TextEditingController productPrice = TextEditingController();

  String? selectedCategory;
  ImagePicker imagePicker = ImagePicker();
  XFile? image;

  @override
  void initState() {
    super.initState();
    categorycontroller.FetchCategory();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Add Product',
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 360,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name field
                        TextFormField(
                          controller: productName,
                          decoration: const InputDecoration(
                            hintText: 'Enter your product name',
                            hintStyle: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            if (value.length < 3) {
                              return 'Name must be at least 3 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),

                        TextFormField(
                          controller: productDesc,
                          decoration: const InputDecoration(
                            hintText: 'Enter your product description',
                            hintStyle: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          maxLines: 3, // allows multiline description
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter a product description';
                            }
                            if (value.trim().length < 3) {
                              return 'Description must be at least 3 characters long';
                            }
                            if (value.trim().length > 500) {
                              return 'Description must not exceed 500 characters';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 30),

                        TextFormField(
                          controller: productPrice,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'Enter your product price',
                            hintStyle: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter the product price';
                            }
                            final parsedPrice = double.tryParse(value.trim());
                            if (parsedPrice == null || parsedPrice <= 0) {
                              return 'Please enter a valid positive number';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 30),

                        GestureDetector(
                          onTap: () async {
                            image = await imagePicker.pickImage(
                              source: ImageSource.gallery,
                            );
                            setState(() {});
                          },
                          child: Container(
                            height: 150,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              image:
                                  image != null
                                      ? DecorationImage(
                                        image: FileImage(File(image!.path)),
                                        fit: BoxFit.cover,
                                      )
                                      : null,
                            ),
                            alignment: Alignment.center,
                            child:
                                image == null
                                    ? Text(
                                      'Tap to upload an image',
                                      style: TextStyle(color: Colors.grey),
                                    )
                                    : Text(image!.name),
                          ),
                        ),
                        if (image == null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              'Image is required',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        const SizedBox(height: 30),

                        // Category Dropdown
                        Obx(
                          () => DropdownButtonFormField<String>(
                            value: selectedCategory,
                            items:
                                categorycontroller.CategoryList.map((cat) {
                                  return DropdownMenuItem<String>(
                                    value: cat.categoryId,
                                    child: Text(cat.categoryName),
                                  );
                                }).toList(),
                            onChanged: (val) {
                              setState(() {
                                selectedCategory = val!;
                              });
                            },
                            decoration: const InputDecoration(
                              hintText: 'Select product category',
                              hintStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a category';
                              }
                              return null;
                            },
                          ),
                        ),

                        const SizedBox(height: 30),
                        // Submit button
                        Center(
                          child: MyButton(
                            title: 'Add',
                            height: 50,
                            onPressed: () async {
                              if (_formKey.currentState!.validate() &&
                                  image != null) {
                                final imageFile = await image!.readAsBytes();
                                productcontroller.AddProduct(
                                  productName: productName.text.trim(),
                                  productDesc: productDesc.text.trim(),
                                  productPrice: productPrice.text.trim(),
                                  productImage: imageFile,
                                  productCategory: selectedCategory!,
                                );
                                Get.snackbar(
                                  '✅ Success',
                                  'Category added successfully!',
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
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 18,
                                  ),
                                  barBlur: 10,
                                  duration: const Duration(seconds: 4),
                                  isDismissible: true,
                                  forwardAnimationCurve: Curves.easeOutBack,
                                  snackStyle: SnackStyle.FLOATING,
                                );
                                Get.to(AdminProductsPage());
                              } else {
                                Get.snackbar(
                                  '❌ Error',
                                  'Please fill out the field correctly.',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.black,
                                  colorText: Colors.white,
                                  margin: const EdgeInsets.all(16),
                                  borderRadius: 20,
                                  icon: const Icon(
                                    Icons.error_outline,
                                    color: Colors.redAccent,
                                    size: 28,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 18,
                                  ),
                                  barBlur: 10,
                                  duration: const Duration(seconds: 4),
                                  isDismissible: true,
                                  forwardAnimationCurve: Curves.easeOutBack,
                                  snackStyle: SnackStyle.FLOATING,
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
