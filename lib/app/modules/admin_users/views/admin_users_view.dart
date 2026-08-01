import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/admin_users_controller.dart';
import '../../../data/models/user_model.dart';
import '../../../widgets/admin_drawer.dart';

class AdminUsersView extends GetView<AdminUsersController> {
  const AdminUsersView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AdminUsersController());
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      drawer: const AdminDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.black12,
        iconTheme: const IconThemeData(color: Color(0xFF0058BC)),
        title: const Text(
          'Data Pengguna',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0058BC),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.users.isEmpty) {
          return const Center(child: Text('Belum ada pengguna.'));
        }

        return DefaultTabController(
          length: 2,
          child: Column(
            children: [
              Container(
                color: Colors.white,
                child: const TabBar(
                  labelColor: Color(0xFF0058BC),
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Color(0xFF0058BC),
                  tabs: [
                    Tab(text: 'Pelanggan'),
                    Tab(text: 'Admin'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildUserList(controller.customers),
                    _buildUserList(controller.admins),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildUserList(List<UserModel> users) {
    if (users.isEmpty) {
      return const Center(child: Text('Tidak ada data.', style: TextStyle(color: Colors.grey)));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFFE5EEFF),
                child: Text(
                  user.fullName.isNotEmpty ? user.fullName[0].toUpperCase() : '?',
                  style: const TextStyle(color: Color(0xFF0058BC), fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.fullName,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0B1C30)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.email,
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: user.role == 'admin' ? Colors.red.withValues(alpha: 0.1) : const Color(0xFF0058BC).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  user.role.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: user.role == 'admin' ? Colors.red : const Color(0xFF0058BC),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
