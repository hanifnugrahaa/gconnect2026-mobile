import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/constants.dart';
import '../../providers/nodes_provider.dart';

class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nodesState = ref.watch(nodesProvider);
    final nodes = nodesState.nodes;

    // Default center Yogyakarta / UGM
    final defaultCenter = const LatLng(-7.7713, 110.3775);

    final markers = nodes.map((node) {
      final lat = node.latitude ?? -7.7713;
      final lng = node.longitude ?? 110.3775;
      final isOnline = node.status.toLowerCase() == 'online';

      return Marker(
        point: LatLng(lat, lng),
        width: 60,
        height: 60,
        child: GestureDetector(
          onTap: () {
            _showNodeDetailBottomSheet(context, node);
          },
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: isOnline ? AppColors.primary : AppColors.danger,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: (isOnline ? AppColors.primary : AppColors.danger).withOpacity(0.4),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(LucideIcons.sprout, color: Colors.white, size: 16),
              ),
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  node.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Peta Sebaran Stasiun', style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: defaultCenter,
              initialZoom: 15.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.gconnect.app',
              ),
              MarkerLayer(markers: markers),
            ],
          ),

          // Top Floating Stats Badge
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Stasiun: ${nodes.length} Node',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                  ),
                  const Row(
                    children: [
                      Icon(LucideIcons.radio, size: 12, color: AppColors.success),
                      SizedBox(width: 4),
                      Text('GPS Online', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.success)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showNodeDetailBottomSheet(BuildContext context, dynamic node) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(node.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(node.status.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.success)),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(node.description ?? 'Stasiun pemantauan telemetri smart farming', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(LucideIcons.mapPin, size: 14, color: AppColors.textMuted),
                  const SizedBox(width: 4),
                  Text('${node.latitude ?? -7.7713}, ${node.longitude ?? 110.3775}', style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
