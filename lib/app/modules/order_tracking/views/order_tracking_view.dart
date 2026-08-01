import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/order_tracking_controller.dart';

class OrderTrackingView extends GetView<OrderTrackingController> {
  const OrderTrackingView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(OrderTrackingController());
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.order.value == null) {
            return const Center(child: Text('Belum ada pesanan aktif.'));
          }

          return RefreshIndicator(
            onRefresh: controller.fetchLatestOrder,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeroSection(),
                  const SizedBox(height: 24),
                  _buildStepper(),
                  const SizedBox(height: 24),
                  _buildOrderDetailsAccordion(),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Get.offAllNamed('/dashboard', arguments: {'tab': 0}),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF0058BC),
                          side: const BorderSide(color: Color(0xFF0058BC)),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        child: const Text('Kembali ke Beranda', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFF8F9FF).withValues(alpha: 0.9),
      elevation: 0,
      title: const Text(
        'Pesanan',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF0B1C30),
        ),
      ),
      centerTitle: true,
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
    );
  }

  Widget _buildHeroSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF0058BC),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Obx(() => Text(
                controller.heroTitle,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: Color(0xFF0058BC),
                ),
              )),
            ],
          ),
          const SizedBox(height: 12),
          Obx(() => Text(
            controller.heroSubtitle,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0B1C30),
            ),
          )),
          const SizedBox(height: 8),
          Text(
            'Status saat ini: ${controller.order.value!.status}',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF414755),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepper() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFEFF4FF),
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Stack(
            children: [
              // Vertical Track Line
              Positioned(
                left: 15,
                top: 16,
                bottom: 16,
                width: 2,
                child: Container(color: const Color(0xFFC1C6D7)),
              ),
              // Active Progress Line
              Obx(() => Positioned(
                left: 15,
                top: 16,
                bottom: 16 + (4 - controller.currentStep.value) * 56.0,
                width: 2,
                child: Container(color: const Color(0xFF0058BC)),
              )),
              Obx(() => Column(
                children: [
                  _buildStep(
                    icon: Icons.check,
                    title: 'Menunggu Penjemputan',
                    subtitle: 'Pesanan telah dibuat',
                    isActive: controller.currentStep.value == 0,
                    isCompleted: controller.currentStep.value > 0,
                  ),
                  const SizedBox(height: 24),
                  _buildStep(
                    icon: Icons.hail,
                    title: 'Dijemput',
                    subtitle: 'Kurir sedang menjemput',
                    isActive: controller.currentStep.value == 1,
                    isCompleted: controller.currentStep.value > 1,
                  ),
                  const SizedBox(height: 24),
                  _buildStep(
                    icon: Icons.local_laundry_service,
                    title: 'Diproses',
                    subtitle: 'Sedang dicuci & dilipat',
                    isActive: controller.currentStep.value == 2,
                    isCompleted: controller.currentStep.value > 2,
                  ),
                  const SizedBox(height: 24),
                  _buildStep(
                    icon: Icons.local_shipping,
                    title: 'Diantar',
                    subtitle: 'Kurir menuju ke lokasimu',
                    isActive: controller.currentStep.value == 3,
                    isCompleted: controller.currentStep.value > 3,
                  ),
                  const SizedBox(height: 24),
                  _buildStep(
                    icon: Icons.task_alt,
                    title: 'Selesai',
                    subtitle: 'Pesanan telah diterima',
                    isActive: false,
                    isCompleted: controller.currentStep.value >= 4,
                  ),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isActive,
    required bool isCompleted,
  }) {
    Color iconColor;
    Color bgColor;
    double opacity = 1.0;

    if (isCompleted) {
      iconColor = Colors.white;
      bgColor = const Color(0xFF0058BC);
    } else if (isActive) {
      iconColor = const Color(0xFF0058BC);
      bgColor = const Color(0xFFD3E4FE);
    } else {
      iconColor = const Color(0xFF414755);
      bgColor = const Color(0xFFC1C6D7);
      opacity = 0.4;
    }

    return Opacity(
      opacity: opacity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
              border: isActive ? Border.all(color: Colors.white, width: 4) : null,
            ),
            child: Icon(icon, size: 16, color: iconColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: isActive ? 16 : 14,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                    color: isActive ? const Color(0xFF0B1C30) : (isCompleted ? const Color(0xFF0058BC) : const Color(0xFF0B1C30)),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF414755),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Dummy UI details and map removed

  Widget _buildOrderDetailsAccordion() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFEFF4FF),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => controller.toggleAccordion(),
              child: Container(
                color: Colors.transparent,
                child: Row(
                  children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFD3E5F1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.receipt_long, color: Color(0xFF384953)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pesanan ${controller.order.value!.orderNumber}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0B1C30),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${controller.order.value!.items.length} Layanan • ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(controller.order.value!.totalPrice)}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF414755),
                    ),
                  ),
                ],
              ),
            ),
            Obx(() => Icon(
              controller.isAccordionExpanded.value ? Icons.expand_more : Icons.chevron_right,
              color: const Color(0xFF717786),
            )),
          ],
        ),
      ),
    ),
            Obx(() {
              if (controller.isAccordionExpanded.value) {
                return Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Column(
                    children: controller.order.value!.items.map((item) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${item.serviceName} (${item.weightKg} kg)',
                              style: const TextStyle(fontSize: 14, color: Color(0xFF414755)),
                            ),
                            Text(
                              NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(item.subtotal),
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0B1C30)),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }
}
