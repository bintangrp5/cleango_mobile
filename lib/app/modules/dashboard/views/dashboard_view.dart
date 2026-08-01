import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cleango_mobile/app/modules/home/views/home_view.dart';
import 'package:cleango_mobile/app/modules/order_tracking/views/order_tracking_view.dart';
import 'package:cleango_mobile/app/modules/cart/views/cart_view.dart';
import 'package:cleango_mobile/app/modules/profile/views/profile_view.dart';
import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => IndexedStack(
        index: controller.tabIndex.value,
        children: [
          const HomeView(),
          controller.visitedTabs.contains(1) ? const OrderTrackingView() : const SizedBox.shrink(),
          controller.visitedTabs.contains(2) ? const CartView() : const SizedBox.shrink(),
          controller.visitedTabs.contains(3) ? const ProfileView() : const SizedBox.shrink(),
        ],
      )),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home, 'Beranda', 0),
              _buildNavItem(Icons.receipt_long, 'Pesanan', 1),
              _buildNavItem(Icons.shopping_cart, 'Keranjang', 2),
              _buildNavItem(Icons.person, 'Profil', 3),
            ],
          )),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isActive = controller.tabIndex.value == index;
    return InkWell(
      onTap: () => controller.changeTabIndex(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? const Color(0xFF0058BC) : const Color(0xFF717786),
            size: 26,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              color: isActive ? const Color(0xFF0058BC) : const Color(0xFF717786),
            ),
          ),
        ],
      ),
    );
  }
}
