import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/constants.dart';
import '../../models/sensor_model.dart';

class SensorMetricCard extends StatelessWidget {
  final SensorModel sensor;
  final double? value;

  const SensorMetricCard({
    super.key,
    required this.sensor,
    this.value,
  });

  IconData _getIconForSensor(String name, String type) {
    final lower = name.toLowerCase();
    if (lower.contains('nitrogen') || lower.contains('phosphor') || lower.contains('kalium') || lower.contains('npk')) {
      return LucideIcons.flaskConical;
    }
    if (lower.contains('kelembaban') || lower.contains('moisture')) {
      return LucideIcons.droplets;
    }
    if (lower.contains('suhu') || lower.contains('temp')) {
      return LucideIcons.thermometer;
    }
    if (lower.contains('ph')) {
      return LucideIcons.testTube;
    }
    if (lower.contains('ec') || lower.contains('konduktivitas')) {
      return LucideIcons.zap;
    }
    if (lower.contains('panel') || lower.contains('box') || lower.contains('enclosure')) {
      return LucideIcons.cpu;
    }
    if (lower.contains('baterai') || lower.contains('battery')) {
      return LucideIcons.batteryCharging;
    }
    return LucideIcons.activity;
  }

  Color _getColorForSensor(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('nitrogen')) return AppColors.nitrogen;
    if (lower.contains('phosphor')) return AppColors.phosphorus;
    if (lower.contains('kalium')) return AppColors.potassium;
    if (lower.contains('kelembaban')) return AppColors.moisture;
    if (lower.contains('suhu')) return AppColors.temperature;
    return AppColors.primary;
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = _getColorForSensor(sensor.name);
    final iconData = _getIconForSensor(sensor.name, sensor.type);
    final formattedVal = value != null ? value!.toStringAsFixed(1) : '--';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(iconData, color: accentColor, size: 18),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: (value != null ? AppColors.success : AppColors.textMuted).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  value != null ? 'Optimal' : 'Offline',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: value != null ? AppColors.success : AppColors.textMuted,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            sensor.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 2),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                formattedVal,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
              if (sensor.unit.isNotEmpty) ...[
                const SizedBox(width: 4),
                Text(
                  sensor.unit,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
