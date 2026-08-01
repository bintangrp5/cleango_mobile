import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../routes/app_pages.dart';
import '../../../data/services/auth_service.dart';

class OnboardingController extends GetxController {
  final pageController = PageController();
  final currentIndex = 0.obs;

  final pages = [
    {
      'image': 'assets/images/onboarding1.png',
      'title': 'Laundry Mudah & Cepat',
      'description': 'Layanan antar-jemput pakaian langsung ke depan pintu Anda.',
    },
    {
      'image': 'assets/images/onboarding2.png',
      'title': 'Hasil Bersih & Wangi',
      'description': 'Perawatan terbaik dengan standar kualitas premium untuk setiap helai pakaian.',
    },
  ];

  void onPageChanged(int index) {
    currentIndex.value = index;
  }

  void nextPage() async {
    if (currentIndex.value == pages.length - 1) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('has_seen_onboarding', true);
      
      final authService = Get.find<AuthService>();
      if (authService.isLoggedIn) {
        if (authService.isAdmin) {
          Get.offAllNamed(Routes.ADMIN_DASHBOARD);
        } else {
          Get.offAllNamed(Routes.HOME);
        }
      } else {
        Get.offAllNamed(Routes.LOGIN);
      }
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
