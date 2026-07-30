import 'package:get/get.dart';


class ServiceDetailController extends GetxController {
  final pricePerKg = 12500;
  final weight = 2.obs;

  int get totalPrice => weight.value * pricePerKg;

  void incrementWeight() {
    weight.value++;
  }

  void decrementWeight() {
    if (weight.value > 2) {
      weight.value--;
    }
  }

  void addToCart() {
    Get.snackbar(
      'Sukses', 
      'Layanan ditambahkan ke keranjang!',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
    );
    // TODO: Add to cart state logic here
  }
}
