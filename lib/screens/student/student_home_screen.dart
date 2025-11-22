import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/models.dart';
import '../../widgets/common_widgets.dart';
import '../../services/storage_service.dart';
import 'module_screens.dart';
import 'quiz_screens.dart';
import 'key_answer_screen.dart';
import 'history_screen.dart';
import 'notification_screen.dart';
import '../student/performance_screen.dart';
import '../shared/profile_screen.dart';

class StudentHomeScreen extends StatefulWidget {
  final UserData user;
  final VoidCallback onLogout;
  const StudentHomeScreen(
      {super.key, required this.user, required this.onLogout});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildHome(),
      HistoryScreen(user: widget.user),
      StudentNotificationScreen(user: widget.user),
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
          border: Border(
            top: BorderSide(color: Color(0xFFE0E0E0)),
          ),
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
                icon: Icon(Icons.home_rounded), label: 'Beranda'),
            BottomNavigationBarItem(
                icon: Icon(Icons.history_rounded), label: 'Riwayat'),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications_rounded), label: 'Notifikasi'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_rounded), label: 'Profil'),
          ],
        ),
      ),
    );
  }

  Widget _buildHome() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE0E0E0)),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 22,
                  backgroundColor: kPrimaryColor,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Halo, ${widget.user.name.split(' ').first}!',
                          style: GoogleFonts.poppins(
                              fontSize: 14, fontWeight: FontWeight.w600)),
                      Text('Kelas ${widget.user.kelas} ${widget.user.rombel}',
                          style: GoogleFonts.poppins(
                              fontSize: 12, color: Colors.grey[700])),
                      const SizedBox(height: 4),
                      Text(
                        'Rekomendasi belajar: Mulai dari Bilangan Bulat hari ini.',
                        style: GoogleFonts.poppins(
                            fontSize: 11, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('Dashboard',
              style: GoogleFonts.poppins(
                  fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _dashboardItem(
                icon: Icons.menu_book_rounded,
                label: 'Modul',
                onTap: () {
                  Navigator.of(context).push(
                    slideRoute(const ModuleListScreen()),
                  );
                },
              ),
              _dashboardItem(
                icon: Icons.description_rounded,
                label: 'Bank Soal',
                onTap: () {
                  Navigator.of(context).push(
                    slideRoute(BankSoalScreen(user: widget.user)),
                  );
                },
              ),
              _dashboardItem(
                icon: Icons.quiz_rounded,
                label: 'Uji Mandiri',
                onTap: () {
                  Navigator.of(context).push(
                    slideRoute(UjiMandiriScreen(user: widget.user)),
                  );
                },
              ),
              _dashboardItem(
                icon: Icons.key_rounded,
                label: 'Kunci Jawaban',
                onTap: () {
                  Navigator.of(context).push(
                    slideRoute(const KunciJawabanScreen()),
                  );
                },
              ),
              _dashboardItem(
                icon: Icons.show_chart_rounded,
                label: 'Performa Siswa',
                onTap: () {
                  Navigator.of(context).push(
                    slideRoute(PerformanceScreen(user: widget.user)),
                  );
                },
              ),
              _dashboardItem(
                icon: Icons.settings_rounded,
                label: 'Pengaturan',
                onTap: () async {
                  await StorageService.setCurrentUser(null);
                  widget.onLogout();
                  if (!mounted) return;
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _dashboardItem(
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          AnimatedScale(
            scale: 1,
            duration: const Duration(milliseconds: 200),
            child: Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: kPrimaryColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white),
            ),
          ),
          const SizedBox(height: 6),
          Text(label,
              style: GoogleFonts.poppins(fontSize: 12),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
