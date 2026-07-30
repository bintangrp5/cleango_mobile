import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/order_tracking_controller.dart';

class OrderTrackingView extends GetView<OrderTrackingController> {
  const OrderTrackingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeroSection(),
              const SizedBox(height: 24),
              _buildStepper(),
              const SizedBox(height: 24),
              _buildDeliveryDetails(),
              const SizedBox(height: 24),
              _buildLiveMap(),
              const SizedBox(height: 24),
              _buildOrderDetailsAccordion(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFFF8F9FF).withValues(alpha: 0.9),
      elevation: 0,
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
            'Pelacakan',
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
            backgroundImage: const NetworkImage('https://ui-avatars.com/api/?name=User&background=0058BC&color=fff'),
            backgroundColor: Colors.grey.shade200,
          ),
        ),
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
              const Text(
                'PESANAN DIPROSES',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: Color(0xFF0058BC),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Pakaian bersihmu sedang di jalan',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0B1C30),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Estimasi pengantaran: ${controller.estimatedDelivery.value}',
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
              Positioned(
                left: 15,
                top: 16,
                bottom: 100, // Roughly matching step 2 (Processing)
                width: 2,
                child: Container(color: const Color(0xFF0058BC)),
              ),
              Column(
                children: [
                  _buildStep(
                    icon: Icons.check,
                    title: 'Dijemput',
                    subtitle: '24 Okt, 09:15 WIB',
                    isActive: false,
                    isCompleted: true,
                  ),
                  const SizedBox(height: 24),
                  _buildStep(
                    icon: Icons.local_laundry_service,
                    title: 'Diproses',
                    subtitle: 'Sedang dicuci & dilipat',
                    isActive: true,
                    isCompleted: false,
                  ),
                  const SizedBox(height: 24),
                  _buildStep(
                    icon: Icons.local_shipping,
                    title: 'Dalam Pengantaran',
                    subtitle: 'Diperkirakan tiba pukul 16:15',
                    isActive: false,
                    isCompleted: false,
                  ),
                  const SizedBox(height: 24),
                  _buildStep(
                    icon: Icons.task_alt,
                    title: 'Selesai',
                    subtitle: 'Segera tiba',
                    isActive: false,
                    isCompleted: false,
                  ),
                ],
              ),
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

  Widget _buildDeliveryDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFDCE9FF).withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                const CircleAvatar(
                  radius: 28,
                  backgroundImage: NetworkImage('https://images.unsplash.com/photo-1599566150163-29194dcaad36?ixlib=rb-1.2.1&auto=format&fit=crop&w=200&q=80'),
                ),
                Positioned(
                  bottom: -2,
                  right: -2,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Color(0xFF0058BC),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.verified, color: Colors.white, size: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.driverName.value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0B1C30),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Mitra CleanGo • ${controller.driverRating.value} ★',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF384953),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Row(
              children: [
                InkWell(
                  onTap: controller.callDriver,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFF0058BC),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.call, color: Colors.white, size: 20),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: controller.chatDriver,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFF0058BC),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.chat_bubble, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveMap() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Pelacakan Langsung',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0B1C30),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFD8E2FF),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Text(
                  'Kurir berjarak 3.8 km',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0058BC),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(16),
              image: const DecorationImage(
                image: NetworkImage('https://maps.googleapis.com/maps/api/staticmap?center=Brooklyn,New+York&zoom=14&size=600x400&maptype=roadmap&key=INVALID_KEY'),
                fit: BoxFit.cover,
              ),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
              ],
            ),
            child: Stack(
              children: [
                // Fallback texture if image fails
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF4FF).withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                // Driver Marker Simulation
                Positioned(
                  top: 120,
                  left: 100,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Color(0xFF0058BC),
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))],
                        ),
                        child: const Icon(Icons.local_shipping, color: Colors.white, size: 20),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF0058BC),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
                // Destination Marker
                Positioned(
                  top: 60,
                  right: 80,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))],
                    ),
                    child: const Icon(Icons.home, color: Color(0xFF9E3D00), size: 20),
                  ),
                ),
                // Zoom Controls
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: Column(
                    children: [
                      _buildMapButton(Icons.add),
                      const SizedBox(height: 8),
                      _buildMapButton(Icons.remove),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapButton(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))],
      ),
      child: Icon(icon, color: const Color(0xFF0B1C30)),
    );
  }

  Widget _buildOrderDetailsAccordion() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFEFF4FF),
          borderRadius: BorderRadius.circular(16),
        ),
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
                    'Pesanan #${controller.orderId.value}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0B1C30),
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    '12 Pakaian • Rp 92.000',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF414755),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF717786)),
          ],
        ),
      ),
    );
  }
}
