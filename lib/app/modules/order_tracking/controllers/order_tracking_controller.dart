import 'package:get/get.dart';

class OrderTrackingController extends GetxController {
  // Add state for the tracking if needed.
  // For the UI, we can use simple observable values for demonstration.

  final orderId = 'CG-88291'.obs;
  final estimatedDelivery = 'Today, 4:30 PM - 5:00 PM'.obs;
  
  // 0: Picked Up, 1: Processing, 2: On Delivery, 3: Completed
  final currentStep = 1.obs;

  final driverName = 'Marcus Thompson'.obs;
  final driverRating = '4.9'.obs;

  void callDriver() {
    Get.snackbar(
      'Memanggil', 
      'Menghubungi \$driverName...',
      snackPosition: SnackPosition.TOP,
    );
  }

  void chatDriver() {
    Get.snackbar(
      'Chat', 
      'Membuka chat dengan \$driverName...',
      snackPosition: SnackPosition.TOP,
    );
  }
}
