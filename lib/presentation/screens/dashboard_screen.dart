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
    if (_selectedCategory == 'all') return all;
    return all.filter((s) {
      final name = s.name.toLowerCase();
      final type = s.type.toLowerCase();
      if (_selectedCategory == 'npk') {
        return name.contains('nitrogen') || name.contains('phosphor') || name.contains('kalium') || name.contains('npk') || type.contains('npk');
      }
      if (_selectedCategory == 'soil') {
        return name.contains('kelembaban') || name.contains('moisture') || name.contains('ph') || name.contains('ec') || name.contains('suhu tanah') || type.contains('soil');
      }
      if (_selectedCategory == 'environment') {
        return name.contains('panel') || name.contains('box') || name.contains('enclosure') || name.contains('udara') || name.contains('baterai') || name.contains('suhu lingkungan') || type.contains('env');
      }
      return true;
    }).toList();
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

                    // 2. Three Top Executive Hero KPI Cards (Interactive Carousel)
                    if (selectedNode != null) ...[
                      SizedBox(
                        height: 130,
                        child: PageView(
                          controller: _pageController,
                          onPageChanged: (idx) => setState(() => _heroCardIndex = idx),
                          children: const [
                            NpkSummaryCard(nVal: 68.7, pVal: 35.9, kVal: 28.4),
                            SoilConditionCard(avgMoisture: 58.4, phVal: 6.8, ecVal: 1240, soilTemp: 26.5),
                            ThermalIotCard(enclosureTemp: 32.4, ambientTemp: 28.1, ambientHumidity: 72, batteryVolt: 12.6),
                          ],
                        ),
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

                      // 3. Category Filter Selector Pills
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildCategoryPill('all', 'Semua (${selectedNode.sensors.length})'),
                            const SizedBox(width: 8),
                            _buildCategoryPill('npk', 'Unsur NPK (3)'),
                            const SizedBox(width: 8),
                            _buildCategoryPill('soil', 'Kondisi Tanah (5)'),
                            const SizedBox(width: 8),
                            _buildCategoryPill('environment', 'IoT & Lingkungan (4)'),
                          ],
                        ),
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
                              final liveVal = ref.read(telemetryProvider.notifier).getLiveSensorValue(sensor);
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

  Widget _buildCategoryPill(String id, String label) {
    final isSelected = _selectedCategory == id;
    return InkWell(
      onTap: () => setState(() => _selectedCategory = id),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
          boxShadow: isSelected
              ? [BoxShadow(color: AppColors.primary.withOpacity(0.2), blurRadius: 6, offset: const Offset(0, 2))]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
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
