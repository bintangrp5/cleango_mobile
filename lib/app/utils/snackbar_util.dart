import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSnackbar {
  static void show(String title, String message, {bool isError = false}) {
    if (Get.isSnackbarOpen) {
      Get.closeAllSnackbars();
    }
    Future.delayed(const Duration(milliseconds: 10), () {
      Get.snackbar(
        title,
        message,
        snackPosition: SnackPosition.TOP,
        backgroundColor: isError ? const Color(0xFFBA1A1A) : const Color(0xFF4CAF50),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    });
  }
}
