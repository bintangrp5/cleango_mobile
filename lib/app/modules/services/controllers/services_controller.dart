import 'package:get/get.dart';
import '../../home/controllers/home_controller.dart';
import '../../../data/models/service_model.dart';

class ServicesController extends GetxController {
  final selectedCategory = 'Semua'.obs;
  
  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is String) {
      selectedCategory.value = Get.arguments as String;
    }
  }
  
  final HomeController homeController = Get.find<HomeController>();

  List<ServiceModel> get allServices => homeController.services;

  List<ServiceModel> get filteredServices {
    if (selectedCategory.value == 'Semua') {
      return allServices;
    }
    return allServices.where((s) => s.category == selectedCategory.value).toList();
  }

  void setCategory(String category) {
    selectedCategory.value = category;
  }
}
