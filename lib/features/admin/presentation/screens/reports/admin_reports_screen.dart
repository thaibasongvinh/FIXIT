import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:fixit/features/admin/presentation/providers/admin_provider.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../data/appwrite_admin_repository.dart';

class AdminReportsScreen extends ConsumerWidget {
  const AdminReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(adminDashboardStatsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF1A1C1E);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF010A1A) : const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text('BUSINESS REPORTS', style: TextStyle(color: textColor, fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 2)),
        leading: IconButton(icon: Icon(Icons.arrow_back_ios_new, color: textColor, size: 18), onPressed: () => Navigator.pop(context)),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download_outlined, color: Colors.blueAccent),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Generating Excel report... PDF will be ready in a moment.')));
            },
          )
        ],
      ),
      body: Stack(
        children: [
          if (isDark)
            Container(decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF0D47A1), Color(0xFF010A1A), Colors.black], begin: Alignment.topLeft, end: Alignment.bottomRight))),
          SafeArea(
            child: statsAsync.when(
              data: (stats) => SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSummaryCard(stats, isDark, textColor),
                    const Gap(32),
                    _buildSectionTitle('REVENUE DISTRIBUTION', textColor),
                    const Gap(16),
                    _buildChartCard(stats, isDark, textColor),
                    const Gap(32),
                    _buildSectionTitle('TOP PERFORMING SERVICES', textColor),
                    const Gap(16),
                    ...stats.jobDistribution.entries.map((e) => _buildServiceStatRow(e.key, e.value, isDark, textColor)),
                  ],
                ),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(AdminStats stats, bool isDark, Color textColor) {
    final currencyFormat = NumberFormat.simpleCurrency(locale: 'vi_VN');
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.blueAccent.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          const Text('TOTAL NET REVENUE', style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 1.5)),
          const Gap(8),
          Text(currencyFormat.format(stats.revenue), style: TextStyle(color: textColor, fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: -1)),
          const Gap(24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('TOTAL JOBS', stats.activeJobs.toString(), textColor),
              _buildStatItem('COMMISSION', currencyFormat.format(stats.revenue * 0.15), Colors.greenAccent),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color valueColor) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: valueColor.withValues(alpha: 0.5), fontSize: 9, fontWeight: FontWeight.w900)),
        Text(value, style: TextStyle(color: valueColor, fontSize: 16, fontWeight: FontWeight.w800)),
      ],
    );
  }

  Widget _buildChartCard(AdminStats stats, bool isDark, Color textColor) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(24),
      ),
      child: PieChart(
        PieChartData(
          sections: stats.jobDistribution.entries.map((e) {
            final index = stats.jobDistribution.keys.toList().indexOf(e.key);
            final colors = [Colors.blueAccent, Colors.orangeAccent, Colors.greenAccent, Colors.purpleAccent, Colors.redAccent];
            return PieChartSectionData(
              color: colors[index % colors.length],
              value: e.value.toDouble(),
              title: '${e.value}',
              radius: 50,
              titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
            );
          }).toList(),
          sectionsSpace: 4,
          centerSpaceRadius: 40,
        ),
      ),
    );
  }

  Widget _buildServiceStatRow(String name, int count, bool isDark, Color textColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.star_rounded, color: Colors.orangeAccent, size: 18),
          const Gap(12),
          Text(name, style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
          const Spacer(),
          Text('$count bookings', style: TextStyle(color: textColor.withValues(alpha: 0.4), fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color textColor) {
    return Text(title, style: TextStyle(color: textColor.withValues(alpha: 0.3), fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2));
  }
}
