import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../../routes/app_pages.dart';
import '../../../data/services/auth_service.dart';

class RegisterController extends GetxController {
  final authService = Get.find<AuthService>();
  final isLoading = false.obs;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  Future<void> register() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();
    
    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar('Error', 'Semua field wajib diisi', backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    if (password.length < 8) {
      Get.snackbar('Error', 'Kata Sandi minimal harus 8 karakter', backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar('Error', 'Kata Sandi dan Konfirmasi Kata Sandi tidak cocok', backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    try {
      final response = await authService.dio.post('/auth/register', data: {
        'email': email,
        'password': password,
        'full_name': name
      });

      if (response.statusCode == 201) {
        Get.snackbar('Sukses', 'Registrasi berhasil! Silakan login.', backgroundColor: Colors.green, colorText: Colors.white);
        Get.offNamed(Routes.LOGIN);
      }
    } on DioException catch (e) {
      String errorMessage = 'Terjadi kesalahan saat registrasi';
      if (e.response != null) {
        if (e.response?.statusCode == 400 && e.response?.data['detail'] == 'Email sudah terdaftar') {
            errorMessage = 'Email sudah terdaftar. Silakan gunakan email lain atau login.';
        } else {
            errorMessage = e.response?.data['detail'] ?? 'Terjadi kesalahan saat registrasi';
        }
      }
      Get.snackbar(
        'Registrasi Gagal', 
        errorMessage, 
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent, 
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    } catch (e) {
      Get.snackbar(
        'Error', 
        'Terjadi kesalahan tidak terduga', 
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent, 
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void goToLogin() {
    Get.offNamed(Routes.LOGIN);
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
