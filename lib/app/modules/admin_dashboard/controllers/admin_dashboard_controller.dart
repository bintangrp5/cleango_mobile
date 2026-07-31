import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/models/order_model.dart';
import 'package:flutter/material.dart';

class AdminDashboardController extends GetxController {
  final isLoading = true.obs;
  final orders = <OrderModel>[].obs;
  
  final activeTasks = 0.obs;
  final completedTasks = 0.obs;

  final selectedFilter = 'Semua'.obs;
  final filters = ['Semua', 'Menunggu Penjemputan', 'Diproses', 'Diantar', 'Selesai'];

  @override
  void onInit() {
    super.onInit();
    fetchAllOrders();
  }

  Future<void> fetchAllOrders() async {
    isLoading.value = true;
    final authService = Get.find<AuthService>();
    final user = authService.currentUser.value;

    if (user == null || user.role != 'admin') {
      Get.snackbar('Error', 'Akses ditolak: Hanya untuk admin.');
      isLoading.value = false;
      return;
    }

    try {
      final baseUrl = dotenv.env['BACKEND_API_URL'] ?? 'http://10.0.2.2:8000/api/v1';
      final response = await GetConnect().get(
        '$baseUrl/orders/admin/all',
        headers: {'X-User-ID': user.id},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.body;
        orders.value = data.map((json) => OrderModel.fromJson(json)).toList();
        
        // Update stats
        activeTasks.value = orders.where((o) => o.status != 'Selesai' && o.status != 'Dibatalkan').length;
        completedTasks.value = orders.where((o) => o.status == 'Selesai').length;
      } else {
        Get.snackbar('Error', 'Gagal memuat pesanan: ${response.statusText}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Kesalahan jaringan');
    } finally {
      isLoading.value = false;
    }
  }

  List<OrderModel> get filteredOrders {
    if (selectedFilter.value == 'Semua') {
      return orders;
    } else if (selectedFilter.value == 'Diproses') {
      return orders.where((o) => o.status == 'Dijemput' || o.status == 'Diproses').toList();
    }
    return orders.where((o) => o.status == selectedFilter.value).toList();
  }

  void selectFilter(String filter) {
    selectedFilter.value = filter;
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    final authService = Get.find<AuthService>();
    final user = authService.currentUser.value;

    if (user == null || user.role != 'admin') return;

    try {
      final baseUrl = dotenv.env['BACKEND_API_URL'] ?? 'http://10.0.2.2:8000/api/v1';
      final response = await GetConnect().patch(
        '$baseUrl/orders/admin/$orderId/status',
        {"status": newStatus},
        headers: {'X-User-ID': user.id},
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          'Sukses',
          'Status pesanan #$orderId diperbarui menjadi $newStatus',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.withValues(alpha: 0.1),
          colorText: Colors.green,
        );
        fetchAllOrders(); // Reload orders
      } else {
        Get.snackbar('Error', 'Gagal memperbarui status: ${response.statusText}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Kesalahan jaringan saat update status');
    }
  }
}
