import 'package:flutter/material.dart';
import 'package:get/get.dart';

void redSnackBar(String title, String message){
   Get.snackbar(
                                      title,
                                      message,
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
}

void greenSnackBar(String title, String message){
  Get.snackbar(
                                      title,
                                      message,
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
}