import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;
  final isLoading = false.obs;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Silakan isi sembarang teks untuk lanjut (Mode Testing)', backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1)); // Mock loading
    Get.offAllNamed(Routes.HOME);
    isLoading.value = false;
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
