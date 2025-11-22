import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models.dart';
import '../../storage_service.dart';
import '../../common_widgets.dart';

class StudentHistoryScreen extends StatelessWidget {
  const StudentHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Riwayat Quiz',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<QuizHistoryItem>>(
        future: StorageService.loadHistory(),
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
                'Belum ada riwayat quiz.',
                style: GoogleFonts.poppins(color: Colors.grey[700]),
              ),
            );
          }
          items.sort((a, b) => b.dateTime.compareTo(a.dateTime));
          return ListView.builder(
            padding: const EdgeInsets.all(kDefaultPadding),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: kPrimaryColor.withOpacity(0.1),
                    child: Icon(
                      item.kind == QuestionKind.exam
                          ? Icons.assignment_turned_in_rounded
                          : Icons.quiz_rounded,
                      color: kPrimaryColor,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    '${item.kind == QuestionKind.exam ? 'Ujian' : 'Latihan'} - Nilai ${item.score}',
                    style: GoogleFonts.poppins(fontSize: 13),
                  ),
                  subtitle: Text(
                    '${item.correctCount}/${item.totalCount} benar • ${item.dateTime.toLocal()}',
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
