import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laptop_harbor/Admin/admin_design_category.dart';
import 'package:laptop_harbor/controller/design_category_controller.dart';
import 'package:laptop_harbor/model/design_category_model.dart';
import 'package:laptop_harbor/userPanel/Widgets/SnackBar.dart';
import 'package:laptop_harbor/userPanel/Widgets/button.dart';
import 'package:laptop_harbor/userPanel/constant.dart';

class EditDesignCategoryPage extends StatefulWidget {
  final DesignCategoryModel categoryModel;

  const EditDesignCategoryPage({super.key, required this.categoryModel});

  @override
  State<EditDesignCategoryPage> createState() => _EditDesignCategoryPageState();
}

class _EditDesignCategoryPageState extends State<EditDesignCategoryPage> {
  final _formKey = GlobalKey<FormState>();
  final DesignCategoryController categoryController = Get.put(DesignCategoryController());
  final TextEditingController categoryName = TextEditingController();

  @override
  void initState() {
    super.initState();
    categoryName.text = widget.categoryModel.categoryName;
  }

  @override
  Widget build(BuildContext context) {
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
                Admin_Heading(title: 'Edit Design Category'),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: categoryName,
                        decoration: const InputDecoration(
                          hintText: 'Enter category name',
                          hintStyle: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a category name';
                          }
                          if (value.length < 3) {
                            return 'Name must be at least 3 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      Center(
                        child: MyButton(
                          title: 'Update',
                          height: 50.0,
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await categoryController.updateCategory(
                                categoryId: widget.categoryModel.categoryId,
                                categoryName: categoryName.text.trim(),
                              );

                              greenSnackBar('Updated', 'Design category updated successfully.');
                              Get.off(() => AdminDesignCategoryPage());
                            } else {
                              redSnackBar('Error', 'Please enter a valid category name.');
                            }
                          },
                        ),
                      ),
                    ],
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
