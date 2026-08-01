import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../controllers/admin_dashboard_controller.dart';
import '../../../data/models/order_model.dart';
import '../../../widgets/admin_drawer.dart';
import '../../../routes/app_pages.dart';

class AdminDashboardView extends GetView<AdminDashboardController> {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC), // Soft blue-ish background
      appBar: _buildAppBar(),
      drawer: const AdminDrawer(),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Ringkasan Performa', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0058BC))),
                const SizedBox(height: 16),
                _buildSummaryCards(),
                const SizedBox(height: 32),
                const Text('Analisis Layanan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0058BC))),
                const SizedBox(height: 16),
                _buildChartsRow(),
                const SizedBox(height: 32),
                _buildRecentOrdersHeader(),
                const SizedBox(height: 16),
                _buildRecentOrdersList(),
              ],
            ),
          );
        }),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      shadowColor: Colors.black12,
      iconTheme: const IconThemeData(color: Color(0xFF0058BC)),
      title: const Text(
        'Admin CleanGO',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFF0058BC),
        ),
      ),
      actions: [
        Obx(() => Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: CircleAvatar(
            radius: 16,
            backgroundColor: const Color(0xFF0058BC),
            child: Text(
              controller.authService.userInitials,
              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        )),
      ],
      // Removed actions to let user use drawer instead
    );
  }



  Widget _buildSummaryCards() {
    final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.4,
      children: [
        _buildCardItem('Total Pesanan', '${controller.orders.length}', Icons.shopping_bag_outlined, color: const Color(0xFF0058BC)),
        _buildCardItem('Pendapatan', formatCurrency.format(controller.totalRevenue.value), Icons.account_balance_wallet_outlined, color: Colors.green),
        _buildCardItem('Total Pengguna', '${controller.totalUsers.value}', Icons.people_outline, color: Colors.purple),
      ],
    );
  }

  Widget _buildCardItem(String title, String value, IconData icon, {required Color color}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, size: 18, color: color),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0B1C30)),
          ),
        ],
      ),
    );
  }

  Widget _buildChartsRow() {
    return Column(
      children: [
        _buildBarChartCard(),
        const SizedBox(height: 16),
        _buildPieChartCard(),
      ],
    );
  }

  Widget _buildBarChartCard() {
    return Container(
      width: double.infinity,
      height: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Top 5 Layanan Terlaris', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0058BC))),
          const SizedBox(height: 24),
          Expanded(
            child: controller.topServices.isEmpty
                ? const Center(child: Text('Belum ada data', style: TextStyle(color: Colors.grey)))
                : BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: controller.topServices.values.isEmpty ? 10 : controller.topServices.values.first.toDouble() * 1.2,
                      barTouchData: BarTouchData(enabled: false),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              if (value.toInt() >= controller.topServices.length) return const SizedBox();
                              String title = controller.topServices.keys.elementAt(value.toInt());
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  title.length > 6 ? '${title.substring(0, 6)}..' : title,
                                  style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              );
                            },
                          ),
                        ),
                        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      gridData: const FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                      barGroups: controller.topServices.entries.toList().asMap().entries.map((entry) {
                        return BarChartGroupData(
                          x: entry.key,
                          barRods: [
                            BarChartRodData(
                              toY: entry.value.value.toDouble(),
                              color: const Color(0xFF0058BC),
                              width: 30,
                              borderRadius: const BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                            )
                          ],
                        );
                      }).toList(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPieChartCard() {
    final Map<String, Color> statusColors = {
      'Menunggu Penjemputan': Colors.orange,
      'Dijemput': Colors.blue,
      'Diproses': const Color(0xFF0058BC),
      'Diantar': Colors.purple,
      'Selesai': Colors.teal,
    };

    final sections = controller.statusPortions.entries.where((e) => e.value > 0).map((entry) {
      return PieChartSectionData(
        color: statusColors[entry.key] ?? Colors.grey,
        value: entry.value.toDouble(),
        title: '${entry.value}',
        radius: 30,
        titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
      );
    }).toList();

    return Container(
      width: double.infinity,
      height: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Status Pesanan', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0058BC))),
          const SizedBox(height: 16),
          Expanded(
            child: sections.isEmpty
                ? const Center(child: Text('Belum ada data', style: TextStyle(color: Colors.grey)))
                : Stack(
                  alignment: Alignment.center,
                  children: [
                    PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: 40,
                          sections: sections,
                        ),
                      ),
                      const Text('Total\nPesanan', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: Colors.grey)),
                  ],
                ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: statusColors.entries.map((e) => _buildIndicator(e.value, e.key)).toList(),
          )
        ],
      ),
    );
  }
  
  Widget _buildIndicator(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }

  Widget _buildRecentOrdersHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Pesanan Terkini',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0B1C30),
          ),
        ),
        TextButton(
          onPressed: () => Get.toNamed(Routes.ADMIN_ORDERS),
          child: const Text('Lihat Semua', style: TextStyle(color: Color(0xFF0058BC))),
        ),
      ],
    );
  }

  Widget _buildRecentOrdersList() {
    final recentOrders = controller.orders.take(3).toList();
    if (recentOrders.isEmpty) {
      return const Center(child: Text('Tidak ada pesanan.'));
    }
    
    return Column(
      children: recentOrders.map((o) => _buildOrderCard(o)).toList(),
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
              Text(NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(order.totalPrice), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
            ],
          ),
        ],
      ),
      ),
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
          items: <String>[
            'Menunggu Penjemputan',
            'Dijemput',
            'Diproses',
            'Diantar',
            'Selesai'
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
