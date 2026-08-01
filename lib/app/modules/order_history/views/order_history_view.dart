import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/order_history_controller.dart';
import '../../../data/models/order_model.dart';

class OrderHistoryView extends GetView<OrderHistoryController> {
  const OrderHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0058BC),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Riwayat Pesanan',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.history, size: 64, color: Color(0xFFC1C6D7)),
                  const SizedBox(height: 16),
                  const Text(
                    'Belum ada riwayat pesanan.',
                    style: TextStyle(fontSize: 16, color: Color(0xFF717786)),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0058BC),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Mulai Pesan Sekarang'),
                  )
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: controller.fetchOrderHistory,
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: controller.orders.length,
              itemBuilder: (context, index) {
                return _buildOrderCard(controller.orders[index]);
              },
            ),
          );
        }),
      ),
    );
  }

  Widget _buildOrderCard(OrderModel order) {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    
    // Status color logic
    Color statusColor = const Color(0xFF9E3D00); // Default orange
    IconData statusIcon = Icons.hourglass_empty;
    
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            'Order #${order.orderNumber}',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0B1C30)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(statusIcon, size: 14, color: statusColor),
                              const SizedBox(width: 4),
                              Text(
                                order.status,
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: statusColor),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 16, color: Color(0xFF414755)),
                        const SizedBox(width: 8),
                        Text(
                          DateFormat('dd MMM yyyy, HH:mm').format(order.createdAt.toLocal()), 
                          style: const TextStyle(fontSize: 14, color: Color(0xFF414755))
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.local_laundry_service, size: 16, color: Color(0xFF414755)),
                        const SizedBox(width: 8),
                        Text(
                          '${order.items.length} Item Layanan', 
                          style: const TextStyle(fontSize: 14, color: Color(0xFF414755))
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(height: 1, color: Color(0xFFE5EEFF)),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Pembayaran', style: TextStyle(fontSize: 14, color: Color(0xFF717786))),
                        Text(
                          currencyFormat.format(order.totalPrice), 
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0058BC))
                        ),
                      ],
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
}
