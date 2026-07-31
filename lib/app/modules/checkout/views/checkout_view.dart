import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../cart/controllers/cart_controller.dart';
import '../controllers/checkout_controller.dart';

class CheckoutView extends GetView<CheckoutController> {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProgressStepper(),
              const SizedBox(height: 32),
              _buildOrderSummary(),
              const SizedBox(height: 24),
              _buildVisualDivider(),
              const SizedBox(height: 24),
              _buildCustomerInfoForm(),
              const SizedBox(height: 32),
              _buildPlaceOrderSection(),
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

      title: const Text(
        'Pembayaran',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF0B1C30),
        ),
      ),
      centerTitle: true,
      leadingWidth: 80,
      leading: Obx(() => Row(
        children: [
          const BackButton(color: Color(0xFF0B1C30)),
          CircleAvatar(
            radius: 16,
            backgroundColor: const Color(0xFF0058BC),
            child: Text(
              controller.authService.userInitials,
              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      )),
      actions: const [],
    );
  }

  Widget _buildProgressStepper() {
    return Row(
      children: [
        _buildStepItem(Icons.shopping_cart, 'Keranjang', isActive: true, isCompleted: false),
        _buildStepDivider(isActive: true),
        _buildStepItem(Icons.location_on, 'Detail', isActive: true, isCompleted: false),
        _buildStepDivider(isActive: false),
        _buildStepItem(Icons.check_circle, 'Konfirmasi', isActive: false, isCompleted: false),
      ],
    );
  }

  Widget _buildStepItem(IconData icon, String label, {required bool isActive, required bool isCompleted}) {
    final color = isActive ? const Color(0xFF0058BC) : const Color(0xFF0B1C30).withValues(alpha: 0.4);
    final bgColor = isActive ? const Color(0xFF0058BC) : const Color(0xFFD3E5F1).withValues(alpha: 0.5);
    final iconColor = isActive ? Colors.white : const Color(0xFF0B1C30).withValues(alpha: 0.4);

    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 18, color: iconColor),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildStepDivider({required bool isActive}) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16), // align with icon centers
        color: isActive ? const Color(0xFF0058BC) : const Color(0xFF0070EB).withValues(alpha: 0.2),
      ),
    );
  }

  Widget _buildOrderSummary() {
    final cartController = Get.find<CartController>();
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Obx(() {
      final items = cartController.items;
      final totalItems = items.length;
      final itemNames = items.isEmpty ? 'Tidak ada item' : items.map((e) => e.title).join(' & ');
      final subtotal = cartController.subtotal;
      final serviceFee = cartController.serviceFee;
      final totalPayment = cartController.totalPayment;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Ringkasan Pesanan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0B1C30),
                ),
              ),
              InkWell(
                onTap: () => Get.back(),
                child: const Text(
                  'Edit',
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
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
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
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5EEFF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: cartController.items.isNotEmpty && cartController.items.first.icon.startsWith('http')
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                cartController.items.first.icon,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => const Icon(Icons.local_laundry_service, color: Color(0xFF0058BC), size: 32),
                              ),
                            )
                          : const Icon(Icons.local_laundry_service, color: Color(0xFF0058BC), size: 32),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total Item ($totalItems)',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0B1C30),
                                ),
                              ),
                              Text(
                                currencyFormat.format(subtotal),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0B1C30),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            itemNames,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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
                const SizedBox(height: 16),
                const Divider(height: 1, color: Color(0xFFC1C6D7)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Subtotal', style: TextStyle(fontSize: 14, color: Color(0xFF414755))),
                    Text(currencyFormat.format(subtotal), style: const TextStyle(fontSize: 14, color: Color(0xFF414755))),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Biaya Layanan', style: TextStyle(fontSize: 14, color: Color(0xFF414755))),
                    Text(currencyFormat.format(serviceFee), style: const TextStyle(fontSize: 14, color: Color(0xFF0058BC))),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0B1C30))),
                    Text(currencyFormat.format(totalPayment), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0058BC))),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildVisualDivider() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, const Color(0xFFC1C6D7).withValues(alpha: 0.5)],
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Icon(Icons.dry_cleaning, color: Color(0xFFC1C6D7)),
        ),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color(0xFFC1C6D7).withValues(alpha: 0.5), Colors.transparent],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerInfoForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Detail Penjemputan',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0B1C30),
          ),
        ),
        const SizedBox(height: 16),
        _buildTextField('Nama Lengkap', 'Budi Santoso', controller.nameController, TextInputType.name),
        const SizedBox(height: 12),
        _buildTextField('Nomor Telepon', '+62 812...', controller.phoneController, TextInputType.phone),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 4, bottom: 4),
              child: Text(
                'Alamat Lengkap',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF414755),
                ),
              ),
            ),
            InkWell(
              onTap: controller.useCurrentLocation,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF0058BC).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.my_location, size: 14, color: Color(0xFF0058BC)),
                    SizedBox(width: 4),
                    Text(
                      'Gunakan Lokasi Saat Ini',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0058BC),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Stack(
          children: [
            TextField(
              controller: controller.addressController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Masukkan alamat lengkap beserta patokan...',
                hintStyle: TextStyle(color: const Color(0xFF717786).withValues(alpha: 0.7)),
                filled: true,
                fillColor: const Color(0xFFEFF4FF),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
            Obx(() {
              if (controller.isLoadingLocation.value) {
                return Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF4FF).withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF0058BC)),
                          ),
                          SizedBox(width: 8),
                          Text('Mendeteksi...', style: TextStyle(fontSize: 12, color: Color(0xFF0B1C30))),
                        ],
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
        Obx(() {
          if (controller.currentLat.value != null && controller.currentLng.value != null) {
            return Container(
              margin: const EdgeInsets.only(top: 16),
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFC1C6D7), width: 1),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: LatLng(controller.currentLat.value!, controller.currentLng.value!),
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
                          point: LatLng(controller.currentLat.value!, controller.currentLng.value!),
                          width: 40,
                          height: 40,
                          child: const Icon(Icons.location_on, color: Colors.red, size: 40),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }

  Widget _buildTextField(String label, String hint, TextEditingController textController, TextInputType type) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF414755),
            ),
          ),
        ),
        TextField(
          controller: textController,
          keyboardType: type,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: const Color(0xFF717786).withValues(alpha: 0.7)),
            filled: true,
            fillColor: const Color(0xFFEFF4FF),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceOrderSection() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF0070EB).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            children: [
              Icon(Icons.info, color: Color(0xFF0058BC)),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Kurir akan menjemput pakaian Anda hari ini antara pukul 14:00 - 16:00.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF004493),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Obx(() {
          final isDone = controller.isOrderConfirmed.value;
          
          return ElevatedButton(
            onPressed: (controller.isPlacingOrder.value || isDone) ? null : controller.placeOrder,
            style: ElevatedButton.styleFrom(
              backgroundColor: isDone ? const Color(0xFFC64F00) : const Color(0xFF0058BC),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
            ),
            child: controller.isPlacingOrder.value
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(isDone ? Icons.check_circle : Icons.arrow_forward),
                      const SizedBox(width: 8),
                      Text(
                        isDone ? 'Pesanan Dikonfirmasi!' : 'Buat Pesanan',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
          );
        }),
        const SizedBox(height: 16),
        const Text(
          'Dengan membuat pesanan, Anda menyetujui Syarat & Ketentuan serta Kebijakan Privasi CleanGo.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF717786),
          ),
        ),
      ],
    );
  }
}
