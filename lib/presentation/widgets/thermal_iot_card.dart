import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/constants.dart';

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

  @override
  Widget build(BuildContext context) {
    final boxTemp = enclosureTemp ?? 32.4;
    final airTemp = ambientTemp ?? 28.1;
    final airHum = ambientHumidity ?? 72.0;
    final volt = batteryVolt ?? 12.6;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(LucideIcons.cpu, size: 16, color: AppColors.temperature),
                  SizedBox(width: 6),
                  Text(
                    'Status Termal & Boks IoT',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  '< 55°C Aman',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.success),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 4 Grid KPI Metrics
          Row(
            children: [
              _buildMetricItem('Suhu Boks', '${boxTemp.toStringAsFixed(1)}°C', AppColors.temperature),
              _buildDivider(),
              _buildMetricItem('Suhu Udara', '${airTemp.toStringAsFixed(1)}°C', AppColors.nitrogen),
              _buildDivider(),
              _buildMetricItem('Kelembaban', '${airHum.toStringAsFixed(0)}%', AppColors.moisture),
              _buildDivider(),
              _buildMetricItem('Tegangan Aki', '${volt.toStringAsFixed(1)} V', AppColors.primary),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem(String title, String val, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 4),
          Text(
            val,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(width: 1, height: 26, color: AppColors.border);
  }
}
