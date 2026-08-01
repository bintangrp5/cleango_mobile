import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/admin_services_controller.dart';
import 'package:intl/intl.dart';
import '../../../widgets/admin_drawer.dart';
import '../../../routes/app_pages.dart';
import '../../../data/models/service_model.dart';

class AdminServicesView extends GetView<AdminServicesController> {
  const AdminServicesView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AdminServicesController());
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      drawer: const AdminDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.black12,
        iconTheme: const IconThemeData(color: Color(0xFF0058BC)),
        title: const Text(
          'Kelola Layanan',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0058BC),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.services.isEmpty) {
          return const Center(child: Text('Belum ada layanan.'));
        }

        return ListView.builder(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 32),
          itemCount: controller.services.length + 1,
          itemBuilder: (context, index) {
            if (index == controller.services.length) {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 32.0),
                child: ElevatedButton.icon(
                  onPressed: () => Get.toNamed(Routes.ADMIN_SERVICE_FORM),
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text('Tambah Layanan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0058BC),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 2,
                  ),
                ),
              );
            }
            final service = controller.services[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    Get.defaultDialog(
                      title: service.name,
                      titleStyle: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0058BC)),
                      content: SizedBox(
                        width: 300,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (service.imageUrl != null && service.imageUrl!.isNotEmpty)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  service.imageUrl!, 
                                  height: 150, 
                                  width: 300, 
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                                ),
                              )
                            else
                              const Icon(Icons.local_laundry_service, size: 80, color: Color(0xFF0058BC)),
                            const SizedBox(height: 16),
                            Text(service.description ?? 'Tidak ada deskripsi.', textAlign: TextAlign.center, style: const TextStyle(fontSize: 14)),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Harga:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                                Text(NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(service.pricePerKg), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Estimasi:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                                Text(service.estimatedDuration, style: const TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      confirm: ElevatedButton(
                        onPressed: () => Get.back(),
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0058BC)),
                        child: const Text('Tutup', style: TextStyle(color: Colors.white)),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE5EEFF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: service.imageUrl != null && service.imageUrl!.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(service.imageUrl!, fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, color: Colors.grey),
                                  ),
                                )
                              : const Icon(Icons.local_laundry_service, color: Color(0xFF0058BC), size: 30),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                service.name,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0B1C30)),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(service.pricePerKg)} / kg',
                                style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Switch(
                              value: service.isActive,
                              activeTrackColor: const Color(0xFF0058BC).withValues(alpha: 0.5),
                              activeThumbColor: const Color(0xFF0058BC),
                              onChanged: (val) {
                                controller.toggleServiceStatus(service.id, service.isActive);
                              },
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  icon: const Icon(Icons.edit, color: Colors.grey, size: 20),
                                  onPressed: () => Get.toNamed(Routes.ADMIN_SERVICE_FORM, arguments: service),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                                  onPressed: () => _confirmDelete(Get.context!, service),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  void _confirmDelete(BuildContext context, ServiceModel service) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Layanan'),
          content: Text('Apakah Anda yakin ingin menghapus layanan "${service.name}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                controller.deleteService(service.id);
              },
              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
