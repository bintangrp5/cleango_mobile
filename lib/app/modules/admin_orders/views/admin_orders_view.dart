import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/admin_orders_controller.dart';
import '../../../data/models/order_model.dart';
import 'package:intl/intl.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlong;
import '../../../widgets/admin_drawer.dart';

class AdminOrdersView extends GetView<AdminOrdersController> {
  const AdminOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AdminOrdersController());
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      drawer: const AdminDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.black12,
        iconTheme: const IconThemeData(color: Color(0xFF0058BC)),
        title: const Text(
          'Semua Pesanan',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0058BC),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  onChanged: (val) => controller.searchQuery.value = val,
                  decoration: InputDecoration(
                    hintText: 'Cari nama atau no pesanan...',
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    fillColor: const Color(0xFFF4F7FC),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 32,
                  child: Obx(() {
                    // Access observable here so GetX tracks it immediately
                    final currentSelected = controller.selectedFilter.value;
                    
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: controller.filters.map((filter) {
                          final isSelected = currentSelected == filter;
                          return GestureDetector(
                            onTap: () => controller.selectedFilter.value = filter,
                            child: Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isSelected ? const Color(0xFF0058BC) : Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected ? const Color(0xFF0058BC) : Colors.grey.shade300,
                                ),
                              ),
                              child: Text(
                                filter,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.grey.shade600,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.filteredOrders.isEmpty) {
                return const Center(child: Text('Tidak ada pesanan.'));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.filteredOrders.length,
                itemBuilder: (context, index) {
                  return _buildOrderCard(controller.filteredOrders[index]);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(OrderModel order) {
    return GestureDetector(
      onTap: () => _showOrderDetailsDialog(Get.context!, order),
      child: Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('#${order.orderNumber}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0058BC))),
              _buildStatusDropdown(order),
            ],
          ),
          const SizedBox(height: 8),
          Text(order.customerName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${order.items.length} Layanan', style: const TextStyle(color: Colors.grey, fontSize: 12)),
              Text(
                NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(order.totalPrice),
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Expanded(
                child: Text(order.address, style: const TextStyle(fontSize: 12, color: Colors.grey), maxLines: 2, overflow: TextOverflow.ellipsis),
              ),
              if (order.latitude != null && order.longitude != null)
                IconButton(
                  icon: const Icon(Icons.map, color: Color(0xFF0058BC)),
                  onPressed: () => _showMapDialog(Get.context!, order),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
        ],
      ),
      ),
    );
  }

  void _showMapDialog(BuildContext context, OrderModel order) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Lokasi: ${order.customerName}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 16),
                SizedBox(
                  height: 300,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: FlutterMap(
                      options: MapOptions(
                        initialCenter: latlong.LatLng(order.latitude!, order.longitude!),
                        initialZoom: 16.0,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png',
                          subdomains: const ['a', 'b', 'c', 'd'],
                          userAgentPackageName: 'com.example.cleango_mobile',
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: latlong.LatLng(order.latitude!, order.longitude!),
                              width: 40,
                              height: 40,
                              child: const Icon(Icons.location_on, color: Colors.red, size: 40),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(order.address, style: const TextStyle(fontSize: 12, color: Colors.grey), textAlign: TextAlign.center),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0058BC),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 44)
                  ),
                  child: const Text('Tutup'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusDropdown(OrderModel order) {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F7FC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5EEFF)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: order.status,
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF0058BC), size: 16),
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0058BC)),
          onChanged: (String? newValue) {
            if (newValue != null && newValue != order.status) {
              controller.updateOrderStatus(order.id, newValue);
            }
          },
          items: controller.filters
              .where((f) => f != 'Semua')
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showOrderDetailsDialog(BuildContext context, OrderModel order) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Rincian Pesanan #${order.orderNumber}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                Text('Pelanggan: ${order.customerName}', style: const TextStyle(fontSize: 14)),
                Text('No HP: ${order.phoneNumber}', style: const TextStyle(fontSize: 14)),
                const Divider(height: 24),
                const Text('Layanan:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 8),
                ...order.items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${item.serviceName} (${item.weightKg} kg)', 
                              style: const TextStyle(fontSize: 14),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(item.pricePerKg)} / kg', 
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(item.subtotal), 
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)
                      ),
                    ],
                  ),
                )),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Pembayaran', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(order.totalPrice), 
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0058BC),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 44)
                  ),
                  child: const Text('Tutup'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
