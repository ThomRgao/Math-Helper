import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/models.dart';

class KunciJawabanScreen extends StatelessWidget {
  const KunciJawabanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final grouped = <String, List<Question>>{};
    for (final q in kBankQuestions) {
      grouped.putIfAbsent(q.moduleId, () => []).add(q);
    }
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Kunci Jawaban Bank Soal',
            style: GoogleFonts.poppins(color: kTextColor)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(kDefaultPadding),
        itemCount: grouped.length,
        itemBuilder: (context, index) {
          final moduleId = grouped.keys.elementAt(index);
          final module = kModules.firstWhere((m) => m.id == moduleId);
          final qs = grouped[moduleId]!;
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE0E0E0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Soal ${module.title}',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                ...List.generate(qs.length, (i) {
                  final q = qs[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${i + 1}. ',
                            style: GoogleFonts.poppins(fontSize: 13)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(q.text,
                                  style:
                                      GoogleFonts.poppins(fontSize: 13)),
                              const SizedBox(height: 4),
                              Text(
                                  'Jawaban: ${q.options[q.correctIndex]}',
                                  style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: kPrimaryColor)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}
