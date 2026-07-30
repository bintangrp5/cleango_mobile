import 'package:dio/dio.dart';

class ApiProvider {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://10.0.2.2:8000/api/v1', // Ganti saat production
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  static Dio get client => _dio;
}
