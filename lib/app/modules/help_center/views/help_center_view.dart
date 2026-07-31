import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/help_center_controller.dart';

class HelpCenterView extends GetView<HelpCenterController> {
  const HelpCenterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      appBar: AppBar(
        title: const Text('Pusat Bantuan', style: TextStyle(color: Color(0xFF0B1C30), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF0B1C30)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'FAQ (Pertanyaan yang Sering Diajukan)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0B1C30),
              ),
            ),
            const SizedBox(height: 16),
            _buildFaqItem(
              'Bagaimana cara memesan layanan laundry?',
              'Anda dapat memesan layanan dengan memilih kategori layanan di beranda, lalu menekan tombol "Pesan Sekarang" atau menambahkannya ke keranjang. Setelah itu, selesaikan pembayaran.',
            ),
            _buildFaqItem(
              'Berapa lama waktu pengerjaan?',
              'Waktu pengerjaan bervariasi tergantung jenis layanan. Layanan reguler biasanya memakan waktu 2-3 hari, sedangkan layanan ekspres dapat selesai dalam 1 hari.',
            ),
            _buildFaqItem(
              'Apakah bisa mengubah alamat pengiriman?',
              'Ya, Anda dapat mengubah alamat pengiriman saat melakukan checkout atau melalui menu "Alamat Saya" di halaman Profil.',
            ),
            const SizedBox(height: 32),
            const Text(
              'Hubungi Kami',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0B1C30),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2)),
                ],
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.email, color: Color(0xFF0058BC)),
                    title: const Text('Email'),
                    subtitle: const Text('support@cleango.id'),
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 56),
                  ListTile(
                    leading: const Icon(Icons.phone, color: Color(0xFF0058BC)),
                    title: const Text('Telepon / WhatsApp'),
                    subtitle: const Text('+62 812-3456-7890'),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF0B1C30)),
        ),
        childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        iconColor: const Color(0xFF0058BC),
        collapsedIconColor: const Color(0xFF414755),
        children: [
          Text(
            answer,
            style: const TextStyle(color: Color(0xFF414755), fontSize: 14, height: 1.5),
          ),
        ],
      ),
    );
  }
}
