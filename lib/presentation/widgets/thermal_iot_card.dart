import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'liquid_glass_panel.dart';

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
    if (boxTemp > 45) return const Color(0xFFF43F5E);
    return const Color(0xFF34D399);
  }

  @override
  Widget build(BuildContext context) {
    final boxTemp  = enclosureTemp   ?? 32.4;
    final airTemp  = ambientTemp     ?? 28.1;
    final airHum   = ambientHumidity ?? 72.0;
    final volt     = batteryVolt     ?? 12.6;

    final statusText  = _getThermalStatus(boxTemp);
    final statusColor = _getStatusColor(boxTemp);
    final isHot       = boxTemp > 45;

    return LiquidGlassPanel(
      padding: EdgeInsets.zero,
      borderRadius: 22,
      child: Stack(
        children: [
          // Decorative ambient glow rings
          Positioned(
            right: -30,
            top: -30,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (isHot ? const Color(0xFFF43F5E) : const Color(0xFF10B981))
                    .withOpacity(0.08),
              ),
            ),
          ),
          Positioned(
            right: -10,
            top: -10,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (isHot ? const Color(0xFFF43F5E) : const Color(0xFF10B981))
                    .withOpacity(0.12),
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 11, 14, 11),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status Termal & Boks IoT',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      statusText,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // 4 metrics
                Row(
                  children: [
                    _buildMetric(LucideIcons.cpu,             'Boks Panel', '${boxTemp.toStringAsFixed(1)}°C', const Color(0xFFF43F5E)),
                    const SizedBox(width: 10),
                    _buildMetric(LucideIcons.sun,             'Suhu Udara', '${airTemp.toStringAsFixed(1)}°C', const Color(0xFFFB923C)),
                    const SizedBox(width: 10),
                    _buildMetric(LucideIcons.wind,            'Kelembaban', '${airHum.toStringAsFixed(0)}%',   const Color(0xFF38BDF8)),
                    const SizedBox(width: 10),
                    _buildMetric(LucideIcons.batteryCharging, 'Tegangan',   '${volt.toStringAsFixed(1)} V',    const Color(0xFF34D399)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(IconData icon, String label, String value, Color accent) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: accent.withOpacity(0.18),
              shape: BoxShape.circle,
              border: Border.all(
                color: accent.withOpacity(0.35),
                width: 0.8,
              ),
            ),
            child: Icon(icon, size: 13, color: accent),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 9.5,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF94A3B8),
            ),
          ),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.3,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
