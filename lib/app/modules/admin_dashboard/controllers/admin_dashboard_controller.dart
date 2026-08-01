import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/models/order_model.dart';
import 'package:flutter/material.dart';
import '../../../utils/snackbar_util.dart';

class AdminDashboardController extends GetxController {
  final isLoading = true.obs;
  final orders = <OrderModel>[].obs;
  
  final activeTasks = 0.obs;
  final completedTasks = 0.obs;
  final totalRevenue = 0.0.obs;
  final totalUsers = 0.obs;
  
  final topServices = <String, int>{}.obs;
  final statusPortions = <String, int>{}.obs;

  final selectedFilter = 'Semua'.obs;
  final filters = ['Semua', 'Menunggu Penjemputan', 'Diproses', 'Diantar', 'Selesai'];

  late AuthService authService;

  @override
  void onInit() {
    super.onInit();
    authService = Get.find<AuthService>();
    fetchAllOrders();
    fetchUsersStats();
  }

  Future<void> fetchUsersStats() async {
    try {
      final response = await authService.dio.get('/profiles');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        totalUsers.value = data.length;
      }
    } catch (e) {
      // Ignore if fail
    }
  }

  Future<void> fetchAllOrders() async {
    isLoading.value = true;
    final user = authService.currentUser.value;

    if (user == null || user.role != 'admin') {
      AppSnackbar.show('Error', 'Akses ditolak: Hanya untuk admin.');
      isLoading.value = false;
      return;
    }

    try {
      final response = await authService.dio.get('/orders/admin/all');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        orders.value = data.map((json) => OrderModel.fromJson(json)).toList();
        
        _calculateStats();
      } else {
        AppSnackbar.show('Error', 'Gagal memuat pesanan');
      }
    } on DioException catch (e) {
      AppSnackbar.show('Error', 'Kesalahan jaringan: ${e.message}');
    } finally {
      isLoading.value = false;
    }
  }
  
  void _calculateStats() {
    activeTasks.value = orders.where((o) => o.status != 'Selesai').length;
    completedTasks.value = orders.where((o) => o.status == 'Selesai').length;
    
    double revenue = 0;
    Map<String, int> serviceCount = {};
    Map<String, int> statusCount = {
      'Menunggu Penjemputan': 0,
      'Dijemput': 0,
      'Diproses': 0,
      'Diantar': 0,
      'Selesai': 0,
    };
    
    for (var order in orders) {
      revenue += order.totalPrice;
      
      statusCount[order.status] = (statusCount[order.status] ?? 0) + 1;
      
      for (var item in order.items) {
        serviceCount[item.serviceName] = (serviceCount[item.serviceName] ?? 0) + 1;
      }
    }
    
    totalRevenue.value = revenue;
    
    // Sort top 5 services
    var sortedEntries = serviceCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    topServices.value = Map.fromEntries(sortedEntries.take(5));
    
    statusPortions.value = statusCount;
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
    final user = authService.currentUser.value;
    if (user == null || user.role != 'admin') return;

    final index = orders.indexWhere((o) => o.id == orderId);
    if (index == -1) return;
    
    final orderNumber = orders[index].orderNumber;
    final oldStatus = orders[index].status;
    
    // Optimistic update
    orders[index] = OrderModel(
      id: orders[index].id,
      orderNumber: orders[index].orderNumber,
      customerName: orders[index].customerName,
      phoneNumber: orders[index].phoneNumber,
      address: orders[index].address,
      totalPrice: orders[index].totalPrice,
      status: newStatus,
      createdAt: orders[index].createdAt,
      latitude: orders[index].latitude,
      longitude: orders[index].longitude,
      items: orders[index].items,
    );
    orders.refresh();
    _calculateStats();

    try {
      final response = await authService.dio.patch(
        '/orders/admin/$orderId/status',
        data: {"status": newStatus},
      );

      if (response.statusCode == 200) {
        AppSnackbar.show('Sukses', 'Status pesanan #$orderNumber diperbarui menjadi $newStatus');
      } else {
        // Revert
        orders[index] = OrderModel(
          id: orders[index].id,
          orderNumber: orders[index].orderNumber,
          customerName: orders[index].customerName,
          phoneNumber: orders[index].phoneNumber,
          address: orders[index].address,
          totalPrice: orders[index].totalPrice,
          status: oldStatus,
          createdAt: orders[index].createdAt,
          latitude: orders[index].latitude,
          longitude: orders[index].longitude,
          items: orders[index].items,
        );
        orders.refresh();
        _calculateStats();
        AppSnackbar.show('Error', 'Gagal memperbarui status');
      }
    } on DioException {
      // Revert
      orders[index] = OrderModel(
        id: orders[index].id,
        orderNumber: orders[index].orderNumber,
        customerName: orders[index].customerName,
        phoneNumber: orders[index].phoneNumber,
        address: orders[index].address,
        totalPrice: orders[index].totalPrice,
        status: oldStatus,
        createdAt: orders[index].createdAt,
        latitude: orders[index].latitude,
        longitude: orders[index].longitude,
        items: orders[index].items,
      );
      orders.refresh();
      _calculateStats();
      AppSnackbar.show('Error', 'Kesalahan jaringan saat update status');
    }
  }
}
