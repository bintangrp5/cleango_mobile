import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_pages.dart';
import '../data/services/auth_service.dart';
import '../utils/snackbar_util.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0058BC), Color(0xFF0070EB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                const Text('CleanGO', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          _buildDrawerItem(
            icon: Icons.dashboard,
            title: 'Dasbor Utama',
            route: Routes.ADMIN_DASHBOARD,
          ),
          _buildDrawerItem(
            icon: Icons.people,
            title: 'Data Pengguna',
            route: Routes.ADMIN_USERS,
          ),
          _buildDrawerItem(
            icon: Icons.local_laundry_service,
            title: 'Kelola Layanan',
            route: Routes.ADMIN_SERVICES,
          ),
          _buildDrawerItem(
            icon: Icons.receipt_long,
            title: 'Semua Pesanan',
            route: Routes.ADMIN_ORDERS,
          ),
          const Spacer(),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.lock_outline, color: Color(0xFF414755)),
            title: const Text('Ubah Sandi', style: TextStyle(color: Color(0xFF414755))),
            onTap: () {
              Get.back();
              _showChangePasswordDialog();
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text('Keluar', style: TextStyle(color: Colors.redAccent)),
            onTap: () {
              Get.dialog(
                Dialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.logout, color: Colors.redAccent, size: 36),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Keluar',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0B1C30)),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Apakah Anda yakin ingin keluar dari sesi Admin saat ini?',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 15, color: Colors.grey),
                        ),
                        const SizedBox(height: 28),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Get.back(),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  side: BorderSide(color: Colors.grey.shade400),
                                ),
                                child: const Text('Batal', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 16)),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Get.back();
                                  Get.find<AuthService>().logout();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  elevation: 0,
                                ),
                                child: const Text('Keluar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({required IconData icon, required String title, required String route}) {
    final isSelected = Get.currentRoute == route;
    return ListTile(
      leading: Icon(icon, color: isSelected ? const Color(0xFF0058BC) : Colors.grey),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? const Color(0xFF0058BC) : Colors.grey,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: () {
        Get.back(); // Close drawer
        if (!isSelected) {
          Get.offNamed(route);
        }
      },
    );
  }

  void _showChangePasswordDialog() {
    final authService = Get.find<AuthService>();
    final oldPasswordCtrl = TextEditingController();
    final newPasswordCtrl = TextEditingController();
    final confirmPasswordCtrl = TextEditingController();
    final isLoading = false.obs;

    final passwordStrength = ''.obs;
    final passwordStrengthColor = Colors.transparent.obs;
    final isPasswordValid = false.obs;

    void checkPasswordStrength(String password) {
      if (password.isEmpty) {
        passwordStrength.value = '';
        passwordStrengthColor.value = Colors.transparent;
        isPasswordValid.value = false;
        return;
      }

      if (password.length < 8) {
        passwordStrength.value = 'Lemah (Minimal 8 karakter)';
        passwordStrengthColor.value = Colors.red;
        isPasswordValid.value = false;
        return;
      }

      bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
      bool hasLowercase = password.contains(RegExp(r'[a-z]'));
      bool hasDigits = password.contains(RegExp(r'[0-9]'));
      bool hasSpecialCharacters = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

      if (!hasUppercase || !hasLowercase) {
        passwordStrength.value = 'Lemah (Butuh huruf besar & kecil)';
        passwordStrengthColor.value = Colors.red;
        isPasswordValid.value = false;
        return;
      }

      isPasswordValid.value = true;
      if (hasDigits && hasSpecialCharacters) {
        passwordStrength.value = 'Sangat Kuat';
        passwordStrengthColor.value = const Color(0xFF0058BC);
      } else if (hasDigits || hasSpecialCharacters) {
        passwordStrength.value = 'Kuat';
        passwordStrengthColor.value = Colors.green;
      } else {
        passwordStrength.value = 'Sedang';
        passwordStrengthColor.value = Colors.orange;
      }
    }

    newPasswordCtrl.addListener(() {
      checkPasswordStrength(newPasswordCtrl.text);
    });

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Ubah Kata Sandi',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0B1C30),
                ),
              ),
              const SizedBox(height: 24),
              _buildPasswordField('Kata Sandi Lama', true.obs, oldPasswordCtrl),
              const SizedBox(height: 16),
              _buildPasswordField('Kata Sandi Baru', true.obs, newPasswordCtrl),
              
              Obx(() {
                if (passwordStrength.value.isEmpty) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 8, left: 4, bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Icon(Icons.shield_outlined, size: 14, color: passwordStrengthColor.value),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'Kekuatan Sandi: ${passwordStrength.value}',
                          style: TextStyle(
                            color: passwordStrengthColor.value,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 12),
              _buildPasswordField('Konfirmasi Kata Sandi Baru', true.obs, confirmPasswordCtrl),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: Obx(() => ElevatedButton(
                  onPressed: isLoading.value ? null : () async {
                    final oldP = oldPasswordCtrl.text.trim();
                    final newP = newPasswordCtrl.text.trim();
                    final confP = confirmPasswordCtrl.text.trim();
                    
                    if (oldP.isEmpty || newP.isEmpty || confP.isEmpty) {
                      AppSnackbar.show('Error', 'Semua kolom harus diisi', isError: true);
                      return;
                    }
                    if (newP != confP) {
                      AppSnackbar.show('Error', 'Konfirmasi sandi tidak cocok', isError: true);
                      return;
                    }
                    if (!isPasswordValid.value) {
                      AppSnackbar.show('Error', 'Kata sandi Anda terlalu lemah. Pastikan minimal 8 karakter dan memiliki huruf besar & kecil.', isError: true);
                      return;
                    }
                    
                    isLoading.value = true;
                    try {
                      await authService.changePassword(oldP, newP);
                      Get.back();
                      AppSnackbar.show('Sukses', 'Kata sandi berhasil diubah');
                    } catch (e) {
                      AppSnackbar.show('Error', e.toString().replaceAll('Exception: ', ''), isError: true);
                    } finally {
                      isLoading.value = false;
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0058BC),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: isLoading.value 
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text(
                          'Simpan Kata Sandi',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                )),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildPasswordField(String label, RxBool obscureText, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 8),
        Obx(() => TextField(
              controller: controller,
              obscureText: obscureText.value,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF414755)),
                suffixIcon: IconButton(
                  icon: Icon(
                    obscureText.value ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () => obscureText.value = !obscureText.value,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: const Color(0xFFF5F7FA),
              ),
            )),
      ],
    );
  }
}
