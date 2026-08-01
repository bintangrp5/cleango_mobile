import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/user_model.dart';
import '../../routes/app_pages.dart';

class AuthService extends GetxService {
  final Dio dio = Dio(BaseOptions(
    baseUrl: dotenv.env['BACKEND_API_URL'] ?? 'http://127.0.0.1:8000/api/v1',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));
  
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxString userAddress = ''.obs;
  final Rx<double?> userLat = Rx<double?>(null);
  final Rx<double?> userLng = Rx<double?>(null);

  bool get isLoggedIn => currentUser.value != null;
  bool get isAdmin => currentUser.value?.role == 'admin';

  String get userInitials {
    final name = currentUser.value?.fullName.trim() ?? '';
    if (name.isEmpty) return 'U';
    final words = name.split(RegExp(r'\s+'));
    if (words.length == 1) return words[0][0].toUpperCase();
    if (words.length == 2) return words[0][0].toUpperCase() + words[1][0].toUpperCase();
    return words[0][0].toUpperCase() + words[1][0].toUpperCase() + words[2][0].toUpperCase();
  }

  Future<AuthService> init() async {
    // Add interceptor to inject token
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await secureStorage.read(key: 'jwt_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));

    // Auto login check
    await _checkAutoLogin();
    
    // Load address and location
    userAddress.value = await secureStorage.read(key: 'user_address') ?? '';
    final latStr = await secureStorage.read(key: 'user_lat');
    final lngStr = await secureStorage.read(key: 'user_lng');
    if (latStr != null) userLat.value = double.tryParse(latStr);
    if (lngStr != null) userLng.value = double.tryParse(lngStr);
    
    return this;
  }

  Future<void> saveAddress(String address, {double? lat, double? lng}) async {
    userAddress.value = address;
    userLat.value = lat;
    userLng.value = lng;
    await secureStorage.write(key: 'user_address', value: address);
    if (lat != null) await secureStorage.write(key: 'user_lat', value: lat.toString());
    if (lng != null) await secureStorage.write(key: 'user_lng', value: lng.toString());
  }

  Future<void> _checkAutoLogin() async {
    final token = await secureStorage.read(key: 'jwt_token');
    if (token != null) {
      try {
        final response = await dio.get('/profiles/me');
        if (response.statusCode == 200) {
          currentUser.value = UserModel.fromJson(response.data);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _redirectUser();
          });
        } else {
          await logout();
        }
      } catch (e) {
        debugPrint('Auto login failed: $e');
        await logout();
      }
    }
  }

  void _redirectUser() {
    if (isAdmin) {
      Get.offAllNamed(Routes.ADMIN_DASHBOARD);
    } else {
      Get.offAllNamed(Routes.DASHBOARD);
    }
  }

  Future<void> saveTokenAndUser(String token, UserModel user) async {
    await secureStorage.write(key: 'jwt_token', value: token);
    currentUser.value = user;
    _redirectUser();
  }

  Future<void> logout() async {
    await secureStorage.delete(key: 'jwt_token');
    currentUser.value = null;
    Get.offAllNamed(Routes.LOGIN);
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    try {
      await dio.put('/auth/change-password', data: {
        'old_password': oldPassword,
        'new_password': newPassword,
      });
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Exception(e.response?.data['detail'] ?? 'Kata sandi lama salah');
      }
      throw Exception('Gagal mengubah kata sandi');
    }
  }
}
