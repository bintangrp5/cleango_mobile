import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/admin_dashboard_controller.dart';
import '../../../data/models/order_model.dart';

class AdminDashboardView extends GetView<AdminDashboardController> {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatsSection(),
              _buildFilterChips(),
              const SizedBox(height: 16),
              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(),
                  ));
                }
                
                final orders = controller.filteredOrders;
                if (orders.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Text('Tidak ada pesanan.'),
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: orders.map((o) => _buildOrderCard(o)).toList(),
                  ),
                );
              }),
              const SizedBox(height: 100), // Spacing for FAB
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.fetchAllOrders(),
        backgroundColor: const Color(0xFF0058BC),
        elevation: 4,
        child: const Icon(Icons.refresh, color: Colors.white, size: 28),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFFF8F9FF).withValues(alpha: 0.9),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF0058BC)),
        onPressed: () => Get.back(),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/logo.png',
            height: 24,
            width: 24,
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.local_laundry_service,
              color: Color(0xFF0058BC),
              size: 24,
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'Admin',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0B1C30),
            ),
          ),
        ],
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: CircleAvatar(
            radius: 16,
            backgroundImage: const NetworkImage('https://ui-avatars.com/api/?name=Admin&background=0058BC&color=fff'),
            backgroundColor: Colors.grey.shade200,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0070EB).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ACTIVE TASKS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: Color(0xFF0058BC),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Obx(() => Text(
                        '\${controller.activeTasks.value}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0B1C30),
                        ),
                      )),
                      const SizedBox(width: 8),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 4),
                        child: Text(
                          '+3 today',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0058BC),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFDCE9FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'COMPLETED',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: Color(0xFF414755),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Obx(() => Text(
                        '\${controller.completedTasks.value}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0B1C30),
                        ),
                      )),
                      const SizedBox(width: 8),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 4),
                        child: Text(
                          'this week',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF414755),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: controller.filters.map((filter) {
          return Obx(() {
            final isSelected = controller.selectedFilter.value == filter;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: InkWell(
                onTap: () => controller.selectFilter(filter),
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF0058BC) : const Color(0xFFE5EEFF),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Text(
                    filter,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : const Color(0xFF414755),
                    ),
                  ),
                ),
              ),
            );
          });
        }).toList(),
      ),
    );
  }

  Widget _buildOrderCard(OrderModel order) {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    
    // Status color logic
    Color statusColor = const Color(0xFF9E3D00); // Default orange
    IconData statusIcon = Icons.fiber_new;
    
    if (order.status == 'Diproses' || order.status == 'Dijemput') {
      statusColor = const Color(0xFF0058BC);
      statusIcon = Icons.refresh;
    } else if (order.status == 'Diantar') {
      statusColor = const Color(0xFF414755);
      statusIcon = Icons.local_shipping;
    } else if (order.status == 'Selesai') {
      statusColor = Colors.green;
      statusIcon = Icons.check_circle;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(width: 6, color: statusColor),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(statusIcon, color: statusColor, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              '${order.status} #${order.orderNumber}',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: statusColor),
                            ),
                          ],
                        ),
                        // Dropdown for updating status
                        _buildStatusDropdown(order),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order.customerName,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0B1C30)),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.local_laundry_service, size: 16, color: Color(0xFF414755)),
                        const SizedBox(width: 4),
                        Text('${order.items.length} Layanan', style: const TextStyle(fontSize: 14, color: Color(0xFF414755))),
                        const SizedBox(width: 16),
                        const Icon(Icons.calendar_today, size: 16, color: Color(0xFF414755)),
                        const SizedBox(width: 4),
                        Text(DateFormat('dd MMM, HH:mm').format(order.createdAt.toLocal()), style: const TextStyle(fontSize: 14, color: Color(0xFF414755))),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.payments, size: 16, color: Color(0xFF414755)),
                        const SizedBox(width: 4),
                        Text(currencyFormat.format(order.totalPrice), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0058BC))),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF4FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on, size: 16, color: Color(0xFF414755)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              order.address,
                              style: const TextStyle(fontSize: 14, color: Color(0xFF414755)),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusDropdown(OrderModel order) {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFE5EEFF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: order.status,
          icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF0058BC)),
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0058BC)),
          onChanged: (String? newValue) {
            if (newValue != null && newValue != order.status) {
              controller.updateOrderStatus(order.id, newValue);
            }
          },
          items: <String>[
            'Menunggu Penjemputan',
            'Dijemput',
            'Diproses',
            'Diantar',
            'Selesai',
            'Dibatalkan'
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }
}
