import 'package:get/get.dart';
import '../../home/controllers/home_controller.dart';
import '../../../data/models/service_model.dart';

class ServicesController extends GetxController {
  final selectedCategory = 'Semua'.obs;
  final searchQuery = ''.obs;
  final currentPage = 1.obs;
  final int itemsPerPage = 5;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is String) {
      selectedCategory.value = Get.arguments as String;
    }
    
    // Reset page when category or search changes
    ever(selectedCategory, (_) => currentPage.value = 1);
    ever(searchQuery, (_) => currentPage.value = 1);
  }
  
  final HomeController homeController = Get.find<HomeController>();

  List<ServiceModel> get allServices => homeController.services;

  List<ServiceModel> get filteredServices {
    List<ServiceModel> list = allServices;
    
    // Filter by category
    if (selectedCategory.value != 'Semua') {
      list = list.where((s) => s.category == selectedCategory.value).toList();
    }
    
    // Filter by search query
    if (searchQuery.value.isNotEmpty) {
      list = list.where((s) => s.name.toLowerCase().contains(searchQuery.value.toLowerCase())).toList();
    }
    
    return list;
  }

  int get totalPages {
    if (filteredServices.isEmpty) return 1;
    return (filteredServices.length / itemsPerPage).ceil();
  }

  List<ServiceModel> get paginatedServices {
    final startIndex = (currentPage.value - 1) * itemsPerPage;
    if (startIndex >= filteredServices.length) return [];
    
    final endIndex = startIndex + itemsPerPage;
    return filteredServices.sublist(
      startIndex,
      endIndex > filteredServices.length ? filteredServices.length : endIndex
    );
  }

  void nextPage() {
    if (currentPage.value < totalPages) {
      currentPage.value++;
    }
  }

  void previousPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
    }
  }

  void setCategory(String category) {
    selectedCategory.value = category;
  }
}
