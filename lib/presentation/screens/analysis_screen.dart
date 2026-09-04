import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/nodes_provider.dart';
import '../../providers/telemetry_provider.dart';
import '../../models/telemetry_feed_model.dart';
import '../widgets/liquid_glass_panel.dart';

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

    // Extract real values from telemetry feeds
    final valuesList = _extractValues(telemetryState.historyFeeds, _selectedCategory);
    final spots = _generateChartSpots(valuesList);

    // Compute dynamic statistics
    double avg = 0;
    double min = 0;
    double max = 0;
    if (valuesList.isNotEmpty) {
      min = valuesList.reduce((a, b) => a < b ? a : b);
      max = valuesList.reduce((a, b) => a > b ? a : b);
      avg = valuesList.reduce((a, b) => a + b) / valuesList.length;
    }

    return Scaffold(
      backgroundColor: const Color(0xFF040E0A),
      body: Stack(
        children: [
          // Background Wallpaper
          Positioned.fill(
            child: Image.asset(
              'assets/images/farm_bg.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x99000000),
                    Color(0x55051B12),
                    Color(0xF5040E0A),
                  ],
                  stops: [0.0, 0.35, 0.85],
                ),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Screen Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Analisis Telemetri',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: -0.3,
                            ),
                          ),
                          Text(
                            selectedNode != null ? selectedNode.name : 'Stasiun IoT',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: const Color(0xFFA7F3D0),
                            ),
                          ),
                        ],
                      ),
                      LiquidGlassPanel(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        borderRadius: 20,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(LucideIcons.activity, size: 13, color: Color(0xFF34D399)),
                            const SizedBox(width: 5),
                            Text(
                              '${telemetryState.historyFeeds.length} Titik Data',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF6EE7B7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

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
                  const SizedBox(height: 14),

                  // Category Filter Selector Pills
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
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
                  const SizedBox(height: 18),

                  // Time Series Chart Card (fl_chart in Liquid Glass)
                  LiquidGlassPanel(
                    padding: const EdgeInsets.all(16),
                    borderRadius: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Tren Data Historis',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981).withOpacity(0.18),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                _selectedCategory.toUpperCase(),
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF34D399),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        SizedBox(
                          height: 200,
                          child: telemetryState.isLoading
                              ? const Center(child: CircularProgressIndicator(color: Color(0xFF10B981)))
                              : spots.isEmpty
                                  ? Center(
                                      child: Text(
                                        'Belum ada data riwayat untuk periode ini',
                                        style: GoogleFonts.plusJakartaSans(
                                          color: Colors.white60,
                                          fontSize: 12,
                                        ),
                                      ),
                                    )
                                  : LineChart(
                                      LineChartData(
                                        gridData: FlGridData(
                                          show: true,
                                          drawVerticalLine: false,
                                          horizontalInterval: 20,
                                          getDrawingHorizontalLine: (val) => FlLine(
                                            color: Colors.white.withOpacity(0.08),
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
                                          LineChartBarData(
                                            spots: spots,
                                            isCurved: true,
                                            color: const Color(0xFF34D399),
                                            barWidth: 3,
                                            isStrokeCapRound: true,
                                            dotData: const FlDotData(show: false),
                                            belowBarData: BarAreaData(
                                              show: true,
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  const Color(0xFF10B981).withOpacity(0.35),
                                                  const Color(0xFF10B981).withOpacity(0.0),
                                                ],
                                              ),
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

                  // Dynamic Statistics Overview Box (Calculated from Real API Data)
                  LiquidGlassPanel(
                    padding: const EdgeInsets.all(16),
                    borderRadius: 22,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ringkasan Statistik Periode',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _buildStatBox('Rata-rata', avg > 0 ? avg.toStringAsFixed(1) : '--', const Color(0xFF34D399)),
                            const SizedBox(width: 8),
                            _buildStatBox('Minimum', min > 0 ? min.toStringAsFixed(1) : '--', const Color(0xFF38BDF8)),
                            const SizedBox(width: 8),
                            _buildStatBox('Maksimum', max > 0 ? max.toStringAsFixed(1) : '--', const Color(0xFFFBBF24)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<double> _extractValues(List<TelemetryFeedModel> feeds, String category) {
    final List<double> vals = [];
    for (final f in feeds) {
      double? v;
      if (category == 'npk') {
        v = f.getValue(null, 'field1', 'nitrogen') ?? f.getValue(null, 'field2', 'phosphorus');
      } else if (category == 'soil') {
        v = f.getValue(null, 'field6', 'moisture') ?? f.getValue(null, 'field4', 'ph');
      } else if (category == 'environment') {
        v = f.getValue(null, 'field7', 'temperature') ?? f.getValue(null, 'field8', 'humidity');
      } else {
        // Default to first valid field
        for (int i = 1; i <= 8; i++) {
          final candidate = f.getValue(null, 'field$i', null);
          if (candidate != null && candidate > 0) {
            v = candidate;
            break;
          }
        }
      }
      if (v != null) {
        vals.add(v);
      }
    }
    return vals;
  }

  List<FlSpot> _generateChartSpots(List<double> values) {
    if (values.isEmpty) return [];
    return List.generate(values.length, (i) {
      return FlSpot(i.toDouble(), values[i]);
    });
  }

  Widget _buildPeriodPill(String id, String label, String activeId) {
    final isSelected = id == activeId;
    return GestureDetector(
      onTap: () {
        final node = ref.read(nodesProvider).selectedNode;
        if (node != null) {
          ref.read(telemetryProvider.notifier).fetchHistory(node.id, range: id);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF10B981) : Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF34D399) : Colors.white.withOpacity(0.14),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            color: isSelected ? const Color(0xFF042F1E) : Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryPill(String id, String label) {
    final isSelected = _selectedCategory == id;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF10B981) : Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF34D399) : Colors.white.withOpacity(0.14),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            color: isSelected ? const Color(0xFF042F1E) : Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildStatBox(String title, String val, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.30), width: 0.8),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              val,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 17,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: -0.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
