import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'liquid_glass_panel.dart';

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

  @override
  Widget build(BuildContext context) {
    final moisture = avgMoisture ?? 58.4;
    final ph = phVal ?? 6.8;
    final ec = ecVal ?? 1240.0;
    final temp = soilTemp ?? 26.5;
    final statusText = _getSoilStatus(moisture);

    return LiquidGlassPanel(
      padding: EdgeInsets.zero,
      borderRadius: 22,
      child: Stack(
        children: [
          // Chili plant photo overlay on right
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Colors.transparent, Colors.white],
                stops: [0.0, 0.45],
              ).createShader(bounds),
              blendMode: BlendMode.dstIn,
              child: Image.asset(
                'assets/images/chili_3d.jpg',
                width: 165,
                fit: BoxFit.cover,
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
                  'Kondisi & Kelembaban Tanah',
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
                      decoration: const BoxDecoration(
                        color: Color(0xFF38BDF8),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      statusText,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF7DD3FC),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // 4 metrics
                Row(
                  children: [
                    _buildMetric(LucideIcons.droplets,    'Lengas', '${moisture.toStringAsFixed(1)}%', const Color(0xFF38BDF8)),
                    const SizedBox(width: 10),
                    _buildMetric(LucideIcons.activity,    'pH',     ph.toStringAsFixed(1),             const Color(0xFF34D399)),
                    const SizedBox(width: 10),
                    _buildMetric(LucideIcons.zap,         'EC',     '${ec.toStringAsFixed(0)} µS',     const Color(0xFFA78BFA)),
                    const SizedBox(width: 10),
                    _buildMetric(LucideIcons.thermometer, 'Suhu',   '${temp.toStringAsFixed(1)}°C',    const Color(0xFFFB923C)),
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
