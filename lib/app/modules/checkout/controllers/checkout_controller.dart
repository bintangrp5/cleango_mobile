import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../../data/services/auth_service.dart';

class CheckoutController extends GetxController {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  final authService = Get.find<AuthService>();

  final isLoadingLocation = false.obs;
  final isPlacingOrder = false.obs;
  final isOrderConfirmed = false.obs;

  @override
  void onInit() {
    super.onInit();
    final user = authService.currentUser.value;
    if (user != null) {
      nameController.text = user.fullName;
      phoneController.text = user.phoneNumber;
      addressController.text = user.address;
    }
  }

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

    final cartController = Get.find<CartController>();
    if (cartController.items.isEmpty) {
      Get.snackbar('Error', 'Keranjang Anda kosong');
      return;
    }

    final authService = Get.find<AuthService>();
    final user = authService.currentUser.value;
    if (user == null) {
      Get.snackbar('Error', 'Anda harus login untuk membuat pesanan');
      return;
    }

    isPlacingOrder.value = true;

    try {
      final baseUrl = dotenv.env['BACKEND_API_URL'] ?? 'http://10.0.2.2:8000/api/v1';
      
      final payload = {
        "user_id": user.id,
        "customer_name": nameController.text,
        "phone_number": phoneController.text,
        "address": addressController.text,
        "latitude": -6.2088,
        "longitude": 106.8456,
        "payment_method": "COD (Bayar di Tempat)",
        "items": cartController.items.map((item) => {
          "service_id": item.id,
          "weight_kg": item.weight.value.toDouble()
        }).toList()
      };

      final response = await GetConnect().post('$baseUrl/orders', payload);

      if (response.statusCode == 200 || response.statusCode == 201) {
        cartController.items.clear();
        isOrderConfirmed.value = true;
        
        Get.snackbar(
          'Sukses', 
          'Pesanan berhasil dibuat!',
          snackPosition: SnackPosition.TOP,
        );

        Future.delayed(const Duration(seconds: 1), () {
          Get.offAllNamed('/order-tracking');
        });
      } else {
        Get.snackbar('Gagal', 'Terjadi kesalahan: ${response.statusText}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Kesalahan jaringan saat checkout');
    } finally {
      isPlacingOrder.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.onClose();
  }
}
