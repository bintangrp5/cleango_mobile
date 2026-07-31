import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/home_controller.dart';
import '../../../routes/app_pages.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      appBar: _buildAppBar(context),
      drawer: _buildDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGreetingSection(),
              const SizedBox(height: 24),
              _buildPromoBanner(),
              const SizedBox(height: 24),
              _buildCategoriesSection(),
              const SizedBox(height: 32),
              _buildPopularServicesSection(),
              const SizedBox(height: 32),
              _buildEmptyState(),
              const SizedBox(height: 48), // Padding bawah
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFF8F9FF).withValues(alpha: 0.9),
      elevation: 0,
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu, color: Color(0xFF0B1C30)),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      title: const Text(
        'Beranda',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Color(0xFF0058BC),
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

  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 60, left: 24, right: 24, bottom: 24),
              color: const Color(0xFF0070EB).withValues(alpha: 0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => CircleAvatar(
                    radius: 32,
                    backgroundColor: const Color(0xFF0058BC),
                    child: Text(
                      controller.authService.userInitials,
                      style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  )),
                  const SizedBox(height: 16),
                  Text(
                    controller.userName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0B1C30),
                    ),
                  ),
                  const Text(
                    'user@example.com', // TODO: Ambil dari AuthService
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF414755),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 16),
                children: [
                  _buildDrawerItem(Icons.home, 'Beranda', true, () => Get.back()),
                  _buildDrawerItem(Icons.location_on, 'Alamat Saya', false, () {
                    Get.back();
                    Get.snackbar('Info', 'Menu Alamat Saya belum tersedia');
                  }),
                  _buildDrawerItem(Icons.local_offer, 'Promo', false, () {
                    Get.back();
                    Get.snackbar('Info', 'Menu Promo belum tersedia');
                  }),
                  _buildDrawerItem(Icons.info, 'Tentang Kami', false, () {
                    Get.back();
                    Get.snackbar('Info', 'Menu Tentang Kami belum tersedia');
                  }),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Divider(color: Color(0xFFC1C6D7)),
                  ),
                  _buildDrawerItem(Icons.logout, 'Keluar', false, () {
                    Get.back();
                    _showLogoutDialog();
                  }, isError: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, bool isActive, VoidCallback onTap, {bool isError = false}) {
    final color = isError ? const Color(0xFFBA1A1A) : (isActive ? const Color(0xFF0058BC) : const Color(0xFF414755));
    final bgColor = isActive ? const Color(0xFF0058BC).withValues(alpha: 0.1) : Colors.transparent;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          color: color,
        ),
      ),
      tileColor: bgColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      onTap: onTap,
    );
  }

  void _showLogoutDialog() {
    Get.defaultDialog(
      title: 'Keluar',
      middleText: 'Apakah Anda yakin ingin keluar?',
      textConfirm: 'Ya',
      textCancel: 'Tidak',
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back();
        controller.logout();
      },
    );
  }

  Widget _buildGreetingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Halo, ${controller.userName} 👋',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0B1C30),
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          "Siap untuk mencuci pakaian hari ini?",
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF414755),
          ),
        ),
      ],
    );
  }

  Widget _buildPromoBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF0058BC),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0058BC).withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'PENJEMPUTAN CEPAT, HASIL BERSIH',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Diskon 20%\nPesanan Pertama',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Berikan pakaianmu perawatan terbaik.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF0058BC),
                  elevation: 2,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text(
                  'Klaim Sekarang',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            right: -30,
            bottom: -20,
            child: Opacity(
              opacity: 0.2,
              child: Transform.rotate(
                angle: 0.2,
                child: const Icon(
                  Icons.checkroom,
                  size: 140,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Kategori',
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
            _buildCategoryItem(Icons.local_laundry_service, 'Cuci & Setrika'),
            _buildCategoryItem(Icons.iron, 'Setrika Saja'),
            _buildCategoryItem(Icons.bolt, 'Kilat'),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryItem(IconData icon, String label) {
    return Expanded(
      child: InkWell(
        onTap: () => Get.toNamed(Routes.SERVICES),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF4FF),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
                  ],
                ),
                child: Icon(icon, color: const Color(0xFF0058BC), size: 24),
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF414755),
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPopularServicesSection() {
    return Obx(() {
      if (controller.isLoadingServices.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.services.isEmpty) {
        return const Center(child: Text('Tidak ada layanan tersedia.'));
      }

      final displayServices = controller.services.take(3).toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Layanan Populer',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0B1C30),
                ),
              ),
              GestureDetector(
                onTap: () => Get.toNamed(Routes.SERVICES),
                child: const Text(
                  'Lihat Semua',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0058BC),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...displayServices.map((service) {
            final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: GestureDetector(
                onTap: () => Get.toNamed(Routes.SERVICE_DETAIL, arguments: service.id),
                child: _buildServiceCard(
                  title: service.name,
                  subtitle: '${service.description ?? ''} • Selesai ${service.estimatedDuration}',
                  price: '${formatCurrency.format(service.pricePerKg)} /kg',
                  imageUrl: service.imageUrl ?? 'https://images.unsplash.com/photo-1517677208171-0bc6725a3e60?w=200',
                  badge: 'TERLARIS',
                ),
              ),
            );
          }),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () => Get.toNamed(Routes.SERVICES),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 56),
              backgroundColor: const Color(0xFF0070EB),
              side: BorderSide.none,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Lihat Semua Layanan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward, color: Colors.white, size: 20),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildServiceCard({
    required String title,
    required String subtitle,
    required String price,
    required String imageUrl,
    required String badge,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0B1C30),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      price,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0058BC),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF414755),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCE9FF),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    badge,
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF414755),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Opacity(
        opacity: 0.6,
        child: Column(
          children: [
            const Icon(
              Icons.bubble_chart,
              color: Color(0xFF0058BC),
              size: 48,
            ),
            const SizedBox(height: 12),
            const Text(
              'Pakaianmu siap! Nikmati cucian bersih hari ini.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF414755),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
