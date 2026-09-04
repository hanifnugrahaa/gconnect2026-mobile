import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants.dart';
import '../../providers/nodes_provider.dart';
import '../../providers/telemetry_provider.dart';
import '../../models/sensor_model.dart';
import '../widgets/station_hero_header.dart';
import '../widgets/npk_summary_card.dart';
import '../widgets/soil_condition_card.dart';
import '../widgets/thermal_iot_card.dart';
import '../widgets/sensor_metric_card.dart';
import '../widgets/ai_suggestion_card.dart';
import '../widgets/app_preloader.dart';

class GuestDashboardScreen extends ConsumerStatefulWidget {
  final VoidCallback? onLoginTap;

  const GuestDashboardScreen({super.key, this.onLoginTap});

  @override
  ConsumerState<GuestDashboardScreen> createState() => _GuestDashboardScreenState();
}

class _GuestDashboardScreenState extends ConsumerState<GuestDashboardScreen> {
  String _selectedCategory = 'all';
  int _heroCardIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
    final nodesState = ref.watch(nodesProvider);
    final selectedNode = nodesState.selectedNode;

    return Scaffold(
      backgroundColor: const Color(0xFF040E0A),
      body: Stack(
        children: [
          // ── 1. Full-screen Farm Wallpaper Background ───────────────────────
          Positioned.fill(
            child: Image.asset(
              'assets/images/farm_bg.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // ── 2. Dark Vignette Gradient Overlay ──────────────────────────────
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x99000000),
                    Color(0x44051B12),
                    Color(0xF0040E0A),
                  ],
                  stops: [0.0, 0.35, 0.85],
                ),
              ),
            ),
          ),

          // ── 3. Scrollable Main Content ────────────────────────────────────
          SafeArea(
            bottom: false,
            child: nodesState.isLoading
                ? const AppPreloader(fullScreen: false)
                : RefreshIndicator(
                    color: const Color(0xFF10B981),
                    backgroundColor: const Color(0xFF071E14),
                    onRefresh: () async {
                      await ref.read(nodesProvider.notifier).fetchNodes();
                      if (selectedNode != null) {
                        await ref.read(telemetryProvider.notifier).fetchHistory(selectedNode.id);
                      }
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // A. Station Header + Hero Weather Section
                          if (selectedNode != null) ...[
                            Builder(
                              builder: (context) {
                                final sensors = selectedNode.sensors;
                                final ambTemp = _getSensorVal(sensors, ['suhu luar', 'udara', 'ambient', 'suhu lingkungan'], ref);
                                final ambHum = _getSensorVal(sensors, ['kelembaban udara', 'lembab luar', 'humidity'], ref);

                                return StationHeroHeader(
                                  node: selectedNode,
                                  allNodes: nodesState.nodes,
                                  ambientTemp: ambTemp,
                                  ambientHumidity: ambHum,
                                  onSelectNode: (id) {
                                    ref.read(nodesProvider.notifier).selectNode(id);
                                    ref.read(telemetryProvider.notifier).fetchHistory(id);
                                  },
                                );
                              },
                            ),
                          ],
                          const SizedBox(height: 18),

                          // B. Today's AI Suggestion Card
                          if (selectedNode != null) ...[
                            Builder(
                              builder: (context) {
                                final sensors = selectedNode.sensors;
                                final n = _getSensorVal(sensors, ['nitrogen'], ref);
                                final p = _getSensorVal(sensors, ['phosphor', 'fosfor', 'phosphorus'], ref);
                                final k = _getSensorVal(sensors, ['kalium', 'potassium'], ref);
                                final moist = _getSensorVal(sensors, ['kelembaban rata', 'kelembaban tanah 1', 'lengas', 'kelembaban'], ref);
                                final boxTemp = _getSensorVal(sensors, ['suhu dalam', 'casing', 'enclosure', 'box', 'panel'], ref);

                                return AiSuggestionCard(
                                  nVal: n,
                                  pVal: p,
                                  kVal: k,
                                  soilMoisture: moist,
                                  boxTemp: boxTemp,
                                );
                              },
                            ),
                          ],
                          const SizedBox(height: 16),

                          // C. Executive KPI Cards Carousel
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

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 154,
                                      child: PageView(
                                        controller: _pageController,
                                        onPageChanged: (idx) => setState(() => _heroCardIndex = idx),
                                        children: [
                                          NpkSummaryCard(nVal: n, pVal: p, kVal: k),
                                          SoilConditionCard(avgMoisture: soilMoist, phVal: ph, ecVal: ec, soilTemp: soilTemp),
                                          ThermalIotCard(enclosureTemp: encTemp, ambientTemp: ambTemp, ambientHumidity: ambHum, batteryVolt: battery),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 8),

                                    // Dots Indicator
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: List.generate(3, (i) {
                                        final isCurrent = i == _heroCardIndex;
                                        return AnimatedContainer(
                                          duration: const Duration(milliseconds: 250),
                                          margin: const EdgeInsets.symmetric(horizontal: 3),
                                          width: isCurrent ? 20 : 6,
                                          height: 5,
                                          decoration: BoxDecoration(
                                            color: isCurrent ? const Color(0xFF34D399) : Colors.white24,
                                            borderRadius: BorderRadius.circular(3),
                                          ),
                                        );
                                      }),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                          const SizedBox(height: 18),

                          // D. Category Filter Pills
                          if (selectedNode != null) ...[
                            Builder(
                              builder: (context) {
                                final sensors = selectedNode.sensors;
                                final npkCount = _filterSensorsWithCat(sensors, 'npk').length;
                                final soilCount = _filterSensorsWithCat(sensors, 'soil').length;
                                final envCount = _filterSensorsWithCat(sensors, 'environment').length;

                                return SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  physics: const BouncingScrollPhysics(),
                                  child: Row(
                                    children: [
                                      _buildCategoryPill(
                                        id: 'all',
                                        label: 'Semua',
                                        count: sensors.length,
                                      ),
                                      const SizedBox(width: 8),
                                      _buildCategoryPill(
                                        id: 'npk',
                                        label: 'Unsur NPK',
                                        count: npkCount,
                                      ),
                                      const SizedBox(width: 8),
                                      _buildCategoryPill(
                                        id: 'soil',
                                        label: 'Kondisi Tanah',
                                        count: soilCount,
                                      ),
                                      const SizedBox(width: 8),
                                      _buildCategoryPill(
                                        id: 'environment',
                                        label: 'Lingkungan Boks',
                                        count: envCount,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                          const SizedBox(height: 14),

                          // E. Sensor Metric Cards Grid
                          if (selectedNode != null) ...[
                            Builder(
                              builder: (context) {
                                final filtered = _filterSensorsWithCat(selectedNode.sensors, _selectedCategory);

                                if (filtered.isEmpty) {
                                  return Container(
                                    padding: const EdgeInsets.all(24),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Tidak ada sensor dalam kategori ini',
                                      style: GoogleFonts.plusJakartaSans(
                                        color: Colors.white60,
                                        fontSize: 13,
                                      ),
                                    ),
                                  );
                                }

                                return GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 1.32,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                  ),
                                  itemCount: filtered.length,
                                  itemBuilder: (context, idx) {
                                    final sensor = filtered[idx];
                                    final val = ref.watch(telemetryProvider.notifier).getLiveSensorValue(sensor);
                                    return SensorMetricCard(
                                      sensor: sensor,
                                      value: val,
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryPill({
    required String id,
    required String label,
    required int count,
  }) {
    final isSelected = _selectedCategory == id;

    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF10B981)
              : Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF34D399)
                : Colors.white.withOpacity(0.14),
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF10B981).withOpacity(0.40),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? const Color(0xFF042F1E) : Colors.white,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF042F1E).withOpacity(0.20) : Colors.white.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$count',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: isSelected ? const Color(0xFF042F1E) : const Color(0xFF94A3B8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
