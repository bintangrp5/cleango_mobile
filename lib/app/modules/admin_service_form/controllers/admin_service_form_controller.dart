import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/models/service_model.dart';
import '../../admin_services/controllers/admin_services_controller.dart';
import '../../../utils/snackbar_util.dart';

class AdminServiceFormController extends GetxController {
  final nameController = TextEditingController();
  final descController = TextEditingController();
  final priceController = TextEditingController();
  final durationController = TextEditingController();
  final imageController = TextEditingController();
  final selectedCategory = 'Reguler'.obs;
  final categories = ['Reguler', 'Ekspres', 'Setrika Saja', 'Premium'];

  final isLoading = false.obs;
  late AuthService authService;
  
  ServiceModel? serviceToEdit;
  final isEditMode = false.obs;
  
  final selectedImage = Rxn<XFile>();

  @override
  void onInit() {
    super.onInit();
    authService = Get.find<AuthService>();
    
    if (Get.arguments != null && Get.arguments is ServiceModel) {
      serviceToEdit = Get.arguments as ServiceModel;
      isEditMode.value = true;
      
      nameController.text = serviceToEdit!.name;
      descController.text = serviceToEdit!.description ?? '';
      priceController.text = serviceToEdit!.pricePerKg.toString();
      durationController.text = serviceToEdit!.estimatedDuration.toString();
      imageController.text = serviceToEdit!.imageUrl ?? '';
      
      if (categories.contains(serviceToEdit!.category)) {
        selectedCategory.value = serviceToEdit!.category;
      }
    }
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage.value = image;
      imageController.text = image.path; // Update text for visual feedback
    }
  }

  Future<void> submit() async {
    if (nameController.text.isEmpty || priceController.text.isEmpty) {
      AppSnackbar.show('Error', 'Nama dan Harga harus diisi');
      return;
    }

    isLoading.value = true;

    String finalImageUrl = imageController.text;

    // Upload image if a new one was selected
    if (selectedImage.value != null) {
      final formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(selectedImage.value!.path, filename: selectedImage.value!.name),
      });

      final uploadResponse = await authService.dio.post('/upload', data: formData);
      if (uploadResponse.statusCode == 200) {
        finalImageUrl = uploadResponse.data['image_url'];
      }
    }

    try {
      final data = {
        "name": nameController.text,
        "description": descController.text,
        "price_per_kg": double.parse(priceController.text),
        "estimated_duration": durationController.text.isNotEmpty ? durationController.text : "24",
        "category": selectedCategory.value,
        "image_url": finalImageUrl.isNotEmpty ? finalImageUrl : "https://placehold.co/100",
      };

      dynamic response;

      if (isEditMode.value) {
        response = await authService.dio.put('/services/${serviceToEdit!.id}', data: data);
      } else {
        data["is_active"] = true;
        response = await authService.dio.post('/services', data: data);
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppSnackbar.show('Sukses', isEditMode.value ? 'Layanan berhasil diperbarui' : 'Layanan berhasil ditambahkan');
        
        // Refresh list
        if (Get.isRegistered<AdminServicesController>()) {
          Get.find<AdminServicesController>().fetchServices();
        }
        
        Get.back();
      }
    } on DioException {
      AppSnackbar.show('Error', isEditMode.value ? 'Gagal mengubah layanan' : 'Gagal menambah layanan');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    descController.dispose();
    priceController.dispose();
    durationController.dispose();
    imageController.dispose();
    super.onClose();
  }
}
