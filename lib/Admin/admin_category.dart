import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laptop_harbor/Admin/add_category.dart';

class AdminCategoryPage extends StatelessWidget {
  const AdminCategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ElevatedButton(onPressed: (){Get.to(AddCategoryPage());}, child: Text('Add')),
    );
  }
}