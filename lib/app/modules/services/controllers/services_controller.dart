import 'package:get/get.dart';

class ServiceItem {
  final String title;
  final String subtitle;
  final String price;
  final String time;
  final String category;
  final String imageUrl;

  ServiceItem({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.time,
    required this.category,
    required this.imageUrl,
  });
}

class ServicesController extends GetxController {
  final selectedCategory = 'Semua'.obs;

  final List<ServiceItem> allServices = [
    ServiceItem(
      title: 'Cuci & Lipat Reguler',
      subtitle: 'Cuci bersih, wangi, dan dilipat rapi. Selesai dalam 2-3 hari kerja.',
      price: 'Rp 8.000/kg',
      time: '48 Jam',
      category: 'Reguler',
      imageUrl: 'https://images.unsplash.com/photo-1517677208171-0bc6725a3e60?ixlib=rb-1.2.1&auto=format&fit=crop&w=200&q=80',
    ),
    ServiceItem(
      title: 'Cuci & Setrika',
      subtitle: 'Layanan lengkap cuci, kering, dan setrika uap. Pakaian siap langsung pakai.',
      price: 'Rp 12.500/kg',
      time: '48 - 72 Jam',
      category: 'Reguler',
      imageUrl: 'https://images.unsplash.com/photo-1545173168-9f1947eebb7f?ixlib=rb-1.2.1&auto=format&fit=crop&w=200&q=80',
    ),
    ServiceItem(
      title: 'Kilat 6 Jam',
      subtitle: 'Butuh cepat? Kami selesaikan cucianmu hanya dalam hitungan jam.',
      price: 'Rp 25.000/kg',
      time: '6 Jam Selesai',
      category: 'Ekspres',
      imageUrl: 'https://images.unsplash.com/photo-1600185365483-26d7a4cc7519?ixlib=rb-1.2.1&auto=format&fit=crop&w=200&q=80', // placeholder
    ),
    ServiceItem(
      title: 'Dry Cleaning Premium',
      subtitle: 'Perawatan khusus untuk jas, kebaya, atau kain sutra. Tanpa merusak serat kain.',
      price: 'Mulai Rp 35k',
      time: 'Perawatan Ahli',
      category: 'Premium',
      imageUrl: 'https://images.unsplash.com/photo-1545173168-9f1947eebb7f?ixlib=rb-1.2.1&auto=format&fit=crop&w=200&q=80', // placeholder
    ),
  ];

  List<ServiceItem> get filteredServices {
    if (selectedCategory.value == 'Semua') {
      return allServices;
    }
    return allServices.where((s) => s.category == selectedCategory.value).toList();
  }

  void setCategory(String category) {
    selectedCategory.value = category;
  }
}
