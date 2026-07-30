import 'package:get/get.dart';

class CartItem {
  final String id;
  final String title;
  final String icon;
  final int pricePerKg;
  final RxInt weight;

  CartItem({
    required this.id,
    required this.title,
    required this.icon,
    required this.pricePerKg,
    required int initialWeight,
  }) : weight = initialWeight.obs;

  int get subtotal => pricePerKg * weight.value;
}

class CartController extends GetxController {
  final items = <CartItem>[
    CartItem(
      id: '1',
      title: 'Cuci & Lipat Reguler',
      icon: 'local_laundry_service',
      pricePerKg: 8000,
      initialWeight: 5,
    ),
    CartItem(
      id: '2',
      title: 'Premium Care (Delicates)',
      icon: 'dry_cleaning',
      pricePerKg: 25000,
      initialWeight: 2,
    ),
  ].obs;

  final int serviceFee = 2000;

  int get subtotal {
    return items.fold(0, (sum, item) => sum + item.subtotal);
  }

  int get totalPayment {
    if (items.isEmpty) return 0;
    return subtotal + serviceFee;
  }

  void incrementWeight(String id) {
    final item = items.firstWhere((element) => element.id == id);
    item.weight.value++;
  }

  void decrementWeight(String id) {
    final item = items.firstWhere((element) => element.id == id);
    if (item.weight.value > 1) {
      item.weight.value--;
    }
  }

  void removeItem(String id) {
    items.removeWhere((element) => element.id == id);
  }
}
