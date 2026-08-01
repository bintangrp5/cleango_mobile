import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../routes/app_pages.dart';
import '../../../data/services/auth_service.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _checkInitialState();
  }

  Future<void> _checkInitialState() async {
    // Wait for 2 seconds to show splash
    await Future.delayed(const Duration(seconds: 2));

    final prefs = await SharedPreferences.getInstance();
    final bool hasSeenOnboarding = prefs.getBool('has_seen_onboarding') ?? false;

    if (!hasSeenOnboarding) {
      Get.offAllNamed(Routes.ONBOARDING);
    } else {
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
    }
  }
}
