import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models.dart';
import '../../storage_service.dart';
import '../../common_widgets.dart';

class StudentPerformanceScreen extends StatelessWidget {
  const StudentPerformanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Performa Nilai',
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
                'Belum ada data nilai.',
                style: GoogleFonts.poppins(color: Colors.grey[700]),
              ),
            );
          }
          items.sort((a, b) => a.dateTime.compareTo(b.dateTime));
          final spots = <FlSpot>[];
          for (var i = 0; i < items.length; i++) {
            spots.add(FlSpot(i.toDouble(), items[i].score.toDouble()));
          }
          return Padding(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Grafik nilai dari semua quiz yang pernah diikuti.',
                  style: GoogleFonts.poppins(fontSize: 13),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: LineChart(
                    LineChartData(
                      borderData: FlBorderData(show: false),
                      gridData: FlGridData(show: false),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: true),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      minY: 0,
                      maxY: 100,
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          barWidth: 3,
                          dotData: FlDotData(show: true),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
