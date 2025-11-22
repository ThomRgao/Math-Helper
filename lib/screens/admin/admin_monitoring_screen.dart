import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/models.dart';
import '../../services/storage_service.dart';

class AdminMonitoringScreen extends StatefulWidget {
  const AdminMonitoringScreen({super.key});

  @override
  State<AdminMonitoringScreen> createState() => _AdminMonitoringScreenState();
}

class _AdminMonitoringScreenState extends State<AdminMonitoringScreen> {
  String _kelas = 'Semua';
  String _rombel = 'Semua';
  String _query = '';

  Future<List<UserData>> _loadUsers() async {
    final users = await StorageService.loadUsers();
    return users.where((u) => u.role == UserRole.student).toList();
  }

  Future<Map<String, List<QuizHistoryItem>>> _loadHistory() async {
    final history = await StorageService.loadHistory();
    final map = <String, List<QuizHistoryItem>>{};
    for (final h in history) {
      map.putIfAbsent(h.userId, () => []).add(h);
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<UserData>>(
      future: _loadUsers(),
      builder: (context, userSnap) {
        if (!userSnap.hasData) {
          return const Center(
              child: CircularProgressIndicator(color: kPrimaryColor));
        }
        return FutureBuilder<Map<String, List<QuizHistoryItem>>>(
          future: _loadHistory(),
          builder: (context, histSnap) {
            if (!histSnap.hasData) {
              return const Center(
                  child: CircularProgressIndicator(color: kPrimaryColor));
            }
            final users = userSnap.data!;
            final history = histSnap.data!;
            var filtered = users;
            if (_kelas != 'Semua') {
              filtered =
                  filtered.where((u) => u.kelas == _kelas).toList();
            }
            if (_rombel != 'Semua') {
              filtered =
                  filtered.where((u) => u.rombel == _rombel).toList();
            }
            if (_query.isNotEmpty) {
              filtered = filtered
                  .where((u) =>
                      u.name.toLowerCase().contains(_query.toLowerCase()))
                  .toList();
            }

            return Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _kelas,
                          decoration: _filterDecoration(),
                          items: const [
                            DropdownMenuItem(
                                value: 'Semua', child: Text('Semua Kelas')),
                            DropdownMenuItem(value: 'VII', child: Text('VII')),
                            DropdownMenuItem(value: 'VIII', child: Text('VIII')),
                            DropdownMenuItem(value: 'IX', child: Text('IX')),
                          ],
                          onChanged: (v) {
                            setState(() {
                              _kelas = v ?? 'Semua';
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _rombel,
                          decoration: _filterDecoration(),
                          items: const [
                            DropdownMenuItem(
                                value: 'Semua', child: Text('Semua Rombel')),
                            DropdownMenuItem(value: 'A', child: Text('A')),
                            DropdownMenuItem(value: 'B', child: Text('B')),
                            DropdownMenuItem(value: 'C', child: Text('C')),
                          ],
                          onChanged: (v) {
                            setState(() {
                              _rombel = v ?? 'Semua';
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Cari nama siswa',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            const BorderSide(color: Color(0xFFE0E0E0)),
                      ),
                    ),
                    onChanged: (v) {
                      setState(() {
                        _query = v;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: filtered.isEmpty
                        ? Center(
                            child: Text('Belum ada siswa.',
                                style: GoogleFonts.poppins()),
                          )
                        : ListView.builder(
                            itemCount: filtered.length,
                            itemBuilder: (context, index) {
                              final u = filtered[index];
                              final userHistory = history[u.id] ?? [];
                              final avg = userHistory.isEmpty
                                  ? 0
                                  : userHistory
                                          .map((e) => e.score)
                                          .reduce((a, b) => a + b) /
                                      userHistory.length;
                              return Container(
                                margin:
                                    const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: const Color(0xFFE0E0E0)),
                                ),
                                child: Row(
                                  children: [
                                    const CircleAvatar(
                                      radius: 20,
                                      backgroundColor: kPrimaryColor,
                                      child: Icon(Icons.person,
                                          color: Colors.white),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(u.name,
                                              style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w600)),
                                          Text(
                                              'Kelas ${u.kelas} ${u.rombel} • ${u.email}',
                                              style: GoogleFonts.poppins(
                                                  fontSize: 11,
                                                  color: Colors.grey[700])),
                                          const SizedBox(height: 4),
                                          Text(
                                              'Rata-rata nilai: ${avg.toStringAsFixed(1)}',
                                              style: GoogleFonts.poppins(
                                                  fontSize: 11)),
                                        ],
                                      ),
                                    ),
                                    PopupMenuButton<String>(
                                      onSelected: (value) async {
                                        if (value == 'reset') {
                                          await StorageService
                                              .resetUserPassword(
                                                  u.id, '12345678');
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        'Password direset menjadi 12345678')));
                                          }
                                        }
                                      },
                                      itemBuilder: (context) => [
                                        const PopupMenuItem(
                                          value: 'reset',
                                          child: Text('Reset password'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  InputDecoration _filterDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }
}
