import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/constants.dart';

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

  @override
  Widget build(BuildContext context) {
    final moisture = avgMoisture ?? 58.4;
    final ph = phVal ?? 6.8;
    final ec = ecVal ?? 1240.0;
    final temp = soilTemp ?? 26.5;

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
                  Icon(LucideIcons.droplets, size: 16, color: AppColors.moisture),
                  SizedBox(width: 6),
                  Text(
                    'Kondisi & Kelembaban Tanah',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.moisture.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Lembab Optimal',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.moisture),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 4 Grid KPI Metrics
          Row(
            children: [
              _buildMetricItem('Rata-rata Lengas', '${moisture.toStringAsFixed(1)}%', AppColors.moisture),
              _buildDivider(),
              _buildMetricItem('Tingkat pH', ph.toStringAsFixed(1), AppColors.primary),
              _buildDivider(),
              _buildMetricItem('EC Konduktivitas', '${ec.toStringAsFixed(0)} uS', AppColors.nitrogen),
              _buildDivider(),
              _buildMetricItem('Suhu Tanah', '${temp.toStringAsFixed(1)}°C', AppColors.temperature),
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
