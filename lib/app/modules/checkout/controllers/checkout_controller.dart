import 'package:get/get.dart';
import 'package:flutter/material.dart';

class CheckoutController extends GetxController {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  final isLoadingLocation = false.obs;
  final isPlacingOrder = false.obs;
  final isOrderConfirmed = false.obs;

  void useCurrentLocation() async {
    isLoadingLocation.value = true;
    
    // Simulate API/GPS delay
    await Future.delayed(const Duration(seconds: 2));
    
    addressController.text = "Jl. Sudirman No. 45, Jakarta Selatan";
    isLoadingLocation.value = false;
  }

  void placeOrder() async {
    if (nameController.text.isEmpty || phoneController.text.isEmpty || addressController.text.isEmpty) {
      Get.snackbar(
        'Error', 
        'Mohon lengkapi semua data diri dan alamat',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
      return;
    }

    isPlacingOrder.value = true;

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    isPlacingOrder.value = false;
    isOrderConfirmed.value = true;
    
    Get.snackbar(
      'Sukses', 
      'Pesanan berhasil dibuat!',
      snackPosition: SnackPosition.TOP,
    );

    Future.delayed(const Duration(seconds: 1), () {
      Get.offAllNamed('/order-tracking');
    });
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.onClose();
  }
}
