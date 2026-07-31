import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../../../routes/app_pages.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0058BC),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Profil Saya',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildProfileHeader(),
              const SizedBox(height: 24),
              _buildMenuSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 32, top: 24),
      decoration: const BoxDecoration(
        color: Color(0xFF0058BC),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
            ),
            child: Obx(() => CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              child: Text(
                controller.authService.userInitials,
                style: const TextStyle(color: Color(0xFF0058BC), fontSize: 36, fontWeight: FontWeight.bold),
              ),
            )),
          ),
          const SizedBox(height: 16),
          Obx(() => Text(
            controller.userName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          )),
          const SizedBox(height: 4),
          Obx(() => Text(
            controller.userEmail,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildMenuSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pengaturan Akun',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0B1C30),
            ),
          ),
          const SizedBox(height: 16),
          _buildMenuItem(
            icon: Icons.person_outline,
            title: 'Edit Profil',
            onTap: () => Get.toNamed(Routes.EDIT_PROFILE),
          ),
          _buildMenuItem(
            icon: Icons.history,
            title: 'Riwayat Pesanan',
            onTap: () => Get.toNamed(Routes.ORDER_HISTORY),
          ),
          _buildMenuItem(
            icon: Icons.lock_outline,
            title: 'Ubah Kata Sandi',
            onTap: controller.changePassword,
          ),
          const SizedBox(height: 24),
          const Text(
            'Lainnya',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0B1C30),
            ),
          ),
          const SizedBox(height: 16),

          const SizedBox(height: 16),
          _buildMenuItem(
            icon: Icons.info_outline,
            title: 'Tentang Kami',
            onTap: () => Get.toNamed(Routes.ABOUT_US),
          ),
          _buildMenuItem(
            icon: Icons.help_outline,
            title: 'Pusat Bantuan',
            onTap: () => Get.toNamed(Routes.HELP_CENTER),
          ),
          const SizedBox(height: 24),
          _buildMenuItem(
            icon: Icons.logout,
            title: 'Keluar',
            isLogout: true,
            onTap: controller.logout,
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }


  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    final color = isLogout ? const Color(0xFFBA1A1A) : const Color(0xFF0B1C30);
    final iconColor = isLogout ? const Color(0xFFBA1A1A) : const Color(0xFF0058BC);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isLogout ? const Color(0xFFFFDAD6) : const Color(0xFFE5EEFF),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        trailing: isLogout 
            ? null 
            : const Icon(Icons.chevron_right, color: Color(0xFF717786)),
      ),
    );
  }
}
