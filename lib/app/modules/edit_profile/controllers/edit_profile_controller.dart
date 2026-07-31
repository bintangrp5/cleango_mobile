import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/models/user_model.dart';

class EditProfileController extends GetxController {
  final isLoading = false.obs;

  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    final authService = Get.find<AuthService>();
    final user = authService.currentUser.value;
    if (user != null) {
      fullNameController.text = user.fullName;
      phoneController.text = user.phoneNumber;
      addressController.text = user.address;
    }
  }

  @override
  void onClose() {
    fullNameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.onClose();
  }

  Future<void> saveProfile() async {
    final authService = Get.find<AuthService>();
    final user = authService.currentUser.value;

    if (user == null) return;

    if (fullNameController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Nama lengkap tidak boleh kosong');
      return;
    }

    isLoading.value = true;
    try {
      final response = await authService.dio.put(
        '/profiles/${user.id}',
        data: {
          "full_name": fullNameController.text.trim(),
          "phone_number": phoneController.text.trim(),
          "address": addressController.text.trim(),
        },
      );

      if (response.statusCode == 200) {
        // Update local auth service with new data
        authService.currentUser.value = UserModel.fromJson(response.data);
        
        Get.back();
        Get.snackbar(
          'Sukses', 
          'Profil berhasil diperbarui',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar('Error', 'Gagal menyimpan profil');
      }
    } catch (e) {
      Get.snackbar('Error', 'Kesalahan jaringan atau server');
    } finally {
      isLoading.value = false;
    }
  }
}
