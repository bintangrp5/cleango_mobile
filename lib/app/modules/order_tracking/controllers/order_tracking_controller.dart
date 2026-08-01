import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/models/order_model.dart';
import '../../../utils/snackbar_util.dart';

class OrderTrackingController extends GetxController {
  final authService = Get.find<AuthService>();
  final isLoading = true.obs;
  final order = Rx<OrderModel?>(null);
  
  final currentStep = 0.obs;
  final isAccordionExpanded = false.obs;

  void toggleAccordion() {
    isAccordionExpanded.value = !isAccordionExpanded.value;
  }

  @override
  void onInit() {
    super.onInit();
    fetchLatestOrder();
  }

  Future<void> fetchLatestOrder() async {
    isLoading.value = true;
    final user = authService.currentUser.value;

    if (user == null) {
      isLoading.value = false;
      return;
    }

    try {
      final response = await authService.dio.get('/orders/user/${user.id}');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        if (data.isNotEmpty) {
          // Data disortir DESC dari backend, jadi index 0 adalah yang terbaru
          order.value = OrderModel.fromJson(data.first); 
          _updateStepFromStatus(order.value!.status);
        }
      }
    } on DioException catch (e) {
      AppSnackbar.show('Error', 'Gagal memuat pesanan: ${e.message}');
    } catch (e) {
      AppSnackbar.show('Error', 'Kesalahan sistem: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _updateStepFromStatus(String status) {
    switch (status) {
      case 'Menunggu Penjemputan':
        currentStep.value = 0;
        break;
      case 'Dijemput':
        currentStep.value = 1;
        break;
      case 'Diproses':
        currentStep.value = 2;
        break;
      case 'Diantar':
        currentStep.value = 3;
        break;
      case 'Selesai':
        currentStep.value = 4;
        break;
      default:
        currentStep.value = 0;
    }
  }

  String get heroTitle {
    switch (currentStep.value) {
      case 0: return 'MENUNGGU KURIR';
      case 1: return 'DIJEMPUT';
      case 2: return 'DIPROSES';
      case 3: return 'DIANTAR';
      case 4: return 'SELESAI';
      default: return 'PESANAN DIPROSES';
    }
  }

  String get heroSubtitle {
    switch (currentStep.value) {
      case 0: return 'Kurir akan segera menjemput pakaianmu';
      case 1: return 'Kurir sedang dalam perjalanan mengambil pakaianmu';
      case 2: return 'Pakaian bersihmu sedang diproses';
      case 3: return 'Pakaianmu sedang dalam perjalanan kembali';
      case 4: return 'Pesanan telah selesai dan diterima';
      default: return 'Pakaian bersihmu sedang diproses';
    }
  }

}
