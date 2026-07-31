import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/services/auth_service.dart';

class CartItem {
  final String id;
  final String title;
  final String icon; // For fallback or using imageUrl
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

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'icon': icon,
        'pricePerKg': pricePerKg,
        'weight': weight.value,
      };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        id: json['id'],
        title: json['title'],
        icon: json['icon'],
        pricePerKg: json['pricePerKg'],
        initialWeight: json['weight'],
      );
}

class CartController extends GetxController {
  final authService = Get.find<AuthService>();
  final items = <CartItem>[].obs;
  final int serviceFee = 2000;
  final box = GetStorage();
  final isCheckingOut = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadCart();
    ever(items, (_) => _saveCart());
  }

  void _loadCart() {
    List? storedItems = box.read<List>('cart_items');
    if (storedItems != null) {
      items.value = storedItems.map((e) => CartItem.fromJson(e)).toList();
    }
  }

  void _saveCart() {
    box.write('cart_items', items.map((e) => e.toJson()).toList());
  }

  void addToCart(CartItem newItem) {
    int index = items.indexWhere((item) => item.id == newItem.id);
    if (index != -1) {
      items[index].weight.value += newItem.weight.value;
    } else {
      items.add(newItem);
    }
    // Update trigger for ever()
    items.refresh();
  }

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
    items.refresh(); // Trigger save
  }

  void decrementWeight(String id) {
    final item = items.firstWhere((element) => element.id == id);
    if (item.weight.value > 1) {
      item.weight.value--;
      items.refresh();
    }
  }

  void removeItem(String id) {
    items.removeWhere((element) => element.id == id);
  }

}
