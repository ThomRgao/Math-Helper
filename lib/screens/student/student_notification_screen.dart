import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models.dart';
import '../../storage_service.dart';
import '../../common_widgets.dart';

class StudentNotificationScreen extends StatelessWidget {
  const StudentNotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Notifikasi',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<AdminNotification>>(
        future: StorageService.loadNotifications(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: kPrimaryColor),
            );
          }
          final items = snapshot.data!;
          if (items.isEmpty) {
            return Center(
              child: Text(
                'Belum ada notifikasi.',
                style: GoogleFonts.poppins(color: Colors.grey[700]),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(kDefaultPadding),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final n = items[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: kPrimaryColor.withOpacity(0.1),
                    child: const Icon(Icons.notifications_rounded,
                        color: kPrimaryColor),
                  ),
                  title: Text(
                    n.message,
                    style: GoogleFonts.poppins(fontSize: 13),
                  ),
                  subtitle: Text(
                    n.dateTime.toLocal().toString(),
                    style: GoogleFonts.poppins(
                        fontSize: 11, color: Colors.grey[700]),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
