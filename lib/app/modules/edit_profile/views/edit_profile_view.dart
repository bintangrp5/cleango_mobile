import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/edit_profile_controller.dart';

class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0058BC),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Edit Profil',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ubah Data Diri',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0B1C30),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Pastikan data yang Anda masukkan benar agar mempermudah kurir saat proses penjemputan dan pengantaran.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF717786),
                ),
              ),
              const SizedBox(height: 32),
              
              // Form Nama Lengkap
              const Text(
                'Nama Lengkap',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0B1C30),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller.fullNameController,
                decoration: InputDecoration(
                  hintText: 'Masukkan nama lengkap',
                  prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF0058BC)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Form Nomor HP
              const Text(
                'Nomor Telepon',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0B1C30),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller.phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: 'Contoh: 08123456789',
                  prefixIcon: const Icon(Icons.phone_outlined, color: Color(0xFF0058BC)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Form Alamat
              const Text(
                'Alamat Lengkap',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0B1C30),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller.addressController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Masukkan alamat lengkap (Jalan, RT/RW, Patokan)',
                  prefixIcon: const Icon(Icons.location_on_outlined, color: Color(0xFF0058BC)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 48),

              // Tombol Simpan
              SizedBox(
                width: double.infinity,
                child: Obx(() => ElevatedButton(
                  onPressed: controller.isLoading.value ? null : controller.saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0058BC),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                  ),
                  child: controller.isLoading.value
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                        )
                      : const Text(
                          'Simpan Profil',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
