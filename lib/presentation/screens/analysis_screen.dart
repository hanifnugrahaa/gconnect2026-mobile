import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/constants.dart';
import '../../providers/nodes_provider.dart';
import '../../providers/telemetry_provider.dart';

class AnalysisScreen extends ConsumerStatefulWidget {
  const AnalysisScreen({super.key});

  @override
  ConsumerState<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends ConsumerState<AnalysisScreen> {
  String _selectedCategory = 'all'; // 'all', 'npk', 'soil', 'environment'

  @override
  Widget build(BuildContext context) {
    final nodesState = ref.watch(nodesProvider);
    final telemetryState = ref.watch(telemetryProvider);
    final selectedNode = nodesState.selectedNode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analisis Telemetri', style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Period Filter Selector Pills
            Row(
              children: [
                _buildPeriodPill('1d', '24 Jam', telemetryState.selectedRange),
                const SizedBox(width: 8),
                _buildPeriodPill('1w', '7 Hari', telemetryState.selectedRange),
                const SizedBox(width: 8),
                _buildPeriodPill('1M', '30 Hari', telemetryState.selectedRange),
              ],
            ),
            const SizedBox(height: 16),

            // Category Filter Selector Pills
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCategoryPill('all', 'Semua Sensor'),
                  const SizedBox(width: 8),
                  _buildCategoryPill('npk', 'Unsur NPK'),
                  const SizedBox(width: 8),
                  _buildCategoryPill('soil', 'Kondisi Tanah'),
                  const SizedBox(width: 8),
                  _buildCategoryPill('environment', 'IoT & Lingkungan'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Time Series Chart Card (fl_chart)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tren Data Historis',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                      ),
                      Text(
                        '${telemetryState.historyFeeds.length} Titik Data',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    height: 220,
                    child: telemetryState.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : LineChart(
                            LineChartData(
                              gridData: FlGridData(
                                show: true,
                                drawVerticalLine: false,
                                horizontalInterval: 20,
                                getDrawingHorizontalLine: (val) => FlLine(
                                  color: AppColors.border,
                                  strokeWidth: 1,
                                  dashArray: [4, 4],
                                ),
                              ),
                              titlesData: const FlTitlesData(
                                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              ),
                              borderData: FlBorderData(show: false),
                              lineBarsData: [
                                // Sample Primary Trend Curve
                                LineChartBarData(
                                  spots: _generateChartSpots(telemetryState.historyFeeds),
                                  isCurved: true,
                                  color: AppColors.primary,
                                  barWidth: 3,
                                  isStrokeCapRound: true,
                                  dotData: const FlDotData(show: false),
                                  belowBarData: BarAreaData(
                                    show: true,
                                    color: AppColors.primary.withOpacity(0.12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Statistics Overview
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Ringkasan Statistik Periode', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildStatBox('Rata-rata', '24.9', AppColors.primary),
                      const SizedBox(width: 8),
                      _buildStatBox('Minimum', '21.0', AppColors.info),
                      const SizedBox(width: 8),
                      _buildStatBox('Maksimum', '28.5', AppColors.warning),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<FlSpot> _generateChartSpots(List<dynamic> feeds) {
    if (feeds.isEmpty) {
      return const [
        FlSpot(0, 22),
        FlSpot(1, 24),
        FlSpot(2, 23),
        FlSpot(3, 26),
        FlSpot(4, 25),
        FlSpot(5, 28),
      ];
    }
    return List.generate(feeds.length.clamp(0, 20), (i) {
      return FlSpot(i.toDouble(), 20.0 + (i % 5) * 2.0);
    });
  }

  Widget _buildPeriodPill(String id, String label, String activeId) {
    final isSelected = id == activeId;
    return InkWell(
      onTap: () {
        final node = ref.read(nodesProvider).selectedNode;
        if (node != null) {
          ref.read(telemetryProvider.notifier).fetchHistory(node.id, range: id);
        }
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
        ),
        child: Text(
          label,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: isSelected ? Colors.white : AppColors.textPrimary),
        ),
      ),
    );
  }

  Widget _buildCategoryPill(String id, String label) {
    final isSelected = _selectedCategory == id;
    return InkWell(
      onTap: () => setState(() => _selectedCategory = id),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.textPrimary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? AppColors.textPrimary : AppColors.border),
        ),
        child: Text(
          label,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: isSelected ? Colors.white : AppColors.textSecondary),
        ),
      ),
    );
  }

  Widget _buildStatBox(String title, String val, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Text(title, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: color)),
            const SizedBox(height: 4),
            Text(val, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
          ],
        ),
      ),
    );
  }
}
