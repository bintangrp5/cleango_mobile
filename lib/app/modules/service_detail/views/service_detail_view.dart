import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/service_detail_controller.dart';

class ServiceDetailView extends GetView<ServiceDetailController> {
  const ServiceDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          // Background Image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 320,
            child: _buildImageHeader(),
          ),
          // Scrollable Content
          SafeArea(
            bottom: false,
            child: CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(child: SizedBox(height: 200)),
                SliverToBoxAdapter(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFF8F9FF),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTitleSection(),
                          const SizedBox(height: 24),
                          _buildDescriptionSection(),
                          const SizedBox(height: 24),
                          _buildFeaturesBento(),
                          const SizedBox(height: 24),
                          _buildOrderConfiguration(currencyFormat),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Fixed Bottom Button
          Positioned(
            left: 20,
            right: 20,
            bottom: 24 + MediaQuery.of(context).padding.bottom,
            child: _buildActionButton(),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: CircleAvatar(
          backgroundColor: Colors.white.withValues(alpha: 0.9),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF0B1C30)),
            onPressed: () => Get.back(),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: CircleAvatar(
            backgroundColor: Colors.white.withValues(alpha: 0.9),
            child: IconButton(
              icon: const Icon(Icons.share, color: Color(0xFF0B1C30)),
              onPressed: () {},
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageHeader() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          controller.service.imageUrl ?? 'https://images.unsplash.com/photo-1545173168-9f1947eebb7f?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80',
          fit: BoxFit.cover,
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.black.withValues(alpha: 0.4),
                Colors.transparent,
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 40,
          left: 20,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFFFDBCC),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star, size: 14, color: Color(0xFF351000)),
                SizedBox(width: 4),
                Text(
                  'Layanan Populer',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF351000),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          controller.service.name,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0B1C30),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.payments, size: 20, color: Color(0xFF0058BC)),
            const SizedBox(width: 8),
            Text(
              'Rp ${controller.service.pricePerKg.toInt()}',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0058BC),
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '/kg',
              style: TextStyle(
                fontSize: 14,
                color: const Color(0xFF50616B).withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'DESKRIPSI',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0B1C30),
            letterSpacing: 1.2,
          ),
        ),
        SizedBox(height: 8),
        Text(
          controller.service.description ?? 'Tidak ada deskripsi',
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF50616B),
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturesBento() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF4FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0058BC).withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.timer, color: Color(0xFF0058BC)),
                ),
                const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Estimasi', style: TextStyle(fontSize: 12, color: Color(0xFF50616B))),
                      Text(controller.service.estimatedDuration, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0B1C30))),
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
              color: const Color(0xFFEFF4FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF9E3D00).withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_circle, color: Color(0xFF9E3D00)),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Hasil', style: TextStyle(fontSize: 12, color: Color(0xFF50616B))),
                    Text('Premium', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0B1C30))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderConfiguration(NumberFormat currencyFormat) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFD3E4FE).withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Berat Pakaian',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0B1C30),
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.info, size: 14, color: Color(0xFFBA1A1A)),
                      SizedBox(width: 4),
                      Text(
                        'Min. order 2kg',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFFBA1A1A),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Obx(() => InkWell(
                      onTap: controller.weight.value > 2 ? controller.decrementWeight : null,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: controller.weight.value > 2 ? const Color(0xFFDCE9FF) : Colors.grey.shade200,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.remove,
                          color: controller.weight.value > 2 ? const Color(0xFF0B1C30) : Colors.grey,
                        ),
                      ),
                    )),
                    const SizedBox(width: 12),
                    Obx(() => Text(
                      '${controller.weight.value} kg',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0B1C30),
                      ),
                    )),
                    const SizedBox(width: 12),
                    InkWell(
                      onTap: controller.incrementWeight,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Color(0xFF0058BC),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.add, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(height: 1, color: Color(0xFFC1C6D7)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Pembayaran',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF0B1C30),
                ),
              ),
              Obx(() => Text(
                currencyFormat.format(controller.totalPrice),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0058BC),
                ),
              )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    return ElevatedButton(
      onPressed: controller.addToCart,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0058BC),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 8,
        shadowColor: const Color(0xFF0058BC).withValues(alpha: 0.4),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag, size: 20),
          SizedBox(width: 12),
          Text(
            'Tambah ke Keranjang',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
