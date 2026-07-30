import 'package:get/get.dart';
import '../../../data/services/auth_service.dart';

class HomeController extends GetxController {
  final AuthService authService = Get.find<AuthService>();

  String get userName {
    final name = authService.currentUser.value?.fullName;
    if (name != null && name.isNotEmpty) {
      return name.split(' ')[0]; // Ambil nama depan
    }
    return 'Guest';
  }

  void logout() {
    authService.logout();
  }
}
