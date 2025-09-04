import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laptop_harbor/Admin/admin_design.dart';
import 'package:laptop_harbor/controller/categoryController.dart';
import 'package:laptop_harbor/controller/designController.dart';
import 'package:laptop_harbor/controller/designController.dart';
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
  Categorycontroller categorycontroller = Get.put(Categorycontroller());
  Designcontroller designcontroller = Get.put(Designcontroller());
  final TextEditingController designName = TextEditingController();
  final TextEditingController designDesc = TextEditingController();
  final TextEditingController designPrice = TextEditingController();

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
                Admin_Heading(title: 'Add design'),
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
                          controller: designDesc,
                          decoration: const InputDecoration(
                            hintText: 'Enter your design description',
                            hintStyle: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          maxLines: 3, // allows multiline description
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter a design description';
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
                        // Obx(
                        //   () => DropdownButtonFormField<String>(
                        //     value: selectedCategory,
                        //     items:
                        //         categorycontroller.CategoryList.map((cat) {
                        //           return DropdownMenuItem<String>(
                        //             value: cat.categoryId,
                        //             child: Text(cat.categoryName),
                        //           );
                        //         }).toList(),
                        //     onChanged: (val) {
                        //       setState(() {
                        //         selectedCategory = val!;
                        //       });
                        //     },
                        //     decoration: const InputDecoration(
                        //       hintText: 'Select design category',
                        //       hintStyle: TextStyle(
                        //         fontSize: 16,
                        //         color: Colors.black,
                        //       ),
                        //     ),
                        //     validator: (value) {
                        //       if (value == null || value.isEmpty) {
                        //         return 'Please select a category';
                        //       }
                        //       return null;
                        //     },
                        //   ),
                        // ),

                        const SizedBox(height: 30),
                        // Submit button
                        Center(
                          child: MyButton(
                            title: 'Add',
                            height: 50.0,
                            onPressed: () async {
                              if (_formKey.currentState!.validate() &&
                                  image != null) {
                                final imageFile = await image!.readAsBytes();
                                designcontroller.Adddesign(
                                  designName: designName.text.trim(),
                                  designDesc: designDesc.text.trim(),
                                  
                                  designImage: imageFile,
                                  
                                );
                                greenSnackBar(
                                  'Success!',
                                  'design Added Successfully.',
                                );
                                Get.to(AdminDesignPage());
                              } else {
                                redSnackBar(
                                  'Error',
                                  'Please fill out all the fields correctly.',
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
