import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/sensor_model.dart';
import 'liquid_glass_panel.dart';

class SensorMetricCard extends StatelessWidget {
  final SensorModel sensor;
  final double? value;

  const SensorMetricCard({
    super.key,
    required this.sensor,
    this.value,
  });

  _MetricCardVisualState _getCardState(double? val) {
    if (val == null) {
      return _MetricCardVisualState(
        statusColor: const Color(0xFF64748B),
        statusText: 'OFFLINE',
        isAlert: false,
        rangeText: '',
      );
    }

    final min = sensor.minThreshold;
    final max = sensor.maxThreshold;

    String rangeStr = '';
    if (min != null || max != null) {
      final minStr = min != null ? (min % 1 == 0 ? min.toInt().toString() : min.toStringAsFixed(1)) : '0';
      final maxStr = max != null ? (max % 1 == 0 ? max.toInt().toString() : max.toStringAsFixed(1)) : '∞';
      rangeStr = '$minStr–$maxStr';
    }

    // 1. Alert: Rendah (Below Min Threshold)
    if (min != null && val < min) {
      return _MetricCardVisualState(
        statusColor: const Color(0xFF38BDF8),
        statusText: 'RENDAH',
        isAlert: true,
        rangeText: rangeStr,
      );
    }

    // 2. Alert: Tinggi (Above Max Threshold)
    if (max != null && val > max) {
      return _MetricCardVisualState(
        statusColor: const Color(0xFFF43F5E),
        statusText: 'TINGGI',
        isAlert: true,
        rangeText: rangeStr,
      );
    }

    // 3. Optimal / Normal
    return _MetricCardVisualState(
      statusColor: const Color(0xFF34D399),
      statusText: 'OPTIMAL',
      isAlert: false,
      rangeText: rangeStr,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = _getCardState(value);
    final formattedVal = value != null ? (value! % 1 == 0 ? value!.toInt().toString() : value!.toStringAsFixed(1)) : '--';

    return LiquidGlassPanel(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      borderRadius: 18,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Top row: Sensor Name + Status Pill
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  sensor.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.15,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: state.statusColor.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: state.statusColor.withOpacity(0.40),
                    width: 0.8,
                  ),
                ),
                child: Text(
                  state.statusText,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 8.5,
                    fontWeight: FontWeight.w800,
                    color: state.statusColor,
                  ),
                ),
              ),
            ],
          ),

          // Bottom value & unit
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                formattedVal,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                sensor.unit,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF94A3B8),
                ),
              ),
            ],
          ),

          // Ideal range if available
          if (state.rangeText.isNotEmpty)
            Text(
              'Ideal: ${state.rangeText} ${sensor.unit}',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 9,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF6EE7B7),
              ),
            )
          else
            const SizedBox(height: 2),
        ],
      ),
    );
  }
}

class _MetricCardVisualState {
  final Color statusColor;
  final String statusText;
  final bool isAlert;
  final String rangeText;

  _MetricCardVisualState({
    required this.statusColor,
    required this.statusText,
    required this.isAlert,
    required this.rangeText,
  });
}
