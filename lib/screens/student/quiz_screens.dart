import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/models.dart';
import '../../services/storage_service.dart';
import '../../widgets/common_widgets.dart';

class BankSoalScreen extends StatelessWidget {
  final UserData user;
  const BankSoalScreen({super.key, required this.user});

  Future<Map<String, int>> _loadScores() async {
    final history = await StorageService.loadHistory();
    final filtered =
        history.where((h) => h.userId == user.id && h.type == 'bank');
    final map = <String, int>{};
    for (final h in filtered) {
      map[h.moduleId] = (map[h.moduleId] ?? 0).clamp(0, 100);
      if (h.score > (map[h.moduleId] ?? 0)) {
        map[h.moduleId] = h.score;
      }
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Bank Soal',
            style: GoogleFonts.poppins(
                color: Colors.white, fontWeight: FontWeight.w600)),
      ),
      body: Column(
        children: [
          Container(
            color: kPrimaryColor,
            padding: const EdgeInsets.all(12),
            child: Container(
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  const Icon(Icons.search, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text('Cari Soal',
                      style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey)),
                ],
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<Map<String, int>>(
              future: _loadScores(),
              builder: (context, snap) {
                final scores = snap.data ?? {};
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: kModules.length,
                  itemBuilder: (context, index) {
                    final m = kModules[index];
                    final score = scores[m.id] ?? 0;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: InkWell(
                        onTap: () {
                          final qs =
                              kBankQuestions.where((q) => q.moduleId == m.id).toList();
                          Navigator.of(context).push(
                            slideRoute(BankQuizScreen(
                              user: user,
                              module: m,
                              questions: qs,
                            )),
                          );
                        },
                        child: Container(
                          height: 96,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.description_rounded,
                                  color: Colors.white, size: 40),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  'Soal ${m.title}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Nilai',
                                      style: GoogleFonts.poppins(
                                          fontSize: 12, color: Colors.white)),
                                  const SizedBox(height: 4),
                                  Text(
                                    '$score',
                                    style: GoogleFonts.poppins(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class BankQuizScreen extends StatefulWidget {
  final UserData user;
  final ModuleData module;
  final List<Question> questions;
  const BankQuizScreen({
    super.key,
    required this.user,
    required this.module,
    required this.questions,
  });

  @override
  State<BankQuizScreen> createState() => _BankQuizScreenState();
}

class _BankQuizScreenState extends State<BankQuizScreen> {
  int _index = 0;
  int _correct = 0;
  int? _selected;

  void _select(int i) {
    setState(() {
      _selected = i;
    });
  }

  Future<void> _next() async {
    if (_selected == null) return;
    final q = widget.questions[_index];
    if (_selected == q.correctIndex) _correct++;
    if (_index == widget.questions.length - 1) {
      final score = ((_correct / widget.questions.length) * 100).round();
      await StorageService.addHistory(QuizHistoryItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: widget.user.id,
        moduleId: widget.module.id,
        type: 'bank',
        score: score,
        dateTime: DateTime.now(),
      ));
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        slideRoute(BankResultScreen(
          module: widget.module,
          questions: widget.questions,
          score: score,
        )),
      );
    } else {
      setState(() {
        _index++;
        _selected = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = widget.questions[_index];
    final progress = (_index + 1) / widget.questions.length;
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Soal ${widget.module.title}',
            style: GoogleFonts.poppins(color: kTextColor)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: kPrimaryColor,
                  child: Icon(Icons.description_rounded, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Soal ${widget.module.title}',
                        style:
                            GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                    Text('Sub Soal Modul 1',
                        style: GoogleFonts.poppins(
                            fontSize: 12, color: Colors.grey[700])),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: const Color(0xFFE0E0E0),
                    color: kPrimaryColor,
                    minHeight: 6,
                  ),
                ),
                const SizedBox(width: 8),
                Text('${(progress * 100).round()}%',
                    style: GoogleFonts.poppins(fontSize: 12)),
              ],
            ),
            const SizedBox(height: 8),
            Text('Soal ${_index + 1} dari ${widget.questions.length}',
                style: GoogleFonts.poppins(fontSize: 12)),
            const SizedBox(height: 16),
            Text(q.text,
                style:
                    GoogleFonts.poppins(fontSize: 14, color: kTextColor)),
            const SizedBox(height: 16),
            ...List.generate(q.options.length, (i) {
              final isSelected = _selected == i;
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: InkWell(
                  onTap: () => _select(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? kPrimaryColor : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFE0E0E0)),
                    ),
                    child: Text(
                      q.options[i],
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: isSelected ? Colors.white : kTextColor,
                      ),
                    ),
                  ),
                ),
              );
            }),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                style: primaryButtonStyle(),
                onPressed: _next,
                child: Text('Lanjut',
                    style:
                        GoogleFonts.poppins(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BankResultScreen extends StatelessWidget {
  final ModuleData module;
  final List<Question> questions;
  final int score;
  const BankResultScreen({
    super.key,
    required this.module,
    required this.questions,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Pembahasan Jawaban',
            style: GoogleFonts.poppins(color: kTextColor)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: kPrimaryColor,
                  child: Icon(Icons.description_rounded, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Soal ${module.title}',
                        style:
                            GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                    Text('Sub Soal Modul 1',
                        style: GoogleFonts.poppins(
                            fontSize: 12, color: Colors.grey[700])),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: 1,
                    backgroundColor: const Color(0xFFE0E0E0),
                    color: kPrimaryColor,
                    minHeight: 6,
                  ),
                ),
                const SizedBox(width: 8),
                Text('100%', style: GoogleFonts.poppins(fontSize: 12)),
              ],
            ),
            const SizedBox(height: 8),
            Text('Pembahasan Jawaban',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  final q = questions[index];
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
                        Text(q.text,
                            style: GoogleFonts.poppins(fontSize: 14)),
                        const SizedBox(height: 8),
                        Text('Jawaban benar',
                            style: GoogleFonts.poppins(
                                fontSize: 12, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF43A047),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            q.options[q.correctIndex],
                            style: GoogleFonts.poppins(
                                color: Colors.white, fontSize: 13),
                          ),
                        ),
                        if (q.explanation.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text('Penjelasan',
                              style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          Text(q.explanation,
                              style: GoogleFonts.poppins(fontSize: 12)),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nilai Kamu',
                      style: GoogleFonts.poppins(
                          color: Colors.white, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(
                    '$score',
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Hebat! Kamu bisa mencoba kembali untuk hasil yang lebih memuaskan.',
                    style: GoogleFonts.poppins(
                        color: Colors.white, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 36,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Coba lagi',
                        style: GoogleFonts.poppins(
                            color: kPrimaryColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UjiMandiriScreen extends StatelessWidget {
  final UserData user;
  const UjiMandiriScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Uji Mandiri',
            style: GoogleFonts.poppins(
                color: Colors.white, fontWeight: FontWeight.w600)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: kModules.length,
        itemBuilder: (context, index) {
          final m = kModules[index];
          final qs = kUjiQuestions.where((q) => q.moduleId == m.id).toList();
          if (qs.isEmpty) return const SizedBox.shrink();
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  slideRoute(UjiQuizScreen(
                    user: user,
                    module: m,
                    questions: qs,
                  )),
                );
              },
              child: Container(
                height: 96,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.quiz_rounded,
                        color: Colors.white, size: 40),
                    const SizedBox(width: 16),
                    Text(
                      'Uji ${m.title}',
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class UjiQuizScreen extends StatefulWidget {
  final UserData user;
  final ModuleData module;
  final List<Question> questions;
  const UjiQuizScreen({
    super.key,
    required this.user,
    required this.module,
    required this.questions,
  });

  @override
  State<UjiQuizScreen> createState() => _UjiQuizScreenState();
}

class _UjiQuizScreenState extends State<UjiQuizScreen> {
  int _index = 0;
  int _correct = 0;
  int? _selected;

  void _select(int i) {
    setState(() {
      _selected = i;
    });
  }

  Future<void> _next() async {
    if (_selected == null) return;
    final q = widget.questions[_index];
    if (_selected == q.correctIndex) _correct++;
    if (_index == widget.questions.length - 1) {
      final score = ((_correct / widget.questions.length) * 100).round();
      await StorageService.addHistory(QuizHistoryItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: widget.user.id,
        moduleId: widget.module.id,
        type: 'uji',
        score: score,
        dateTime: DateTime.now(),
      ));
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        slideRoute(UjiResultScreen(module: widget.module, score: score)),
      );
    } else {
      setState(() {
        _index++;
        _selected = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = widget.questions[_index];
    final progress = (_index + 1) / widget.questions.length;
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Soal ${widget.module.title}',
            style: GoogleFonts.poppins(color: kTextColor)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: kPrimaryColor,
                  child: Icon(Icons.quiz_rounded, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Soal ${widget.module.title}',
                        style:
                            GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                    Text('Sub Soal Modul 1',
                        style: GoogleFonts.poppins(
                            fontSize: 12, color: Colors.grey[700])),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: const Color(0xFFE0E0E0),
                    color: kPrimaryColor,
                    minHeight: 6,
                  ),
                ),
                const SizedBox(width: 8),
                Text('${(progress * 100).round()}%',
                    style: GoogleFonts.poppins(fontSize: 12)),
              ],
            ),
            const SizedBox(height: 8),
            Text('Soal ${_index + 1} dari ${widget.questions.length}',
                style: GoogleFonts.poppins(fontSize: 12)),
            const SizedBox(height: 16),
            Text(q.text,
                style:
                    GoogleFonts.poppins(fontSize: 14, color: kTextColor)),
            const SizedBox(height: 16),
            ...List.generate(q.options.length, (i) {
              final isSelected = _selected == i;
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: InkWell(
                  onTap: () => _select(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? kPrimaryColor : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFE0E0E0)),
                    ),
                    child: Text(
                      q.options[i],
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: isSelected ? Colors.white : kTextColor,
                      ),
                    ),
                  ),
                ),
              );
            }),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                style: primaryButtonStyle(),
                onPressed: _next,
                child: Text(
                  _index == widget.questions.length - 1 ? 'Selesai' : 'Lanjut',
                  style:
                      GoogleFonts.poppins(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UjiResultScreen extends StatelessWidget {
  final ModuleData module;
  final int score;
  const UjiResultScreen({super.key, required this.module, required this.score});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Nilai Uji Mandiri',
            style: GoogleFonts.poppins(color: kTextColor)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: kPrimaryColor,
                  child: Icon(Icons.quiz_rounded, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Soal ${module.title}',
                        style:
                            GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                    Text('Pembahasan Jawaban',
                        style: GoogleFonts.poppins(
                            fontSize: 12, color: Colors.grey[700])),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nilai Kamu',
                      style: GoogleFonts.poppins(
                          color: Colors.white, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(
                    '$score',
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Hebat! Kamu bisa mencoba kembali untuk hasil yang lebih memuaskan.',
                    style: GoogleFonts.poppins(
                        color: Colors.white, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 36,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Coba lagi',
                        style: GoogleFonts.poppins(
                            color: kPrimaryColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
