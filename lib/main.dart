import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';

import 'app/routes/app_pages.dart';
import 'app/data/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize GetStorage
  await GetStorage.init();
  
  // Load environment variables (opsional, jika pakai .env)
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint("Warning: File .env tidak ditemukan, menggunakan nilai default.");
  }

  // Initialize GetX Services
  await initServices();

  runApp(const MyApp());
}

Future<void> initServices() async {
  debugPrint('Starting GetX Services...');
  await Get.putAsync(() => AuthService().init());
  debugPrint('All Services Started...');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "CleanGo Mobile",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}
