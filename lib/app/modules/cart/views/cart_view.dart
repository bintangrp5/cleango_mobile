import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/cart_controller.dart';
import '../../../routes/app_pages.dart';

class CartView extends GetView<CartController> {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 24),
                    _buildCartList(currencyFormat),
                    const SizedBox(height: 24),

                    _buildOrderSummary(currencyFormat),
                    const SizedBox(height: 24),
                    _buildNoteCard(),
                    const SizedBox(height: 100), // Spacing for bottom CTA
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: _buildBottomCTA(currencyFormat),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final canPop = Navigator.of(context).canPop();
    return AppBar(
      backgroundColor: const Color(0xFFF8F9FF).withValues(alpha: 0.9),
      elevation: 0,
      title: const Text(
        'Keranjang',
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

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0070EB).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -16,
            top: -16,
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: const Color(0xFF0058BC).withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      'Hampir siap untuk pakaian bersih dan wangi!',
                      style: TextStyle(
                        fontSize: 14,
                        color: const Color(0xFF0B1C30).withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
                child: const Icon(
                  Icons.shopping_cart_checkout,
                  size: 40,
                  color: Color(0xFF0058BC),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCartList(NumberFormat currencyFormat) {
    return Obx(() {
      if (controller.items.isEmpty) {
        return _buildEmptyState();
      }
      return Column(
        children: controller.items.map((item) => _buildCartItem(item, currencyFormat)).toList(),
      );
    });
  }

  Widget _buildCartItem(CartItem item, NumberFormat currencyFormat) {
    // Map string icon to IconData
    IconData iconData = Icons.local_laundry_service;
    if (item.icon == 'dry_cleaning') iconData = Icons.dry_cleaning;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, // surface-container-lowest
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5EEFF), // surface-container
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(iconData, color: const Color(0xFF0058BC), size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0B1C30),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () => controller.removeItem(item.id),
                          child: const Icon(Icons.delete_outline, color: Color(0xFFBA1A1A), size: 20),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${currencyFormat.format(item.pricePerKg)} / kg',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF414755),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Obx(() => Text(
                      'Subtotal: ${currencyFormat.format(item.subtotal)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0058BC),
                      ),
                    )),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFC1C6D7)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Estimasi Berat',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF414755),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF4FF),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => controller.decrementWeight(item.id),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1)),
                          ],
                        ),
                        child: const Icon(Icons.remove, color: Color(0xFF0058BC), size: 18),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Obx(() => Text(
                        '${item.weight.value}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0B1C30),
                        ),
                      )),
                    ),
                    InkWell(
                      onTap: () => controller.incrementWeight(item.id),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: Color(0xFF0058BC),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.add, color: Colors.white, size: 18),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'kg',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF414755),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Column(
          children: [
            const Icon(Icons.shopping_cart_outlined, size: 64, color: Color(0xFF717786)),
            const SizedBox(height: 16),
            const Text(
              'Keranjang Kosong',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0B1C30),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Yuk, tambah layanan cucianmu!',
              style: TextStyle(color: Color(0xFF50616B)),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Get.toNamed(Routes.SERVICES),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0058BC),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              ),
              child: const Text('Mulai Pesanan'),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildOrderSummary(NumberFormat currencyFormat) {
    return Obx(() {
      if (controller.items.isEmpty) return const SizedBox.shrink();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ringkasan Pesanan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0B1C30),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Subtotal',
                style: TextStyle(fontSize: 14, color: Color(0xFF414755)),
              ),
              Text(
                currencyFormat.format(controller.subtotal),
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF0B1C30)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Biaya Layanan',
                style: TextStyle(fontSize: 14, color: Color(0xFF414755)),
              ),
              Text(
                currencyFormat.format(controller.serviceFee),
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF0B1C30)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFC1C6D7)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Pembayaran',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0B1C30),
                ),
              ),
              Text(
                currencyFormat.format(controller.totalPayment),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0058BC),
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildNoteCard() {
    return Obx(() {
      if (controller.items.isEmpty) return const SizedBox.shrink();
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFEFF4FF),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.info_outline, color: Color(0xFF717786), size: 20),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Berat akhir akan ditimbang ulang oleh kurir saat penjemputan untuk hasil yang akurat.',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF414755),
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildBottomCTA(NumberFormat currencyFormat) {
    return Obx(() {
      if (controller.items.isEmpty) return const SizedBox.shrink();
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          border: const Border(top: BorderSide(color: Color(0xFFC1C6D7), width: 0.5)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0058BC).withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: () => Get.toNamed(Routes.CHECKOUT),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0058BC),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Lanjut ke Pembayaran',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward, size: 20),
              ],
            ),
          ),
        ),
      );
    });
  }
}
