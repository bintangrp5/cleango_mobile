import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../../routes/app_pages.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/models/user_model.dart';

class LoginController extends GetxController {
  final authService = Get.find<AuthService>();
  final isLoading = false.obs;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Silakan isi email dan kata sandi', backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    try {
      final response = await authService.dio.post('/auth/login', data: {
        'email': email,
        'password': password
      });

      if (response.statusCode == 200) {
        final token = response.data['access_token'];
        final user = UserModel.fromJson(response.data['user']);
        await authService.saveTokenAndUser(token, user);
      }
    } on DioException catch (e) {
      String errorMessage = 'Terjadi kesalahan saat login';
      if (e.response != null) {
        errorMessage = e.response?.data['detail'] ?? 'Email atau kata sandi salah';
      }
      Get.snackbar('Login Gagal', errorMessage, backgroundColor: Colors.redAccent, colorText: Colors.white, snackPosition: SnackPosition.TOP);
    } catch (e) {
      Get.snackbar('Error', 'Gagal menghubungi server', backgroundColor: Colors.redAccent, colorText: Colors.white, snackPosition: SnackPosition.TOP);
    } finally {
      isLoading.value = false;
    }
  }

  void goToRegister() {
    Get.offNamed(Routes.REGISTER);
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
