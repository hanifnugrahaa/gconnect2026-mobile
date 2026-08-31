import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ThermalIotCard extends StatelessWidget {
  final double? enclosureTemp;
  final double? ambientTemp;
  final double? ambientHumidity;
  final double? batteryVolt;

  const ThermalIotCard({
    super.key,
    this.enclosureTemp,
    this.ambientTemp,
    this.ambientHumidity,
    this.batteryVolt,
  });

  String _getThermalStatus(double boxTemp) {
    if (boxTemp > 45) return 'Suhu Box Tinggi';
    return '< 55°C Aman';
  }

  Color _getStatusColor(double boxTemp) {
    if (boxTemp > 45) return const Color(0xFFBE123C);
    return const Color(0xFF047857);
  }

  Color _getStatusBg(double boxTemp) {
    if (boxTemp > 45) return const Color(0xFFFFF1F2);
    return const Color(0xFFECFDF5);
  }

  Color _getStatusBorder(double boxTemp) {
    if (boxTemp > 45) return const Color(0xFFFECDD3);
    return const Color(0xFFA7F3D0);
  }

  @override
  Widget build(BuildContext context) {
    final boxTemp = enclosureTemp ?? 32.4;
    final airTemp = ambientTemp ?? 28.1;
    final airHum = ambientHumidity ?? 72.0;
    final volt = batteryVolt ?? 12.6;

    final statusText = _getThermalStatus(boxTemp);
    final statusColor = _getStatusColor(boxTemp);
    final statusBg = _getStatusBg(boxTemp);
    final statusBorder = _getStatusBorder(boxTemp);

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
                      color: const Color(0xFFFFE4E6),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFFFECDD3),
                        width: 0.8,
                      ),
                    ),
                    child: const Icon(LucideIcons.cpu, size: 13, color: Color(0xFFE11D48)),
                  ),
                  const SizedBox(width: 7),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Status Termal & Boks IoT',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF0F172A),
                          letterSpacing: -0.3,
                        ),
                      ),
                      Text(
                        'Enclosure & Suhu Lingkungan',
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
              _buildCleanThermalItem(
                icon: LucideIcons.cpu,
                title: 'Boks Panel',
                val: '${boxTemp.toStringAsFixed(1)}°C',
                accentColor: const Color(0xFFE11D48),
                bgColor: const Color(0xFFFFF1F2),
                borderColor: const Color(0xFFFECDD3),
              ),
              const SizedBox(width: 5.5),
              _buildCleanThermalItem(
                icon: LucideIcons.sun,
                title: 'Suhu Udara',
                val: '${airTemp.toStringAsFixed(1)}°C',
                accentColor: const Color(0xFFEA580C),
                bgColor: const Color(0xFFFFF7ED),
                borderColor: const Color(0xFFFED7AA),
              ),
              const SizedBox(width: 5.5),
              _buildCleanThermalItem(
                icon: LucideIcons.wind,
                title: 'Kelembaban',
                val: '${airHum.toStringAsFixed(0)}%',
                accentColor: const Color(0xFF0284C7),
                bgColor: const Color(0xFFF0F9FF),
                borderColor: const Color(0xFFBAE6FD),
              ),
              const SizedBox(width: 5.5),
              _buildCleanThermalItem(
                icon: LucideIcons.batteryCharging,
                title: 'Tegangan',
                val: '${volt.toStringAsFixed(1)} V',
                accentColor: const Color(0xFF059669),
                bgColor: const Color(0xFFF0FDF4),
                borderColor: const Color(0xFFBBF7D0),
              ),
            ],
          ),
          const SizedBox(height: 7.5),

          // Clean Thermal Safe Zone Track Indicator (<55 safe)
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              height: 5,
              child: Row(
                children: [
                  Expanded(
                    flex: ((boxTemp / 60.0) * 100).clamp(5, 100).round(),
                    child: Container(
                      decoration: BoxDecoration(
                        color: boxTemp > 45 ? const Color(0xFFE11D48) : const Color(0xFF10B981),
                        borderRadius: const BorderRadius.horizontal(left: Radius.circular(3)),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: (100 - ((boxTemp / 60.0) * 100).clamp(5, 100)).round(),
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

  Widget _buildCleanThermalItem({
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
