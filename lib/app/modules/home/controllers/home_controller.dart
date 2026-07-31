import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/models/service_model.dart';

class HomeController extends GetxController {
  final AuthService authService = Get.find<AuthService>();
  final GetConnect _connect = GetConnect();

  final RxList<ServiceModel> services = <ServiceModel>[].obs;
  final RxBool isLoadingServices = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchServices();
  }

  Future<void> fetchServices() async {
    isLoadingServices.value = true;
    try {
      final baseUrl = dotenv.env['BACKEND_API_URL'] ?? 'http://10.0.2.2:8000/api/v1';
      final response = await _connect.get('$baseUrl/services');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.body;
        services.value = data.map((json) => ServiceModel.fromJson(json)).toList();
      } else {
        Get.snackbar('Error', 'Gagal memuat layanan: ${response.statusText}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan jaringan');
    } finally {
      isLoadingServices.value = false;
    }
  }


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
