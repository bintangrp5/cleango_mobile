import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../../data/services/auth_service.dart';
import '../../../utils/snackbar_util.dart';

class CheckoutController extends GetxController {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  final authService = Get.find<AuthService>();

  final isLoadingLocation = false.obs;
  final isPlacingOrder = false.obs;
  final isOrderConfirmed = false.obs;
  
  final Rx<double?> currentLat = Rx<double?>(null);
  final Rx<double?> currentLng = Rx<double?>(null);

  @override
  void onInit() {
    super.onInit();
    final user = authService.currentUser.value;
    if (user != null) {
      nameController.text = user.fullName;
      phoneController.text = user.phoneNumber;
      addressController.text = authService.userAddress.value.isNotEmpty 
          ? authService.userAddress.value 
          : user.address;
      currentLat.value = authService.userLat.value;
      currentLng.value = authService.userLng.value;

      if (currentLat.value == null && addressController.text.isNotEmpty) {
        _tryGeocodeAddress(addressController.text);
      }
    }
  }

  Future<void> _tryGeocodeAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        currentLat.value = locations.first.latitude;
        currentLng.value = locations.first.longitude;
      }
    } catch (e) {
      debugPrint("Could not geocode address: $e");
    }
  }

  void useCurrentLocation() async {
    isLoadingLocation.value = true;
    
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        AppSnackbar.show('Error', 'GPS tidak aktif. Mohon nyalakan GPS Anda.');
        isLoadingLocation.value = false;
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          AppSnackbar.show('Error', 'Izin lokasi ditolak.');
          isLoadingLocation.value = false;
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        AppSnackbar.show('Error', 'Izin lokasi ditolak secara permanen. Buka pengaturan aplikasi.');
        isLoadingLocation.value = false;
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.best),
      );
      currentLat.value = position.latitude;
      currentLng.value = position.longitude;

      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        
        String street = place.street ?? '';
        // If street is a plus code or empty, try to use thoroughfare (nama jalan)
        if (street.contains('+') || street.isEmpty) {
          street = place.thoroughfare ?? place.name ?? '';
        }

        List<String> addressParts = [
          street,
          place.subLocality ?? '',
          place.locality ?? '',
          place.subAdministrativeArea ?? '',
          place.postalCode ?? ''
        ];
        
        // Filter out empty parts and join with commas
        addressParts.removeWhere((part) => part.trim().isEmpty);
        String address = addressParts.join(', ');
        
        addressController.text = address;
      } else {
        addressController.text = '${position.latitude}, ${position.longitude}';
      }
    } catch (e) {
      AppSnackbar.show('Error', 'Gagal mendapatkan lokasi: $e');
    } finally {
      isLoadingLocation.value = false;
    }
  }

  void placeOrder() async {
    if (nameController.text.isEmpty || phoneController.text.isEmpty || addressController.text.isEmpty) {
      AppSnackbar.show('Error', 'Mohon lengkapi semua data diri dan alamat');
      return;
    }

    final cartController = Get.find<CartController>();
    if (cartController.items.isEmpty) {
      AppSnackbar.show('Error', 'Keranjang Anda kosong');
      return;
    }

    final authService = Get.find<AuthService>();
    final user = authService.currentUser.value;
    if (user == null) {
      AppSnackbar.show('Error', 'Anda harus login untuk membuat pesanan');
      return;
    }

    isPlacingOrder.value = true;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: const Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 24),
              Text('Memproses Pembayaran...', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('Mohon tunggu sebentar', style: TextStyle(fontSize: 14, color: Colors.grey)),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );

    try {
      final payload = {
        "user_id": user.id,
        "customer_name": nameController.text,
        "phone_number": phoneController.text,
        "address": addressController.text,
        "latitude": currentLat.value ?? 0.0,
        "longitude": currentLng.value ?? 0.0,
        "payment_method": "COD (Bayar di Tempat)",
        "items": cartController.items.map((item) => {
          "service_id": item.id,
          "weight_kg": item.weight.value.toDouble()
        }).toList()
      };

      final response = await authService.dio.post('/orders', data: payload);

      if (response.statusCode == 200 || response.statusCode == 201) {
        cartController.items.clear();
        isOrderConfirmed.value = true;
        
        Get.back(); // Close loading dialog
        
        Get.dialog(
          Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: const Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 64),
                  SizedBox(height: 24),
                  Text('Pembayaran Berhasil!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Pesanan Anda telah kami terima', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.grey)),
                ],
              ),
            ),
          ),
          barrierDismissible: false,
        );

        await Future.delayed(const Duration(seconds: 2));
        Get.back(); // Close success dialog
        
        Get.offAllNamed('/dashboard', arguments: {'tab': 1});
      }
    } on DioException catch (e) {
      Get.back(); // Close loading dialog
      AppSnackbar.show('Gagal', 'Terjadi kesalahan: ${e.response?.data?['detail'] ?? e.message}');
    } catch (e) {
      Get.back(); // Close loading dialog
      AppSnackbar.show('Gagal', 'Terjadi kesalahan sistem: $e');
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
