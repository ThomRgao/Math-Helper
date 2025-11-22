import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models.dart';
import '../../storage_service.dart';
import '../../common_widgets.dart';
import 'student_quiz_screen.dart';

class StudentModuleScreen extends StatefulWidget {
  final UserData user;
  final int initialTab; 

  const StudentModuleScreen({
    super.key,
    required this.user,
    this.initialTab = 0,
  });

  @override
  State<StudentModuleScreen> createState() => _StudentModuleScreenState();
}

class _StudentModuleScreenState extends State<StudentModuleScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.index = widget.initialTab;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Modul & Soal',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Modul'),
            Tab(text: 'Bank Soal'),
            Tab(text: 'Ujian'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildModuleList(),
          _buildQuestionList(QuestionKind.bank),
          _buildQuestionList(QuestionKind.exam),
        ],
      ),
    );
  }

  Widget _buildModuleList() {
    return FutureBuilder<List<ModuleData>>(
      future: StorageService.loadModules(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(color: kPrimaryColor),
          );
        }
        final modules = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.all(kDefaultPadding),
          itemCount: modules.length,
          itemBuilder: (context, index) {
            final m = modules[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                title: Text(
                  m.title,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  'Kelas ${m.kelas}\n${m.description}',
                  style:
                      GoogleFonts.poppins(fontSize: 11, color: Colors.grey[700]),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildQuestionList(QuestionKind kind) {
    return FutureBuilder<List<Question>>(
      future: StorageService.loadQuestions(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(color: kPrimaryColor),
          );
        }
        final qs = snapshot.data!
            .where((q) => q.kind == kind)
            .toList();
        if (qs.isEmpty) {
          return Center(
            child: Text(
              'Belum ada soal.',
              style: GoogleFonts.poppins(color: Colors.grey[700]),
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(kDefaultPadding),
          itemCount: qs.length,
          itemBuilder: (context, index) {
            final q = qs[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                title: Text(
                  q.text,
                  style: GoogleFonts.poppins(fontSize: 13),
                ),
                trailing: Icon(
                  Icons.play_circle_fill_rounded,
                  color: kPrimaryColor,
                ),
                onTap: () async {
                  final all = snapshot.data!
                      .where((e) => e.moduleId == q.moduleId && e.kind == kind)
                      .toList();
                  if (!mounted) return;
                  await Navigator.of(context).push(
                    slideRoute(StudentQuizScreen(
                      user: widget.user,
                      moduleId: q.moduleId,
                      kind: kind,
                      questions: all,
                    )),
                  );
                  setState(() {});
                },
              ),
            );
          },
        );
      },
    );
  }
}
