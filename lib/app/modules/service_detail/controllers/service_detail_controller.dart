import 'package:get/get.dart';
import '../../../data/models/service_model.dart';
import '../../home/controllers/home_controller.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../../utils/snackbar_util.dart';

class ServiceDetailController extends GetxController {
  late final ServiceModel service;
  
  final weight = 2.obs;

  @override
  void onInit() {
    super.onInit();
    final String serviceId = Get.arguments;
    final homeController = Get.find<HomeController>();
    service = homeController.services.firstWhere((s) => s.id == serviceId);
  }

  int get totalPrice => weight.value * service.pricePerKg.toInt();

  void incrementWeight() {
    weight.value++;
  }

  void decrementWeight() {
    if (weight.value > 2) {
      weight.value--;
    }
  }

  void addToCart({bool showSnackbar = true}) {
    final cart = Get.find<CartController>();
    cart.addToCart(CartItem(
      id: service.id,
      title: service.name,
      icon: service.imageUrl ?? 'local_laundry_service',
      pricePerKg: service.pricePerKg.toInt(),
      initialWeight: weight.value,
    ));

    if (showSnackbar) {
      AppSnackbar.show('Sukses', 'Layanan ditambahkan ke keranjang!');
    }
  }

  void orderNow() {
    addToCart(showSnackbar: false);
    Get.toNamed('/cart'); // Route directly to CART
  }
}
