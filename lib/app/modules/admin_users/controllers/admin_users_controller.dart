import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/models/user_model.dart';
import '../../../utils/snackbar_util.dart';

class AdminUsersController extends GetxController {
  final isLoading = true.obs;
  final users = <UserModel>[].obs;
  late AuthService authService;

  @override
  void onInit() {
    super.onInit();
    authService = Get.find<AuthService>();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    isLoading.value = true;
    try {
      final response = await authService.dio.get('/profiles');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        users.value = data.map((json) => UserModel.fromJson(json)).toList();
      } else {
        AppSnackbar.show('Error', 'Gagal memuat pengguna');
      }
    } on DioException {
      AppSnackbar.show('Error', 'Kesalahan jaringan saat memuat pengguna');
    } finally {
      isLoading.value = false;
    }
  }

  List<UserModel> get admins => users.where((u) => u.role == 'admin').toList();
  List<UserModel> get customers => users.where((u) => u.role != 'admin').toList();
}
