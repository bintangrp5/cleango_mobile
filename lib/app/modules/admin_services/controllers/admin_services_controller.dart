import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/models/service_model.dart';
import 'package:flutter/material.dart';
import '../../../utils/snackbar_util.dart';

class AdminServicesController extends GetxController {
  final isLoading = true.obs;
  final services = <ServiceModel>[].obs;
  late AuthService authService;

  final nameController = TextEditingController();
  final descController = TextEditingController();
  final priceController = TextEditingController();
  final durationController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    authService = Get.find<AuthService>();
    fetchServices();
  }

  Future<void> fetchServices() async {
    isLoading.value = true;
    try {
      final response = await authService.dio.get('/services?active_only=false');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        services.value = data.map((json) => ServiceModel.fromJson(json)).toList();
      } else {
        AppSnackbar.show('Error', 'Gagal memuat layanan');
      }
    } on DioException {
      AppSnackbar.show('Error', 'Kesalahan jaringan saat memuat layanan');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addService() async {
    if (nameController.text.isEmpty || priceController.text.isEmpty) {
      AppSnackbar.show('Error', 'Nama dan Harga harus diisi');
      return;
    }

    try {
      final response = await authService.dio.post('/services', data: {
        "name": nameController.text,
        "description": descController.text,
        "price_per_kg": double.parse(priceController.text),
        "estimated_duration": int.tryParse(durationController.text) ?? 24,
        "image_url": "https://placehold.co/100",
        "is_active": true
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back(); // close dialog
        nameController.clear();
        descController.clear();
        priceController.clear();
        durationController.clear();
        AppSnackbar.show('Sukses', 'Layanan berhasil ditambahkan');
        fetchServices();
      }
    } on DioException {
      AppSnackbar.show('Error', 'Gagal menambah layanan');
    }
  }

  Future<void> toggleServiceStatus(String id, bool currentStatus) async {
    try {
      final response = await authService.dio.put('/services/$id', data: {
        "is_active": !currentStatus
      });
      if (response.statusCode == 200) {
        fetchServices();
      }
    } on DioException {
      AppSnackbar.show('Error', 'Gagal mengubah status layanan');
    }
  }

  Future<void> editService(String id) async {
    if (nameController.text.isEmpty || priceController.text.isEmpty) {
      AppSnackbar.show('Error', 'Nama dan Harga harus diisi');
      return;
    }

    try {
      final response = await authService.dio.put('/services/$id', data: {
        "name": nameController.text,
        "description": descController.text,
        "price_per_kg": double.parse(priceController.text),
        "estimated_duration": int.tryParse(durationController.text) ?? 24,
      });

      if (response.statusCode == 200) {
        Get.back(); // close dialog
        nameController.clear();
        descController.clear();
        priceController.clear();
        durationController.clear();
        AppSnackbar.show('Sukses', 'Layanan berhasil diubah');
        fetchServices();
      }
    } on DioException {
      AppSnackbar.show('Error', 'Gagal mengubah layanan');
    }
  }

  Future<void> deleteService(String id) async {
    try {
      final response = await authService.dio.delete('/services/$id');
      if (response.statusCode == 200 || response.statusCode == 204) {
        AppSnackbar.show('Sukses', 'Layanan berhasil dihapus');
        fetchServices();
      }
    } on DioException {
      AppSnackbar.show('Error', 'Gagal menghapus layanan. Mungkin layanan sedang digunakan.');
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    descController.dispose();
    priceController.dispose();
    durationController.dispose();
    super.onClose();
  }
}
