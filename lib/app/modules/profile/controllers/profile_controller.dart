import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cleango_mobile/app/data/services/auth_service.dart';
import '../../../utils/snackbar_util.dart';

class ProfileController extends GetxController {
  final authService = Get.find<AuthService>();

  String get userName {
    final name = authService.currentUser.value?.fullName;
    return (name != null && name.isNotEmpty) ? name : 'Guest User';
  }

  String get userEmail {
    final email = authService.currentUser.value?.email;
    return (email != null && email.isNotEmpty) ? email : 'guest@example.com';
  }

  void changePassword() {
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
        passwordStrengthColor.value = const Color(0xFF0058BC); // CleanGO Blue
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
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildPasswordField(String label, RxBool isObscure, TextEditingController ctrl) {
    return Obx(() => TextField(
      controller: ctrl,
      obscureText: isObscure.value,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF414755)),
        prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF414755)),
        suffixIcon: IconButton(
          icon: Icon(
            isObscure.value ? Icons.visibility_off : Icons.visibility,
            color: const Color(0xFF414755),
          ),
          onPressed: () => isObscure.toggle(),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF0058BC)),
        ),
        filled: true,
        fillColor: const Color(0xFFF8F9FF),
      ),
    ));
  }

  void logout() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFBA1A1A).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.logout, color: Color(0xFFBA1A1A), size: 32),
              ),
              const SizedBox(height: 20),
              const Text(
                'Keluar Akun',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0B1C30),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Apakah Anda yakin ingin keluar dari aplikasi?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF414755),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: const BorderSide(color: Color(0xFFC1C6D7)),
                      ),
                      child: const Text(
                        'Batal',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF414755),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        authService.logout();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFBA1A1A),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Ya, Keluar',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
