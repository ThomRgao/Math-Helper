import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/models.dart';
import '../../services/storage_service.dart';

class StudentNotificationScreen extends StatelessWidget {
  final UserData user;
  const StudentNotificationScreen({super.key, required this.user});

  Future<List<QuizHistoryItem>> _load() async {
    final all = await StorageService.loadHistory();
    return all.where((e) => e.userId == user.id).toList().reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<QuizHistoryItem>>(
      future: _load(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Center(child: CircularProgressIndicator(color: kPrimaryColor));
        }
        final list = snap.data!;
        if (list.isEmpty) {
          return Center(
            child: Text('Belum ada notifikasi.', style: GoogleFonts.poppins()),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(kDefaultPadding),
          itemCount: list.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final item = list[index];
            final module = kModules.firstWhere((m) => m.id == item.moduleId);
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE0E0E0)),
              ),
              child: Text(
                'Kamu menyelesaikan ${item.type == 'bank' ? 'Bank Soal' : 'Uji Mandiri'} ${module.title} dengan nilai ${item.score}.',
                style: GoogleFonts.poppins(fontSize: 13),
              ),
            );
          },
        );
      },
    );
  }
}
