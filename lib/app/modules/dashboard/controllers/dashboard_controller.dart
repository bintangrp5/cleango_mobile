import 'package:get/get.dart';
import 'package:cleango_mobile/app/modules/order_tracking/controllers/order_tracking_controller.dart';

class DashboardController extends GetxController {
  final tabIndex = 0.obs;
  final visitedTabs = <int>{0}.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments['tab'] != null) {
      final int initialTab = Get.arguments['tab'];
      tabIndex.value = initialTab;
      visitedTabs.add(initialTab);
    }
  }

  void changeTabIndex(int index) {
    bool isFirstVisit = !visitedTabs.contains(index);
    tabIndex.value = index;
    visitedTabs.add(index);
    
    if (index == 1 && !isFirstVisit) {
      try {
        Get.find<OrderTrackingController>().fetchLatestOrder();
      } catch (e) {
        // Ignored if controller is not registered
      }
    }
  }
}
