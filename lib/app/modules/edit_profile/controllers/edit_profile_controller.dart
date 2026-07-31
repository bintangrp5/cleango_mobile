import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/models/user_model.dart';
import '../../../utils/snackbar_util.dart';

class EditProfileController extends GetxController {
  final isLoading = false.obs;
  final isLoadingLocation = false.obs;
  
  final Rx<double?> currentLat = Rx<double?>(null);
  final Rx<double?> currentLng = Rx<double?>(null);

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
        
        addressParts.removeWhere((part) => part.isEmpty);
        String fullAddress = addressParts.join(', ');
        
        addressController.text = fullAddress;
        AppSnackbar.show('Sukses', 'Lokasi berhasil diperbarui');
      }
    } catch (e) {
      AppSnackbar.show('Error', 'Gagal mendapatkan lokasi: $e');
    } finally {
      isLoadingLocation.value = false;
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
      AppSnackbar.show('Error', 'Nama lengkap tidak boleh kosong');
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
        
        await authService.saveAddress(
          addressController.text.trim(),
          lat: currentLat.value,
          lng: currentLng.value,
        );
        
        Get.back();
        AppSnackbar.show('Sukses', 'Profil berhasil diperbarui');
      } else {
        AppSnackbar.show('Error', 'Gagal menyimpan profil');
      }
    } catch (e) {
      AppSnackbar.show('Error', 'Kesalahan jaringan atau server');
    } finally {
      isLoading.value = false;
    }
  }
}
