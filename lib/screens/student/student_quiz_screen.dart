import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models.dart';
import '../../storage_service.dart';
import '../../common_widgets.dart';

class StudentQuizScreen extends StatefulWidget {
  final UserData user;
  final String moduleId;
  final QuestionKind kind;
  final List<Question> questions;

  const StudentQuizScreen({
    super.key,
    required this.user,
    required this.moduleId,
    required this.kind,
    required this.questions,
  });

  @override
  State<StudentQuizScreen> createState() => _StudentQuizScreenState();
}

class _StudentQuizScreenState extends State<StudentQuizScreen> {
  int _index = 0;
  final Map<int, int> _answers = {};

  @override
  Widget build(BuildContext context) {
    final q = widget.questions[_index];
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: Text(
          widget.kind == QuestionKind.exam ? 'Ujian' : 'Latihan Soal',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Soal ${_index + 1} dari ${widget.questions.length}',
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              q.text,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: kTextColor,
              ),
            ),
            const SizedBox(height: 16),
            ...List.generate(q.options.length, (i) {
              final selected = _answers[_index] == i;
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _answers[_index] = i;
                    });
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Ink(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: selected
                          ? kPrimaryColor.withOpacity(0.08)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selected
                            ? kPrimaryColor
                            : const Color(0xFFE0E0E0),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          selected
                              ? Icons.radio_button_checked
                              : Icons.radio_button_off,
                          color: selected ? kPrimaryColor : Colors.grey,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            q.options[i],
                            style: GoogleFonts.poppins(fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
            const Spacer(),
            Row(
              children: [
                if (_index > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _index--;
                        });
                      },
                      child: const Text('Sebelumnya'),
                    ),
                  ),
                if (_index > 0) const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: primaryButtonStyle(),
                    onPressed: _onNext,
                    child: Text(
                      _index == widget.questions.length - 1
                          ? 'Selesai'
                          : 'Berikutnya',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onNext() async {
    if (_answers[_index] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih jawaban terlebih dahulu')),
      );
      return;
    }
    if (_index < widget.questions.length - 1) {
      setState(() {
        _index++;
      });
    } else {
      int correct = 0;
      for (var i = 0; i < widget.questions.length; i++) {
        final q = widget.questions[i];
        if (_answers[i] == q.correctIndex) correct++;
      }
      final score =
          ((correct / widget.questions.length) * 100).round();

      final item = QuizHistoryItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: widget.user.id,
        moduleId: widget.moduleId,
        dateTime: DateTime.now(),
        score: score,
        correctCount: correct,
        totalCount: widget.questions.length,
        kind: widget.kind,
      );
      await StorageService.addHistory(item);
      await StorageService.addNotification(
          'Siswa ${widget.user.name} menyelesaikan '
          '${widget.kind == QuestionKind.exam ? 'ujian' : 'latihan'} '
          'dengan nilai $score.');

      if (!mounted) return;
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Hasil'),
          content: Text(
            'Jawaban benar: $correct dari ${widget.questions.length}\n'
            'Nilai: $score',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      if (!mounted) return;
      Navigator.pop(context);
    }
  }
}
