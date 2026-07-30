import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cleango_mobile/app/data/services/auth_service.dart';

class ProfileController extends GetxController {
  final authService = Get.find<AuthService>();

  String get userName {
    final name = authService.currentUser.value?.fullName;
    return (name != null && name.isNotEmpty) ? name : 'Guest User';
  }

  String get userEmail {
    final email = authService.currentUser.value?.email;
    return (email != null && email.isNotEmpty) ? email : 'guest@example.com';
  }

  void changePassword() {
    Get.defaultDialog(
      title: 'Ubah Kata Sandi',
      content: Column(
        children: [
          const TextField(
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Kata Sandi Lama',
              prefixIcon: Icon(Icons.lock_outline),
            ),
          ),
          const SizedBox(height: 12),
          const TextField(
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Kata Sandi Baru',
              prefixIcon: Icon(Icons.lock),
            ),
          ),
          const SizedBox(height: 12),
          const TextField(
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Konfirmasi Kata Sandi Baru',
              prefixIcon: Icon(Icons.lock),
            ),
          ),
        ],
      ),
      textConfirm: 'Simpan',
      textCancel: 'Batal',
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFF0058BC),
      onConfirm: () {
        Get.back();
        Get.snackbar(
          'Sukses',
          'Kata sandi berhasil diubah (Simulasi)',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      },
    );
  }

  void logout() {
    Get.defaultDialog(
      title: 'Keluar',
      middleText: 'Apakah Anda yakin ingin keluar dari akun?',
      textConfirm: 'Ya, Keluar',
      textCancel: 'Batal',
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFFBA1A1A), // Red color for logout
      onConfirm: () {
        Get.back();
        authService.logout();
      },
    );
  }
}
