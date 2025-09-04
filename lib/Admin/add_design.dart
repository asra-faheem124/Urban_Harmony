import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laptop_harbor/Admin/admin_design.dart';
import 'package:laptop_harbor/controller/designController.dart';
import 'package:laptop_harbor/controller/design_category_controller.dart';
import 'package:laptop_harbor/userPanel/Widgets/SnackBar.dart';
import 'package:laptop_harbor/userPanel/Widgets/button.dart';
import 'package:laptop_harbor/userPanel/constant.dart';

class Adddesign extends StatefulWidget {
  Adddesign({super.key});

  @override
  State<Adddesign> createState() => _AdddesignState();
}

class _AdddesignState extends State<Adddesign> {
  final _formKey = GlobalKey<FormState>();
  final DesignController designcontroller = Get.put(DesignController());
  final DesignCategoryController categorycontroller = Get.put(DesignCategoryController());

  final TextEditingController designName = TextEditingController();
  final TextEditingController designDesc = TextEditingController();

  String? selectedCategory; // ✅ category id
  ImagePicker imagePicker = ImagePicker();
  XFile? image;

  @override
  void initState() {
    super.initState();
    categorycontroller.FetchCategory(); // ✅ Load categories
  }

  @override
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
                Admin_Heading(title: 'Add Design'),
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
                          controller: designName,
                          decoration: const InputDecoration(
                            hintText: 'Enter your design name',
                            hintStyle: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter design name';
                            }
                            if (value.length < 3) {
                              return 'Name must be at least 3 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),

                        // Description
                        TextFormField(
                          controller: designDesc,
                          decoration: const InputDecoration(
                            hintText: 'Enter design description',
                            hintStyle: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          maxLines: 3,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter description';
                            }
                            if (value.trim().length < 3) {
                              return 'Description must be at least 3 characters';
                            }
                            if (value.trim().length > 500) {
                              return 'Description must not exceed 500 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),

                        // Image Picker
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
                                  : null,
                            ),
                            alignment: Alignment.center,
                            child: image == null
                                ? const Text('Tap to upload an image', style: TextStyle(color: Colors.grey))
                                : Text(image!.name),
                          ),
                        ),
                        if (image == null)
                          const Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Text('Image is required', style: TextStyle(color: Colors.red)),
                          ),
                        const SizedBox(height: 30),

                        // Category Dropdown
                        Obx(() {
                          if (categorycontroller.CategoryList.isEmpty) {
                            return const Center(child: Text("No categories available"));
                          }
                          return DropdownButtonFormField<String>(
                            value: selectedCategory,
                            items: categorycontroller.CategoryList.map((cat) {
                              return DropdownMenuItem<String>(
                                value: cat.categoryId, // ✅ store ID
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

                        // Submit Button
                        Center(
                          child: MyButton(
                            title: 'Add',
                            height: 50.0,
                            onPressed: () async {
                              if (_formKey.currentState!.validate() && image != null && selectedCategory != null) {
                                final imageFile = await image!.readAsBytes();
                                await designcontroller.addDesign(
                                  designName: designName.text.trim(),
                                  designDesc: designDesc.text.trim(),
                                  designImage: imageFile,
                                  designCategory: selectedCategory!, // ✅ Save category
                                );
                                greenSnackBar('Success!', 'Design Added Successfully.');
                                Get.to(() => AdminDesignPage());
                              } else {
                                redSnackBar('Error', 'Please fill out all fields and upload an image.');
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
