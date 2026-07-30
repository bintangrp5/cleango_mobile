import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../routes/app_pages.dart';

class RegisterController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;
  final isLoading = false.obs;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> register() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Semua field wajib diisi', backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    try {
      await supabase.auth.signUp(
        email: email, 
        password: password,
        data: {'full_name': name},
      );
      Get.snackbar('Sukses', 'Registrasi berhasil! Silakan login.', backgroundColor: Colors.green, colorText: Colors.white);
      Get.offNamed(Routes.LOGIN);
    } on AuthException catch (e) {
      Get.snackbar('Registrasi Gagal', e.message, backgroundColor: Colors.redAccent, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan tidak terduga', backgroundColor: Colors.redAccent, colorText: Colors.white);
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
    super.onClose();
  }
}
