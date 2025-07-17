import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laptop_harbor/Admin/admin_category.dart';
import 'package:laptop_harbor/controller/categoryController.dart';
import 'package:laptop_harbor/userPanel/Widgets/SnackBar.dart';
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
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Admin_Heading(title: 'Add Category'),
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
                        SizedBox(height: 30),
                        // Submit button
                        Center(
                          child: MyButton(
                            title: 'Add',
                            height: 50,
                            onPressed: () async {
                              if (_formKey.currentState!.validate() &&
                                  image != null) {
                                final imageFile = await image!.readAsBytes();
                                categorycontroller.AddCategory(
                                  categoryName: categoryName.text.trim(),
                                  categoryImage: imageFile,
                                );
                              greenSnackBar('Success!', 'Category Added Successfully.');
                                Get.to(AdminCategoryPage());
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
