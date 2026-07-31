import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/admin_service_form_controller.dart';

class AdminServiceFormView extends GetView<AdminServiceFormController> {
  const AdminServiceFormView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AdminServiceFormController());

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.black12,
        iconTheme: const IconThemeData(color: Color(0xFF0058BC)),
        title: Obx(() => Text(
          controller.isEditMode.value ? 'Edit Layanan' : 'Tambah Layanan',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0058BC),
          ),
        )),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Informasi Layanan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0B1C30)),
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: controller.nameController,
              label: 'Nama Layanan',
              hint: 'misal: Cuci Basah Reguler',
              icon: Icons.local_laundry_service,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: controller.descController,
              label: 'Deskripsi',
              hint: 'Deskripsi singkat layanan...',
              icon: Icons.description,
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: controller.priceController,
                    label: 'Harga (Rp)',
                    hint: '6000',
                    icon: Icons.payments,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    controller: controller.durationController,
                    label: 'Durasi',
                    hint: '24 Jam',
                    icon: Icons.timer,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Gambar Layanan',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0B1C30)),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => controller.pickImage(),
              child: Obx(() {
                final selectedImage = controller.selectedImage.value;
                final currentUrl = controller.imageController.text;

                return Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF0058BC).withValues(alpha: 0.3), width: 1.5),
                  ),
                  child: selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(selectedImage.path),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        )
                      : (currentUrl.isNotEmpty && currentUrl.startsWith('http')
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(currentUrl, fit: BoxFit.cover, errorBuilder: (c,e,s) => const Icon(Icons.image_not_supported, color: Colors.grey, size: 40)),
                            )
                          : const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_photo_alternate, color: Color(0xFF0058BC), size: 40),
                                SizedBox(height: 8),
                                Text('Pilih Gambar', style: TextStyle(color: Color(0xFF0058BC))),
                              ],
                            )),
                );
              }),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: Obx(() => ElevatedButton(
                onPressed: controller.isLoading.value ? null : () => controller.submit(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0058BC),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: controller.isLoading.value
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text(
                        'Simpan',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0B1C30)),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey),
            prefixIcon: maxLines == 1 ? Icon(icon, color: Colors.grey) : null,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF0058BC), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
