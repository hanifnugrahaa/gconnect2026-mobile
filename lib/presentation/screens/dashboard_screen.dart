import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/constants.dart';
import '../../providers/auth_provider.dart';
import '../../providers/nodes_provider.dart';
import '../../providers/telemetry_provider.dart';
import '../../models/sensor_model.dart';
import '../widgets/station_hero_header.dart';
import '../widgets/npk_summary_card.dart';
import '../widgets/soil_condition_card.dart';
import '../widgets/thermal_iot_card.dart';
import '../widgets/sensor_metric_card.dart';
import '../widgets/app_preloader.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  String _selectedCategory = 'all'; // 'all', 'npk', 'soil', 'environment'
  int _heroCardIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<SensorModel> _filterSensors(List<SensorModel> all) {
    return _filterSensorsWithCat(all, _selectedCategory);
  }

  List<SensorModel> _filterSensorsWithCat(List<SensorModel> all, String cat) {
    if (cat == 'all') return all;
    return all.where((s) {
      final name = s.name.toLowerCase();
      final type = s.type.toLowerCase();
      if (cat == 'npk') {
        return name.contains('nitrogen') || name.contains('phosphor') || name.contains('kalium') || name.contains('npk') || type.contains('npk');
      }
      if (cat == 'soil') {
        return name.contains('kelembaban') || name.contains('moisture') || name.contains('ph') || name.contains('ec') || name.contains('suhu tanah') || type.contains('soil');
      }
      if (cat == 'environment') {
        return name.contains('panel') || name.contains('box') || name.contains('enclosure') || name.contains('udara') || name.contains('baterai') || name.contains('suhu lingkungan') || type.contains('env');
      }
      return true;
    }).toList();
  }

  double? _getSensorVal(List<SensorModel> sensors, List<String> keywords, WidgetRef ref) {
    for (final s in sensors) {
      final name = s.name.toLowerCase();
      final type = s.type.toLowerCase();
      if (keywords.any((k) => name.contains(k) || type.contains(k))) {
        return ref.watch(telemetryProvider.notifier).getLiveSensorValue(s);
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final nodesState = ref.watch(nodesProvider);
    final telemetryState = ref.watch(telemetryProvider);
    final selectedNode = nodesState.selectedNode;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(LucideIcons.sprout, color: AppColors.primary, size: 22),
            const SizedBox(width: 8),
            Text(AppConstants.appName, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.logOut, size: 18, color: AppColors.danger),
            tooltip: 'Keluar',
            onPressed: () {
              ref.read(authProvider.notifier).logout();
            },
          ),
        ],
      ),
      body: nodesState.isLoading
          ? const AppPreloader(fullScreen: false)
          : RefreshIndicator(
              onRefresh: () async {
                await ref.read(nodesProvider.notifier).fetchNodes();
                if (selectedNode != null) {
                  await ref.read(telemetryProvider.notifier).fetchHistory(selectedNode.id);
                }
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Station Hero Header
                    if (selectedNode != null)
                      StationHeroHeader(
                        node: selectedNode,
                        allNodes: nodesState.nodes,
                        onSelectNode: (id) {
                          ref.read(nodesProvider.notifier).selectNode(id);
                          ref.read(telemetryProvider.notifier).fetchHistory(id);
                        },
                      ),
                    const SizedBox(height: 14),

                    // 2. Three Top Executive Hero KPI Cards (Interactive Carousel with Live Telemetry Binding)
                    if (selectedNode != null) ...[
                      Builder(
                        builder: (context) {
                          final sensors = selectedNode.sensors;
                          final n = _getSensorVal(sensors, ['nitrogen'], ref) ?? 68.7;
                          final p = _getSensorVal(sensors, ['phosphor', 'fosfor', 'phosphorus'], ref) ?? 35.9;
                          final k = _getSensorVal(sensors, ['kalium', 'potassium'], ref) ?? 28.4;

                          final soilMoist = _getSensorVal(sensors, ['kelembaban rata', 'kelembaban tanah 1', 'lengas', 'kelembaban'], ref) ?? 58.4;
                          final ph = _getSensorVal(sensors, ['ph'], ref) ?? 6.8;
                          final ec = _getSensorVal(sensors, ['ec', 'salinitas', 'konduktivitas'], ref) ?? 1240.0;
                          final soilTemp = _getSensorVal(sensors, ['suhu tanah'], ref) ?? 26.5;

                          final encTemp = _getSensorVal(sensors, ['suhu dalam', 'casing', 'enclosure', 'box', 'panel'], ref) ?? 32.4;
                          final ambTemp = _getSensorVal(sensors, ['suhu luar', 'udara', 'ambient', 'suhu lingkungan'], ref) ?? 28.1;
                          final ambHum = _getSensorVal(sensors, ['kelembaban udara', 'lembab luar', 'humidity'], ref) ?? 72.0;
                          final battery = _getSensorVal(sensors, ['baterai', 'battery', 'tegangan'], ref) ?? 12.6;

                          return SizedBox(
                            height: 148,
                            child: PageView(
                              controller: _pageController,
                              onPageChanged: (idx) => setState(() => _heroCardIndex = idx),
                              children: [
                                NpkSummaryCard(nVal: n, pVal: p, kVal: k),
                                SoilConditionCard(avgMoisture: soilMoist, phVal: ph, ecVal: ec, soilTemp: soilTemp),
                                ThermalIotCard(enclosureTemp: encTemp, ambientTemp: ambTemp, ambientHumidity: ambHum, batteryVolt: battery),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 8),

                      // Carousel Dots Indicator
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(3, (i) {
                          final isCurrent = i == _heroCardIndex;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: isCurrent ? 18 : 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: isCurrent ? AppColors.primary : AppColors.border,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 16),

                      // 3. Modern Category Filter Selector Pills with Icons & Badges
                      Builder(
                        builder: (context) {
                          final sensors = selectedNode.sensors;
                          final npkCount = _filterSensorsWithCat(sensors, 'npk').length;
                          final soilCount = _filterSensorsWithCat(sensors, 'soil').length;
                          final envCount = _filterSensorsWithCat(sensors, 'environment').length;

                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _buildCategoryPill(
                                  id: 'all',
                                  label: 'Semua',
                                  count: sensors.length,
                                  icon: LucideIcons.layers,
                                  accentColor: const Color(0xFF6366F1),
                                ),
                                const SizedBox(width: 8),
                                _buildCategoryPill(
                                  id: 'npk',
                                  label: 'Unsur NPK',
                                  count: npkCount,
                                  icon: LucideIcons.leaf,
                                  accentColor: const Color(0xFF008F00),
                                ),
                                const SizedBox(width: 8),
                                _buildCategoryPill(
                                  id: 'soil',
                                  label: 'Kondisi Tanah',
                                  count: soilCount,
                                  icon: LucideIcons.droplets,
                                  accentColor: const Color(0xFFD97706),
                                ),
                                const SizedBox(width: 8),
                                _buildCategoryPill(
                                  id: 'environment',
                                  label: 'IoT & Lingkungan',
                                  count: envCount,
                                  icon: LucideIcons.cpu,
                                  accentColor: const Color(0xFF0284C7),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),

                      // 4. Categorized Sensor Metric Grid
                      Builder(
                        builder: (context) {
                          final filtered = _filterSensors(selectedNode.sensors);
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1.25,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                            itemCount: filtered.length,
                            itemBuilder: (context, idx) {
                              final sensor = filtered[idx];
                              final liveVal = ref.watch(telemetryProvider.notifier).getLiveSensorValue(sensor);
                              return SensorMetricCard(sensor: sensor, value: liveVal);
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 20),

                      // 5. Mini Real-Time Time-Series Trend Chart Card
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
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(LucideIcons.trendingUp, size: 16, color: AppColors.primary),
                                    SizedBox(width: 6),
                                    Text('Tren Data 24 Jam', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                                  ],
                                ),
                                Text('Live Feed', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.primary)),
                              ],
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 130,
                              child: LineChart(
                                LineChartData(
                                  gridData: const FlGridData(show: false),
                                  titlesData: const FlTitlesData(show: false),
                                  borderData: FlBorderData(show: false),
                                  lineBarsData: [
                                    LineChartBarData(
                                      spots: const [
                                        FlSpot(0, 22),
                                        FlSpot(1, 25),
                                        FlSpot(2, 24),
                                        FlSpot(3, 28),
                                        FlSpot(4, 26),
                                        FlSpot(5, 30),
                                        FlSpot(6, 29),
                                      ],
                                      isCurved: true,
                                      color: AppColors.primary,
                                      barWidth: 3,
                                      isStrokeCapRound: true,
                                      dotData: const FlDotData(show: false),
                                      belowBarData: BarAreaData(
                                        show: true,
                                        color: AppColors.primary.withOpacity(0.1),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildCategoryPill({
    required String id,
    required String label,
    required int count,
    required IconData icon,
    required Color accentColor,
  }) {
    final isSelected = _selectedCategory == id;

    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF1F5F9) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFFCBD5E1) : const Color(0xFFE2E8F0),
            width: isSelected ? 1.4 : 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              )
            else
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Category Icon Container
            Container(
              padding: const EdgeInsets.all(4.5),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : accentColor.withOpacity(0.10),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: isSelected ? const Color(0xFFE2E8F0) : Colors.transparent,
                  width: 0.8,
                ),
              ),
              child: Icon(
                icon,
                size: 13,
                color: accentColor,
              ),
            ),
            const SizedBox(width: 7),

            // Category Label
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
                color: isSelected ? const Color(0xFF0F172A) : const Color(0xFF64748B),
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(width: 6),

            // Number Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected ? const Color(0xFFCBD5E1) : const Color(0xFFE2E8F0),
                  width: 0.8,
                ),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
                  color: isSelected ? const Color(0xFF0F172A) : const Color(0xFF94A3B8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
extension ListFilter<T> on List<T> {
  List<T> filter(bool Function(T) test) {
    return where(test).toList();
  }
}
