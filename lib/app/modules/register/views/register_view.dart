import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo Section
              const SizedBox(height: 16),
              Image.asset(
                'assets/images/logo.png',
                height: 80,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.local_laundry_service,
                  size: 80,
                  color: Color(0xFF0058BC),
                ),
              ),
              const SizedBox(height: 24),
              
              // Heading
              const Text(
                'Buat Akun',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0B1C30),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Bergabunglah dan nikmati layanan laundry premium.',
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF414755),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 36),

              // Form Container
              Obx(() => Column(
                children: [
                  // Name Input
                  _buildTextField(
                    label: 'Nama Lengkap',
                    hint: 'Nama Lengkap',
                    icon: Icons.person_outline,
                    controller: controller.nameController,
                  ),
                  const SizedBox(height: 20),

                  // Email Input
                  _buildTextField(
                    label: 'Email',
                    hint: 'nama@gmail.com',
                    icon: Icons.mail_outline,
                    controller: controller.emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),

                  // Password Input
                  _buildPasswordField('Kata Sandi', controller.passwordController),
                  const SizedBox(height: 20),
                  
                  // Confirm Password Input
                  _buildPasswordField('Konfirmasi Kata Sandi', controller.confirmPasswordController),
                  const SizedBox(height: 32),

                  // Action Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value ? null : controller.register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0058BC),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: controller.isLoading.value
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : const Text(
                              'Daftar',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                    ),
                  ),
                ],
              )),
              
              const SizedBox(height: 32),

              // Footer Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Sudah punya akun? ",
                    style: TextStyle(color: Color(0xFF414755), fontSize: 15),
                  ),
                  GestureDetector(
                    onTap: controller.goToLogin,
                    child: const Text(
                      'Masuk',
                      style: TextStyle(
                        color: Color(0xFF0058BC),
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
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

  Widget _buildTextField({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF414755),
            ),
          ),
        ),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 16, color: Color(0xFF0B1C30)),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF717786)),
            prefixIcon: Icon(icon, color: const Color(0xFF717786)),
            filled: true,
            fillColor: const Color(0xFFEFF4FF),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF0058BC), width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 18),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField(String label, TextEditingController textController) {
    final isObscure = true.obs;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF414755),
            ),
          ),
        ),
        Obx(() => TextField(
          controller: textController,
          obscureText: isObscure.value,
          style: const TextStyle(fontSize: 16, color: Color(0xFF0B1C30)),
          decoration: InputDecoration(
            hintText: '••••••••',
            hintStyle: const TextStyle(color: Color(0xFF717786)),
            prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF717786)),
            suffixIcon: IconButton(
              icon: Icon(
                isObscure.value ? Icons.visibility_off : Icons.visibility,
                color: const Color(0xFF717786),
              ),
              onPressed: () => isObscure.value = !isObscure.value,
            ),
            filled: true,
            fillColor: const Color(0xFFEFF4FF),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF0058BC), width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 18),
          ),
        )),
      ],
    );
  }
}
