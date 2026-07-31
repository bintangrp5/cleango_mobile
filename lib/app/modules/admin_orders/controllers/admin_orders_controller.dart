import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/models/order_model.dart';
import '../../../utils/snackbar_util.dart';

class AdminOrdersController extends GetxController {
  final isLoading = true.obs;
  final orders = <OrderModel>[].obs;
  final filteredOrders = <OrderModel>[].obs;
  
  final searchQuery = ''.obs;
  final selectedFilter = 'Semua'.obs;
  final filters = ['Semua', 'Menunggu Penjemputan', 'Dijemput', 'Diproses', 'Diantar', 'Selesai'];

  late AuthService authService;

  @override
  void onInit() {
    super.onInit();
    authService = Get.find<AuthService>();
    fetchAllOrders();
    
    debounce(searchQuery, (_) => filterOrders(), time: const Duration(milliseconds: 500));
    ever(selectedFilter, (_) => filterOrders());
  }

  Future<void> fetchAllOrders() async {
    isLoading.value = true;
    try {
      final response = await authService.dio.get('/orders/admin/all');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        orders.value = data.map((json) => OrderModel.fromJson(json)).toList();
        filterOrders();
      }
    } on DioException {
      AppSnackbar.show('Error', 'Kesalahan jaringan saat memuat pesanan');
    } finally {
      isLoading.value = false;
    }
  }

  void filterOrders() {
    var result = orders.toList();

    if (selectedFilter.value != 'Semua') {
      result = result.where((o) => o.status == selectedFilter.value).toList();
    }

    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      result = result.where((o) => 
        o.orderNumber.toLowerCase().contains(query) ||
        o.customerName.toLowerCase().contains(query)
      ).toList();
    }

    filteredOrders.value = result;
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      final response = await authService.dio.patch(
        '/orders/admin/$orderId/status',
        data: {"status": newStatus},
      );

      if (response.statusCode == 200) {
        AppSnackbar.show('Sukses', 'Status pesanan #$orderId diperbarui');
        fetchAllOrders();
      }
    } on DioException {
      AppSnackbar.show('Error', 'Gagal memperbarui status');
    }
  }
}
