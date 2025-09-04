import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laptop_harbor/Admin/admin_category.dart';
import 'package:laptop_harbor/Admin/admin_design_category.dart';
import 'package:laptop_harbor/controller/design_category_controller.dart';
import 'package:laptop_harbor/userPanel/Widgets/SnackBar.dart';
import 'package:laptop_harbor/userPanel/Widgets/button.dart';
import 'package:laptop_harbor/userPanel/constant.dart';

class AddDesignCategoryPage extends StatefulWidget {
  AddDesignCategoryPage({super.key});

  @override
  State<AddDesignCategoryPage> createState() => _AddDesignCategoryPageState();
}

class _AddDesignCategoryPageState extends State<AddDesignCategoryPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  DesignCategoryController categorycontroller = Get.put(DesignCategoryController());
  final TextEditingController categoryName = TextEditingController();

  ImagePicker imagePicker = ImagePicker();

  XFile? image;

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
                Admin_Heading(title: 'Add Design Category'),
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
                       
                        
                        // Submit button
                        Center(
                          child: MyButton(
                            title: 'Add',
                            height: 50.0,
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                categorycontroller.AddCategory(
                                  categoryName: categoryName.text.trim(),
                                );
                              greenSnackBar('Success!', 'Design Category Added Successfully.');
                                Get.to(AdminDesignCategoryPage());
                              } else {
                               redSnackBar('Error!', 'Please fill out all the fields correctly.');
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
