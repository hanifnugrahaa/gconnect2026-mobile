import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

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

  Color _getStatusDotColor() {
    final status = _getNpkStatus();
    if (status.contains('Tinggi') || status.contains('Kritis')) return const Color(0xFFE11D48);
    if (status.contains('Rendah') || status.contains('Defisiensi')) return const Color(0xFFF59E0B);
    return const Color(0xFF10B981);
  }

  Color _getStatusText() {
    final status = _getNpkStatus();
    if (status.contains('Tinggi') || status.contains('Kritis')) return const Color(0xFFBE123C);
    if (status.contains('Rendah') || status.contains('Defisiensi')) return const Color(0xFFB45309);
    return const Color(0xFF047857);
  }

  @override
  Widget build(BuildContext context) {
    final total = (nVal + pVal + kVal) > 0 ? (nVal + pVal + kVal) : 1.0;
    final nRatio = (nVal / total) * 100;
    final pRatio = (pVal / total) * 100;
    final kRatio = (kVal / total) * 100;

    final statusText = _getNpkStatus();
    final dotColor = _getStatusDotColor();

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10.5),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.92),
                const Color(0xFFF8FAFC).withOpacity(0.85),
                const Color(0xFFF0FDF4).withOpacity(0.80),
              ],
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Colors.white.withOpacity(0.90),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF10B981).withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Liquid Ambient Glow Blobs
              Positioned(
                right: -20,
                top: -20,
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF60A5FA).withOpacity(0.12),
                  ),
                ),
              ),
              Positioned(
                left: -15,
                bottom: -20,
                child: Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF34D399).withOpacity(0.12),
                  ),
                ),
              ),

              Column(
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
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFFECFDF5),
                                  const Color(0xFFD1FAE5).withOpacity(0.8),
                                ],
                              ),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF008F00).withOpacity(0.12),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(LucideIcons.flaskConical, size: 13, color: Color(0xFF008F00)),
                          ),
                          const SizedBox(width: 7),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Keseimbangan Hara NPK',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF0F172A),
                                  letterSpacing: -0.3,
                                ),
                              ),
                              Text(
                                'Rasio N:P:K  ${nVal.toStringAsFixed(0)} : ${pVal.toStringAsFixed(0)} : ${kVal.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // Liquid Glass Status Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.75),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.95),
                            width: 0.9,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: dotColor.withOpacity(0.15),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 5.5,
                              height: 5.5,
                              decoration: BoxDecoration(
                                color: dotColor,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: dotColor.withOpacity(0.6),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 4.5),
                            Text(
                              statusText,
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w800,
                                color: _getStatusText(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.5),

                  // 3 Column Values with Liquid Glass Micro-Pills
                  Row(
                    children: [
                      _buildLiquidGlassItem(
                        symbol: 'N',
                        title: 'Nitrogen',
                        val: nVal,
                        percent: nRatio,
                        accentColor: const Color(0xFF059669),
                        gradient: [
                          const Color(0xFFF0FDF4).withOpacity(0.90),
                          const Color(0xFFDCFCE7).withOpacity(0.50),
                        ],
                      ),
                      const SizedBox(width: 6.5),
                      _buildLiquidGlassItem(
                        symbol: 'P',
                        title: 'Fosfor',
                        val: pVal,
                        percent: pRatio,
                        accentColor: const Color(0xFF2563EB),
                        gradient: [
                          const Color(0xFFEFF6FF).withOpacity(0.90),
                          const Color(0xFFDBEAFE).withOpacity(0.50),
                        ],
                      ),
                      const SizedBox(width: 6.5),
                      _buildLiquidGlassItem(
                        symbol: 'K',
                        title: 'Kalium',
                        val: kVal,
                        percent: kRatio,
                        accentColor: const Color(0xFF9333EA),
                        gradient: [
                          const Color(0xFFFAF5FF).withOpacity(0.90),
                          const Color(0xFFF3E8FF).withOpacity(0.50),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 7.5),

                  // Liquid Segmented Distribution Track
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      height: 5.5,
                      padding: const EdgeInsets.all(0.5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2E8F0).withOpacity(0.4),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: nRatio.round().clamp(1, 100),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF34D399), Color(0xFF059669)],
                                ),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                          const SizedBox(width: 2),
                          Expanded(
                            flex: pRatio.round().clamp(1, 100),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF60A5FA), Color(0xFF2563EB)],
                                ),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                          const SizedBox(width: 2),
                          Expanded(
                            flex: kRatio.round().clamp(1, 100),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFC084FC), Color(0xFF9333EA)],
                                ),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLiquidGlassItem({
    required String symbol,
    required String title,
    required double val,
    required double percent,
    required Color accentColor,
    required List<Color> gradient,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradient,
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withOpacity(0.95),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: accentColor.withOpacity(0.06),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Row: Chemical Symbol Avatar + Title + Percent Chip
            Row(
              children: [
                Container(
                  width: 14,
                  height: 14,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: accentColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withOpacity(0.35),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                  child: Text(
                    symbol,
                    style: const TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 1,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w800,
                      color: accentColor,
                    ),
                  ),
                ),
                Text(
                  '${percent.toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 8.5,
                    fontWeight: FontWeight.w900,
                    color: accentColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 3),

            // Bottom Row: Value + Unit
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  val > 0 ? (val % 1 == 0 ? val.toInt().toString() : val.toStringAsFixed(1)) : '--',
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF0F172A),
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(width: 2.5),
                const Text(
                  'mg/kg',
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
