import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laptop_harbor/Admin/admin_products.dart';
import 'package:laptop_harbor/controller/categoryController.dart';
import 'package:laptop_harbor/controller/productController.dart';
import 'package:laptop_harbor/model/product_model.dart';
import 'package:laptop_harbor/userPanel/Widgets/SnackBar.dart';
import 'package:laptop_harbor/userPanel/Widgets/button.dart';
import 'package:laptop_harbor/userPanel/constant.dart';

class EditProductPage extends StatefulWidget {
  final ProductModel product;

  const EditProductPage({super.key, required this.product});

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final _formKey = GlobalKey<FormState>();
  final Categorycontroller categorycontroller = Get.put(Categorycontroller());
  final Productcontroller productcontroller = Get.put(Productcontroller());

  final TextEditingController productName = TextEditingController();
  final TextEditingController productDesc = TextEditingController();
  final TextEditingController productPrice = TextEditingController();

  ImagePicker imagePicker = ImagePicker();
  XFile? image;
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    categorycontroller.FetchCategory();
    productName.text = widget.product.productName;
    productDesc.text = widget.product.productDesc;
    productPrice.text = widget.product.productPrice;
    selectedCategory = widget.product.categoryId;
  }

  @override
  Widget build(BuildContext context) {
    Uint8List defaultImage = base64Decode(widget.product.productImage);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Admin_Heading(title: 'Edit Product'),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 360,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product name
                        TextFormField(
                          controller: productName,
                          decoration: const InputDecoration(
                            hintText: 'Enter your product name',
                            hintStyle: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Please enter your product name';
                            if (value.length < 3) return 'Name must be at least 3 characters';
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),

                        // Product description
                        TextFormField(
                          controller: productDesc,
                          decoration: const InputDecoration(
                            hintText: 'Enter your product description',
                            hintStyle: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          maxLines: 3,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) return 'Please enter a product description';
                            if (value.trim().length < 3) return 'Description must be at least 3 characters';
                            if (value.trim().length > 500) return 'Description must not exceed 500 characters';
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),

                        // Product price
                        TextFormField(
                          controller: productPrice,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'Enter your product price',
                            hintStyle: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) return 'Please enter the product price';
                            final parsedPrice = double.tryParse(value.trim());
                            if (parsedPrice == null || parsedPrice <= 0) return 'Enter a valid positive number';
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),

                        // Image upload
                        GestureDetector(
                          onTap: () async {
                            image = await imagePicker.pickImage(source: ImageSource.gallery);
                            setState(() {});
                          },
                          child: Container(
                            height: 150,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              image: image != null
                                  ? DecorationImage(
                                      image: FileImage(File(image!.path)),
                                      fit: BoxFit.cover,
                                    )
                                  : DecorationImage(
                                      image: MemoryImage(defaultImage),
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            alignment: Alignment.center,
                            child: image == null
                                ? const Text('Tap to upload a new image', style: TextStyle(color: Colors.grey))
                                : Text(image!.name),
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Category dropdown
                        Obx(
                          () => DropdownButtonFormField<String>(
                            value: selectedCategory,
                            items: categorycontroller.CategoryList.map((cat) {
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
                              hintStyle: TextStyle(fontSize: 16, color: Colors.black),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'Please select a category';
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Submit
                        Center(
                          child: MyButton(
                            title: 'Update',
                            height: 50,
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                Uint8List updatedImage = image != null
                                    ? await image!.readAsBytes()
                                    : defaultImage;

                                await productcontroller.updateProduct(
                                  productId: widget.product.productId,
                                  productName: productName.text.trim(),
                                  productDesc: productDesc.text.trim(),
                                  productPrice: productPrice.text.trim(),
                                  productImage: updatedImage,
                                  productCategory: selectedCategory!,
                                );

                                greenSnackBar('Success!', 'Product updated successfully!');
                                Get.off(() => AdminProductsPage());
                              } else {
                                redSnackBar('Error', 'Please fill out all fields correctly.');
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
