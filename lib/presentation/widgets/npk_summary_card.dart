import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'liquid_glass_panel.dart';

class NpkSummaryCard extends StatelessWidget {
  final double nVal;
  final double pVal;
  final double kVal;
  final String? insightText;

  const NpkSummaryCard({
    super.key,
    required this.nVal,
    required this.pVal,
    required this.kVal,
    this.insightText,
  });

  String _getNpkStatus() {
    if (insightText != null && insightText!.isNotEmpty) return insightText!;
    if (nVal > 60) return 'Kadar N Tinggi';
    if (nVal < 20) return 'Kadar N Rendah';
    if (pVal < 15) return 'Defisiensi P';
    if (kVal < 20) return 'Defisiensi K';
    return 'Nutrisi Seimbang';
  }

  String _fmtVal(double v) =>
      v > 0 ? (v % 1 == 0 ? v.toInt().toString() : v.toStringAsFixed(1)) : '--';

  @override
  Widget build(BuildContext context) {
    final total = (nVal + pVal + kVal) > 0 ? (nVal + pVal + kVal) : 1.0;
    final nRatio = (nVal / total) * 100;
    final pRatio = (pVal / total) * 100;
    final kRatio = (kVal / total) * 100;
    final status = _getNpkStatus();

    return LiquidGlassPanel(
      padding: EdgeInsets.zero,
      borderRadius: 22,
      child: Stack(
        children: [
          // Cucumber plant photo overlay on right
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
                'assets/images/cucumber_3d.jpg',
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
                // Title
                Text(
                  'Keseimbangan Hara NPK',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 2),
                // Subtitle / status
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF34D399),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      status,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF6EE7B7),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // 3 Metrics
                Row(
                  children: [
                    _buildMetric('N', 'Nitrogen', '${nRatio.toStringAsFixed(0)}%', _fmtVal(nVal), const Color(0xFF34D399)),
                    const SizedBox(width: 14),
                    _buildMetric('P', 'Fosfor',   '${pRatio.toStringAsFixed(0)}%', _fmtVal(pVal), const Color(0xFF60A5FA)),
                    const SizedBox(width: 14),
                    _buildMetric('K', 'Kalium',   '${kRatio.toStringAsFixed(0)}%', _fmtVal(kVal), const Color(0xFFC084FC)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(
    String symbol,
    String label,
    String percent,
    String value,
    Color accent,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Symbol icon circle
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
          child: Text(
            symbol,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11.5,
              fontWeight: FontWeight.w900,
              color: accent,
              height: 1,
            ),
          ),
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
          percent,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11.5,
            fontWeight: FontWeight.w800,
            color: accent,
            letterSpacing: -0.3,
            height: 1.2,
          ),
        ),
        Text(
          '$value mg/kg',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            color: Colors.white70,
            height: 1.1,
          ),
        ),
      ],
    );
  }
}
