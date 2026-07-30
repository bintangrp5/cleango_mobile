import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';
import '../../routes/app_pages.dart';

class AuthService extends GetxService {
  final SupabaseClient supabase = Supabase.instance.client;
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);

  bool get isLoggedIn => currentUser.value != null;
  bool get isAdmin => currentUser.value?.role == 'admin';

  Future<AuthService> init() async {
    // Dengarkan perubahan state autentikasi dari Supabase (misal saat login/logout)
    supabase.auth.onAuthStateChange.listen((data) async {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;

      if (event == AuthChangeEvent.signedIn && session != null) {
        await _fetchUserProfile(session.user.id);
        _redirectUser();
      } else if (event == AuthChangeEvent.signedOut) {
        currentUser.value = null;
        Get.offAllNamed(Routes.LOGIN);
      }
    });

    // Cek session awal saat aplikasi pertama kali dibuka (Auto Login)
    final session = supabase.auth.currentSession;
    if (session != null) {
      await _fetchUserProfile(session.user.id);
      // Tunggu UI siap sebelum redirect
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _redirectUser();
      });
    }
    
    return this;
  }

  Future<void> _fetchUserProfile(String userId) async {
    try {
      final response = await supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();
      
      currentUser.value = UserModel.fromJson(response);
    } catch (e) {
      print('Error fetching user profile: $e');
    }
  }

  void _redirectUser() {
    // Redirect otomatis berdasarkan role (Admin atau Customer)
    if (isAdmin) {
      Get.offAllNamed(Routes.ADMIN_DASHBOARD);
    } else {
      Get.offAllNamed(Routes.HOME);
    }
  }

  Future<void> logout() async {
    await supabase.auth.signOut();
  }
}
