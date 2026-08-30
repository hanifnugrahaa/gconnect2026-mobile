import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/constants.dart';
import '../../providers/auth_provider.dart';
import '../../providers/nodes_provider.dart';
import '../../providers/telemetry_provider.dart';
import '../widgets/sensor_metric_card.dart';
import '../widgets/npk_summary_card.dart';
import '../widgets/node_selector_bar.dart';

class GuestDashboardScreen extends ConsumerWidget {
  const GuestDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nodesState = ref.watch(nodesProvider);
    final telemetryState = ref.watch(telemetryProvider);
    final selectedNode = nodesState.selectedNode;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(LucideIcons.sprout, color: AppColors.primary, size: 22),
            const SizedBox(width: 8),
            Text(AppConstants.appName, style: const TextStyle(fontWeight: FontWeight.w800)),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primaryBg,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.primaryLight.withOpacity(0.4)),
              ),
              child: const Text('Mode Tamu', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primary)),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton.icon(
              onPressed: () {
                ref.read(authProvider.notifier).goToLogin();
              },
              icon: const Icon(LucideIcons.logIn, size: 14),
              label: const Text('Login', style: TextStyle(fontSize: 12)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
      body: nodesState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                await ref.read(nodesProvider.notifier).fetchNodes();
                if (selectedNode != null) {
                  await ref.read(telemetryProvider.notifier).fetchHistory(selectedNode.id);
                }
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Login Call-to-Action Banner
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFECFDF5), Color(0xFFD1FAE5)],
                        ),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.primaryLight.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(LucideIcons.sparkles, color: AppColors.primary, size: 22),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Akses Fitur Lengkap',
                                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppColors.textPrimary),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Login untuk mengakses tab Analisis Grafik Time-Series, Peta Lahan, dan Kontrol Aktuator.',
                                  style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Station Selector Bar
                    NodeSelectorBar(
                      nodes: nodesState.nodes,
                      selectedNodeId: nodesState.selectedNodeId,
                      onSelect: (id) => ref.read(nodesProvider.notifier).selectNode(id),
                    ),
                    const SizedBox(height: 16),

                    if (selectedNode != null) ...[
                      // NPK Summary Card
                      NpkSummaryCard(
                        nVal: 68.7,
                        pVal: 35.9,
                        kVal: 28.4,
                      ),
                      const SizedBox(height: 16),

                      // Section Title
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Metrik Sensor (${selectedNode.sensors.length})',
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.success.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Row(
                              children: [
                                Icon(LucideIcons.radio, size: 10, color: AppColors.success),
                                SizedBox(width: 4),
                                Text('Live Streaming', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.success)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Sensor Grid
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.25,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: selectedNode.sensors.length,
                        itemBuilder: (context, idx) {
                          final sensor = selectedNode.sensors[idx];
                          final liveVal = ref.read(telemetryProvider.notifier).getLiveSensorValue(sensor);
                          return SensorMetricCard(sensor: sensor, value: liveVal);
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
    );
  }
}
