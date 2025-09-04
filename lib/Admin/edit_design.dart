import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laptop_harbor/Admin/admin_products.dart';
import 'package:laptop_harbor/controller/designController.dart';
import 'package:laptop_harbor/controller/design_category_controller.dart';
import 'package:laptop_harbor/model/design_model.dart';
import 'package:laptop_harbor/userPanel/Widgets/SnackBar.dart';
import 'package:laptop_harbor/userPanel/Widgets/button.dart';
import 'package:laptop_harbor/userPanel/constant.dart';

class EditDesignPage extends StatefulWidget {
  final designModel product;

  const EditDesignPage({super.key, required this.product});

  @override
  State<EditDesignPage> createState() => _EditDesignPageState();
}

class _EditDesignPageState extends State<EditDesignPage> {
  final _formKey = GlobalKey<FormState>();
  final DesignController designcontroller = Get.put(DesignController());
  final DesignCategoryController categoryController = Get.put(DesignCategoryController());

  final TextEditingController productName = TextEditingController();
  final TextEditingController productDesc = TextEditingController();

  ImagePicker imagePicker = ImagePicker();
  XFile? image;
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    productName.text = widget.product.designName;
    productDesc.text = widget.product.designDesc;
    selectedCategory = widget.product.designCategory; // pre-fill category
    categoryController.FetchCategory(); // fetch categories for dropdown
  }

  @override
  Widget build(BuildContext context) {
    Uint8List defaultImage = base64Decode(widget.product.designImage);

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
                Admin_Heading(title: 'Edit Design'),
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
                            hintText: 'Enter your design name',
                            hintStyle: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Please enter your design name';
                            if (value.length < 3) return 'Name must be at least 3 characters';
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),

                        // Product description
                        TextFormField(
                          controller: productDesc,
                          decoration: const InputDecoration(
                            hintText: 'Enter your design description',
                            hintStyle: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          maxLines: 3,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) return 'Please enter a design description';
                            if (value.trim().length < 3) return 'Description must be at least 3 characters';
                            if (value.trim().length > 500) return 'Description must not exceed 500 characters';
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),

                        // Category Dropdown
                        Obx(() {
                          if (categoryController.CategoryList.isEmpty) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          return DropdownButtonFormField<String>(
                            value: selectedCategory,
                            items: categoryController.CategoryList.map((cat) {
                              return DropdownMenuItem<String>(
                                value: cat.categoryId,
                                child: Text(cat.categoryName),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setState(() {
                                selectedCategory = val;
                              });
                            },
                            decoration: const InputDecoration(
                              hintText: 'Select design category',
                              hintStyle: TextStyle(fontSize: 16, color: Colors.black),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a category';
                              }
                              return null;
                            },
                          );
                        }),
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

                        // Submit
                        Center(
                          child: MyButton(
                            title: 'Update',
                            height: 50.0,
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                Uint8List updatedImage = image != null
                                    ? await image!.readAsBytes()
                                    : defaultImage;

                                await designcontroller.updateDesign(
                                  designId: widget.product.designId,
                                  designName: productName.text.trim(),
                                  designDesc: productDesc.text.trim(),
                                  designImage: updatedImage,
                                  designCategory: selectedCategory!, // ✅ added category update
                                );

                                greenSnackBar('Success!', 'Design updated successfully!');
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
