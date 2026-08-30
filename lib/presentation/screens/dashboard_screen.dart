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

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final nodesState = ref.watch(nodesProvider);
    final telemetryState = ref.watch(telemetryProvider);
    final selectedNode = nodesState.selectedNode;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(LucideIcons.sprout, color: AppColors.primary, size: 20),
                const SizedBox(width: 6),
                Text(AppConstants.appName, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
              ],
            ),
            Text(
              'Halo, ${authState.user?.name ?? 'Pengguna'}',
              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
            ),
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
                    // Node Selector Bar
                    NodeSelectorBar(
                      nodes: nodesState.nodes,
                      selectedNodeId: nodesState.selectedNodeId,
                      onSelect: (id) {
                        ref.read(nodesProvider.notifier).selectNode(id);
                        ref.read(telemetryProvider.notifier).fetchHistory(id);
                      },
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

                      // Live Sensor Grid
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Parameter Sensor (${selectedNode.sensors.length})',
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
                                Icon(LucideIcons.activity, size: 10, color: AppColors.success),
                                SizedBox(width: 4),
                                Text('Live 60 FPS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.success)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

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
