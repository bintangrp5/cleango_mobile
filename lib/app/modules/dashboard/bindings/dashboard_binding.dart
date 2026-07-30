import 'package:get/get.dart';
import 'package:cleango_mobile/app/modules/home/controllers/home_controller.dart';
import 'package:cleango_mobile/app/modules/order_tracking/controllers/order_tracking_controller.dart';
import 'package:cleango_mobile/app/modules/cart/controllers/cart_controller.dart';
import 'package:cleango_mobile/app/modules/profile/controllers/profile_controller.dart';
import '../controllers/dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(
      () => DashboardController(),
    );
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<OrderTrackingController>(() => OrderTrackingController());
    Get.lazyPut<CartController>(() => CartController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
