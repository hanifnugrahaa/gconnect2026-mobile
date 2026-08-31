import 'package:flutter/material.dart';
import '../../models/sensor_model.dart';

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
        gradient: const [Color(0xFF64748B), Color(0xFF475569), Color(0xFF334155)],
        shadowColor: const Color(0x22000000),
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

    // 1. Alert: Rendah (Below Min Threshold) - Sky / Ice Blue
    if (min != null && val < min) {
      return _MetricCardVisualState(
        gradient: const [Color(0xFF38BDF8), Color(0xFF0284C7), Color(0xFF0369A1)],
        shadowColor: const Color(0x330284C7),
        statusText: 'RENDAH',
        isAlert: true,
        rangeText: rangeStr,
      );
    }

    // 2. Alert: Tinggi (Above Max Threshold) - Coral Rose Alert
    if (max != null && val > max) {
      return _MetricCardVisualState(
        gradient: const [Color(0xFFFB7185), Color(0xFFF43F5E), Color(0xFFE11D48)],
        shadowColor: const Color(0x33E11D48),
        statusText: 'TINGGI',
        isAlert: true,
        rangeText: rangeStr,
      );
    }

    // 3. Optimal / Normal (Within Safe Range) - Brand Green #008F00
    return _MetricCardVisualState(
      gradient: const [Color(0xFF00B200), Color(0xFF008F00), Color(0xFF006400)],
      shadowColor: const Color(0x33008F00),
      statusText: 'OPTIMAL',
      isAlert: false,
      rangeText: rangeStr,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = _getCardState(value);
    final formattedVal = value != null ? (value! % 1 == 0 ? value!.toInt().toString() : value!.toStringAsFixed(1)) : '--';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: state.gradient,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: state.shadowColor,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(
          color: Colors.white.withOpacity(0.20),
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          // Ambient Decorative Circle
          Positioned(
            right: -15,
            bottom: -15,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
              ),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top Row: Sensor Title & Glassmorphism Status Capsule
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      sensor.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: Colors.white.withOpacity(0.95),
                        height: 1.15,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.25),
                            offset: const Offset(0, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),

                  // Glassmorphism Status Capsule
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.5,
                      vertical: state.isAlert ? 2.5 : 3.5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(state.isAlert ? 8 : 20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.40),
                        width: 0.8,
                      ),
                    ),
                    child: state.isAlert
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                state.statusText,
                                style: const TextStyle(
                                  fontSize: 8.5,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: 0.3,
                                  height: 1,
                                ),
                              ),
                              if (state.rangeText.isNotEmpty) ...[
                                Container(
                                  margin: const EdgeInsets.symmetric(vertical: 1.5),
                                  width: 24,
                                  height: 0.5,
                                  color: Colors.white.withOpacity(0.35),
                                ),
                                Text(
                                  state.rangeText,
                                  style: TextStyle(
                                    fontSize: 7.5,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white.withOpacity(0.95),
                                    height: 1,
                                  ),
                                ),
                              ],
                            ],
                          )
                        : Text(
                            state.statusText,
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 0.3,
                              height: 1,
                            ),
                          ),
                  ),
                ],
              ),

              // Bottom Row: Large Value + Unit
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    formattedVal,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -0.5,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.25),
                          offset: const Offset(0, 1.5),
                          blurRadius: 3,
                        ),
                      ],
                    ),
                  ),
                  if (sensor.unit.isNotEmpty) ...[
                    const SizedBox(width: 3.5),
                    Expanded(
                      child: Text(
                        sensor.unit,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: Colors.white.withOpacity(0.90),
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.2),
                              offset: const Offset(0, 1),
                              blurRadius: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricCardVisualState {
  final List<Color> gradient;
  final Color shadowColor;
  final String statusText;
  final bool isAlert;
  final String rangeText;

  _MetricCardVisualState({
    required this.gradient,
    required this.shadowColor,
    required this.statusText,
    required this.isAlert,
    required this.rangeText,
  });
}
