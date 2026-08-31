import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class SoilConditionCard extends StatelessWidget {
  final double? avgMoisture;
  final double? phVal;
  final double? ecVal;
  final double? soilTemp;

  const SoilConditionCard({
    super.key,
    this.avgMoisture,
    this.phVal,
    this.ecVal,
    this.soilTemp,
  });

  String _getSoilStatus(double moisture) {
    if (moisture < 30) return 'Perlu Irigasi';
    if (moisture > 85) return 'Jenuh Air';
    return 'Lembab Optimal';
  }

  Color _getStatusColor(double moisture) {
    if (moisture < 30 || moisture > 85) return const Color(0xFFB45309);
    return const Color(0xFF047857);
  }

  Color _getStatusBg(double moisture) {
    if (moisture < 30 || moisture > 85) return const Color(0xFFFEF3C7);
    return const Color(0xFFECFDF5);
  }

  Color _getStatusBorder(double moisture) {
    if (moisture < 30 || moisture > 85) return const Color(0xFFFDE68A);
    return const Color(0xFFA7F3D0);
  }

  @override
  Widget build(BuildContext context) {
    final moisture = avgMoisture ?? 58.4;
    final ph = phVal ?? 6.8;
    final ec = ecVal ?? 1240.0;
    final temp = soilTemp ?? 26.5;

    final statusText = _getSoilStatus(moisture);
    final statusColor = _getStatusColor(moisture);
    final statusBg = _getStatusBg(moisture);
    final statusBorder = _getStatusBorder(moisture);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F2FE),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFFBAE6FD),
                        width: 0.8,
                      ),
                    ),
                    child: const Icon(LucideIcons.droplets, size: 13, color: Color(0xFF0284C7)),
                  ),
                  const SizedBox(width: 7),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Kondisi & Kelembaban Tanah',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF0F172A),
                          letterSpacing: -0.3,
                        ),
                      ),
                      Text(
                        'Media Perakaran Multi-Probe',
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Clean Status Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7.5, vertical: 3),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: statusBorder,
                    width: 0.8,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 5.5,
                      height: 5.5,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4.5),
                    Text(
                      statusText,
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w800,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.5),

          // 4 Grid KPI Values with Clean Micro-Cells
          Row(
            children: [
              _buildCleanSoilItem(
                icon: LucideIcons.droplets,
                title: 'Lengas',
                val: '${moisture.toStringAsFixed(1)}%',
                accentColor: const Color(0xFF0284C7),
                bgColor: const Color(0xFFF0F9FF),
                borderColor: const Color(0xFFBAE6FD),
              ),
              const SizedBox(width: 5.5),
              _buildCleanSoilItem(
                icon: LucideIcons.activity,
                title: 'pH',
                val: ph.toStringAsFixed(1),
                accentColor: const Color(0xFF059669),
                bgColor: const Color(0xFFF0FDF4),
                borderColor: const Color(0xFFBBF7D0),
              ),
              const SizedBox(width: 5.5),
              _buildCleanSoilItem(
                icon: LucideIcons.zap,
                title: 'EC',
                val: '${ec.toStringAsFixed(0)} µS',
                accentColor: const Color(0xFF7C3AED),
                bgColor: const Color(0xFFFAF5FF),
                borderColor: const Color(0xFFE9D5FF),
              ),
              const SizedBox(width: 5.5),
              _buildCleanSoilItem(
                icon: LucideIcons.thermometer,
                title: 'Suhu',
                val: '${temp.toStringAsFixed(1)}°C',
                accentColor: const Color(0xFFEA580C),
                bgColor: const Color(0xFFFFF7ED),
                borderColor: const Color(0xFFFED7AA),
              ),
            ],
          ),
          const SizedBox(height: 7.5),

          // Clean Soil Moisture Track Indicator
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              height: 5,
              child: Row(
                children: [
                  Expanded(
                    flex: (moisture.clamp(0, 100)).round(),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFF0284C7),
                        borderRadius: BorderRadius.horizontal(left: Radius.circular(3)),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: (100 - moisture.clamp(0, 100)).round(),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: const BorderRadius.horizontal(right: Radius.circular(3)),
                      ),
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

  Widget _buildCleanSoilItem({
    required IconData icon,
    required String title,
    required String val,
    required Color accentColor,
    required Color bgColor,
    required Color borderColor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5.5),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor, width: 0.9),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Row: Mini Icon + Title
            Row(
              children: [
                Icon(icon, size: 10, color: accentColor),
                const SizedBox(width: 3),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: accentColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 3),

            // Value Text
            Text(
              val,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w900,
                color: Color(0xFF0F172A),
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
