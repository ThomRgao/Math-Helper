import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../models/models.dart';
import '../../services/storage_service.dart';

class PerformanceScreen extends StatelessWidget {
  final UserData user;
  const PerformanceScreen({super.key, required this.user});

  Future<Map<String, List<QuizHistoryItem>>> _load() async {
    final all = await StorageService.loadHistory();
    final userHistory = all.where((h) => h.userId == user.id).toList();
    final map = <String, List<QuizHistoryItem>>{};
    for (final h in userHistory) {
      map.putIfAbsent(h.moduleId, () => []).add(h);
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, List<QuizHistoryItem>>>(
      future: _load(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Center(
              child: CircularProgressIndicator(color: kPrimaryColor));
        }
        final data = snap.data!;
        if (data.isEmpty) {
          return Center(
            child: Text('Belum ada data performa.',
                style: GoogleFonts.poppins()),
          );
        }

        final spots = <FlSpot>[];
        final labels = <String>[];
        int index = 0;
        data.forEach((moduleId, list) {
          list.sort((a, b) => a.dateTime.compareTo(b.dateTime));
          final best = list.last.score.toDouble();
          spots.add(FlSpot(index.toDouble(), best));
          final module =
              kModules.firstWhere((m) => m.id == moduleId, orElse: () => kModules[0]);
          labels.add(module.title.split(' ').first);
          index++;
        });

        return Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Performa Belajar',
                  style: GoogleFonts.poppins(
                      fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Text(
                'Grafik berikut menunjukkan nilai terbaikmu pada setiap modul.',
                style: GoogleFonts.poppins(fontSize: 12),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 220,
                child: LineChart(
                  LineChartData(
                    minY: 0,
                    maxY: 100,
                    gridData: FlGridData(show: true),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 28,
                          interval: 20,
                          getTitlesWidget: (value, meta) => Text(
                            value.toInt().toString(),
                            style: GoogleFonts.poppins(fontSize: 10),
                          ),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final i = value.toInt();
                            if (i < 0 || i >= labels.length) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                labels[i],
                                style:
                                    GoogleFonts.poppins(fontSize: 10),
                              ),
                            );
                          },
                        ),
                      ),
                      topTitles:
                          const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles:
                          const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        isCurved: true,
                        barWidth: 3,
                        color: kPrimaryColor,
                        dotData: FlDotData(show: true),
                        spots: spots,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final moduleId = data.keys.elementAt(index);
                    final module =
                        kModules.firstWhere((m) => m.id == moduleId);
                    final list = data[moduleId]!;
                    list.sort((a, b) => b.dateTime.compareTo(a.dateTime));
                    final last = list.first;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE0E0E0)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(module.title,
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600)),
                              const SizedBox(height: 4),
                              Text(
                                'Percobaan terakhir: ${last.dateTime.toString().substring(0, 16)}',
                                style: GoogleFonts.poppins(
                                    fontSize: 11, color: Colors.grey[700]),
                              ),
                            ],
                          ),
                          Text(
                            '${last.score}',
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: kPrimaryColor,
                            ),
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
  }
}
