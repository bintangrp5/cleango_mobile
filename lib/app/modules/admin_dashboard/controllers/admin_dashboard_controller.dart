import 'package:get/get.dart';

class AdminDashboardController extends GetxController {
  final activeTasks = 24.obs;
  final completedTasks = 142.obs;

  final selectedFilter = 'All Orders'.obs;
  final filters = ['All Orders', 'Incoming', 'In Progress', 'Delivering'];

  void selectFilter(String filter) {
    selectedFilter.value = filter;
  }

  void acceptOrder(String orderId) {
    Get.snackbar(
      'Order Accepted',
      'Order \$orderId has been accepted.',
      snackPosition: SnackPosition.TOP,
    );
  }

  void rejectOrder(String orderId) {
    Get.snackbar(
      'Order Rejected',
      'Order \$orderId has been rejected.',
      snackPosition: SnackPosition.TOP,
    );
  }
}
