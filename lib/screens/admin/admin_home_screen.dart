import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/models.dart';
import '../shared/profile_screen.dart';
import 'admin_notification_screen.dart';
import 'admin_module_manager.dart';
import 'admin_monitoring_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  final UserData user;
  final VoidCallback onLogout;

  const AdminHomeScreen({
    super.key,
    required this.user,
    required this.onLogout,
  });

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildDashboard(),
      const AdminMonitoringScreen(),
      const AdminNotificationScreen(),
      ProfileScreen(user: widget.user),
    ];

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        leadingWidth: 160,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Image.asset('assets/logo.png', height: 32),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.menu_rounded, color: kPrimaryColor),
          ),
        ],
      ),
      body: pages[_tabIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFE0E0E0))),
        ),
        child: BottomNavigationBar(
          currentIndex: _tabIndex,
          onTap: (i) {
            setState(() {
              _tabIndex = i;
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: kPrimaryColor,
          unselectedItemColor: Colors.grey[500],
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.insights_rounded),
              label: 'Monitoring',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_rounded),
              label: 'Notifikasi',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Halo, ${widget.user.name}',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Dashboard Admin',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 24),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _cardItem(
                icon: Icons.menu_book_rounded,
                title: 'Kelola Modul',
                subtitle: 'Upload dan atur file untuk siswa.',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const AdminModuleManagerScreen(),
                    ),
                  );
                },
              ),
              _cardItem(
                icon: Icons.people_rounded,
                title: 'Monitoring Siswa',
                subtitle: 'Lihat nilai dan aktivitas siswa.',
                onTap: () {
                  setState(() {
                    _tabIndex = 1;
                  });
                },
              ),
              _cardItem(
                icon: Icons.notifications_active_rounded,
                title: 'Notifikasi',
                subtitle: 'Login baru dan aktivitas penting.',
                onTap: () {
                  setState(() {
                    _tabIndex = 2;
                  });
                },
              ),
              _cardItem(
                icon: Icons.settings_rounded,
                title: 'Pengaturan',
                subtitle: 'Pengaturan akun admin.',
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _cardItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.18),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white, size: 32),
            const Spacer(),
            Text(
              title,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
