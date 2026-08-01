import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../../routes/app_pages.dart';
import '../../../data/services/auth_service.dart';
import '../../../utils/snackbar_util.dart';

class RegisterController extends GetxController {
  final authService = Get.find<AuthService>();
  final isLoading = false.obs;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final passwordStrength = ''.obs;
  final passwordStrengthColor = Colors.transparent.obs;
  final isPasswordValid = false.obs;

  @override
  void onInit() {
    super.onInit();
    passwordController.addListener(() {
      _checkPasswordStrength(passwordController.text);
    });
  }

  void _checkPasswordStrength(String password) {
    if (password.isEmpty) {
      passwordStrength.value = '';
      passwordStrengthColor.value = Colors.transparent;
      isPasswordValid.value = false;
      return;
    }

    if (password.length < 8) {
      passwordStrength.value = 'Lemah (Minimal 8 karakter)';
      passwordStrengthColor.value = Colors.red;
      isPasswordValid.value = false;
      return;
    }

    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    bool hasDigits = password.contains(RegExp(r'[0-9]'));
    bool hasSpecialCharacters = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    if (!hasUppercase || !hasLowercase) {
      passwordStrength.value = 'Lemah (Butuh huruf besar & kecil)';
      passwordStrengthColor.value = Colors.red;
      isPasswordValid.value = false;
      return;
    }

    isPasswordValid.value = true;
    if (hasDigits && hasSpecialCharacters) {
      passwordStrength.value = 'Sangat Kuat';
      passwordStrengthColor.value = const Color(0xFF0058BC); // CleanGO Blue
    } else if (hasDigits || hasSpecialCharacters) {
      passwordStrength.value = 'Kuat';
      passwordStrengthColor.value = Colors.green;
    } else {
      passwordStrength.value = 'Sedang';
      passwordStrengthColor.value = Colors.orange;
    }
  }

  Future<void> register() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();
    
    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      AppSnackbar.show('Error', 'Semua field wajib diisi', isError: true);
      return;
    }

    if (!GetUtils.isEmail(email)) {
      AppSnackbar.show('Error', 'Format email tidak valid (harus mengandung @)', isError: true);
      return;
    }

    if (!isPasswordValid.value) {
      AppSnackbar.show('Error', 'Kata sandi Anda terlalu lemah. Pastikan minimal 8 karakter dan memiliki huruf besar & kecil.', isError: true);
      return;
    }

    if (password != confirmPassword) {
      AppSnackbar.show('Error', 'Kata Sandi dan Konfirmasi Kata Sandi tidak cocok', isError: true);
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
        AppSnackbar.show('Sukses', 'Registrasi berhasil! Silakan login.');
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
      AppSnackbar.show('Registrasi Gagal', errorMessage, isError: true);
    } catch (e) {
      AppSnackbar.show('Error', 'Terjadi kesalahan tidak terduga', isError: true);
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
