import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laptop_harbor/controller/categoryController.dart';
import 'package:laptop_harbor/model/category_model.dart';
import 'package:laptop_harbor/userPanel/Widgets/button.dart';
import 'package:laptop_harbor/userPanel/constant.dart';

class AddCategoryPage extends StatelessWidget {
  AddCategoryPage({super.key});
  final _formKey = GlobalKey<FormState>();

  @override
  Categorycontroller categorycontroller = Get.put(Categorycontroller());
  final TextEditingController categoryName = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
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
                  child: Text(
                    'Add Category',
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
                              return 'Please enter your name';
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
                          child: MyButton(title: 'Add', onPressed: () {
                            final cName = categoryName.text.trim();
                            categorycontroller.AddCategory(cName);
                          }),
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