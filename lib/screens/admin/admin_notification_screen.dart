import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/models.dart';
import '../../services/storage_service.dart';

class AdminNotificationScreen extends StatelessWidget {
  const AdminNotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AdminNotification>>(
      future: StorageService.loadNotifications(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Center(
              child: CircularProgressIndicator(color: kPrimaryColor));
        }
        final list = snap.data!.reversed.toList();
        if (list.isEmpty) {
          return Center(
            child: Text('Belum ada notifikasi.',
                style: GoogleFonts.poppins()),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(kDefaultPadding),
          itemCount: list.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final n = list[index];
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE0E0E0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(n.message,
                      style: GoogleFonts.poppins(fontSize: 13)),
                  const SizedBox(height: 4),
                  Text(
                    n.dateTime.toString().substring(0, 16),
                    style: GoogleFonts.poppins(
                        fontSize: 11, color: Colors.grey[700]),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
