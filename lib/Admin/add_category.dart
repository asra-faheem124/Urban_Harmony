import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laptop_harbor/Admin/admin_category.dart';
import 'package:laptop_harbor/controller/categoryController.dart';
import 'package:laptop_harbor/userPanel/Widgets/button.dart';
import 'package:laptop_harbor/userPanel/constant.dart';

class AddCategoryPage extends StatefulWidget {
  AddCategoryPage({super.key});

  @override
  State<AddCategoryPage> createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Categorycontroller categorycontroller = Get.put(Categorycontroller());

  final TextEditingController categoryName = TextEditingController();

  String? selectedCategory;

  ImagePicker imagePicker = ImagePicker();

  XFile? image;

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Admin_Heading(title: 'Add Category')
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
                          controller: categoryName,
                          decoration: const InputDecoration(
                            hintText: 'Enter your category name',
                            hintStyle: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your category name';
                            }
                            if (value.length < 3) {
                              return 'Name must be at least 3 characters';
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
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey
                                )
                              ),
                              image:
                                  image != null
                                      ? DecorationImage(
                                        image: FileImage(File(image!.path)),
                                        fit: BoxFit.cover,
                                      )
                                      : null,
                            ),
                            alignment: Alignment.center,
                            child: image == null ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Tap to upload an image')
                              ],
                            ) : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(image!.name)
                              ],
                            )
                          ),
                        ),
                        SizedBox(height: 30,)
,                      
                        // Submit button
                        Center(
                          child: MyButton(title: 'Add', onPressed: () {
                             if (_formKey.currentState!.validate()) {
                              final cName = categoryName.text.trim();
                            categorycontroller.AddCategory(cName);
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
                                    Get.to(AdminCategoryPage());
                          }else{
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
                          }}),
                        )
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