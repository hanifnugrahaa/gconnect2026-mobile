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
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.68),
                Colors.white.withOpacity(0.42),
                const Color(0xFFECFDF5).withOpacity(0.55),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.92),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF10B981).withOpacity(0.12),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: const Color(0xFF38BDF8).withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              // 1. 3D Cucumber Plant Ambient Vignette
              Positioned(
                right: -10,
                bottom: -15,
                child: Opacity(
                  opacity: 0.26,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/images/cucumber_3d.jpg',
                      width: 130,
                      height: 130,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              // 2. 3D Liquid Glass Orb 1 (Top Left Emerald Orb)
              Positioned(
                left: -12,
                top: -12,
                child: _build3dLiquidGlassOrb(
                  size: 84,
                  primaryColor: const Color(0xFF10B981),
                  highlightColor: const Color(0xFF6EE7B7),
                ),
              ),

              // 3. 3D Liquid Glass Orb 2 (Top Right Sapphire Blue Orb)
              Positioned(
                right: -8,
                top: -8,
                child: _build3dLiquidGlassOrb(
                  size: 74,
                  primaryColor: const Color(0xFF3B82F6),
                  highlightColor: const Color(0xFF93C5FD),
                ),
              ),

              // Top Glossy Light Highlight Sheen
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 42,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withOpacity(0.50),
                        Colors.white.withOpacity(0.0),
                      ],
                    ),
                  ),
                ),
              ),

              // Main Card Content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10.5),
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
                              padding: const EdgeInsets.all(5.5),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white.withOpacity(0.95),
                                    const Color(0xFFD1FAE5).withOpacity(0.85),
                                  ],
                                ),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1.2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF008F00).withOpacity(0.20),
                                    blurRadius: 8,
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
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF475569),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        // Liquid Glass Status Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8.5, vertical: 3.5),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.90),
                                Colors.white.withOpacity(0.70),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white,
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: dotColor.withOpacity(0.20),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: dotColor,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: dotColor.withOpacity(0.8),
                                      blurRadius: 5,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                statusText,
                                style: TextStyle(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w900,
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
                          tintColor: const Color(0xFF10B981),
                        ),
                        const SizedBox(width: 6.5),
                        _buildLiquidGlassItem(
                          symbol: 'P',
                          title: 'Fosfor',
                          val: pVal,
                          percent: pRatio,
                          accentColor: const Color(0xFF2563EB),
                          tintColor: const Color(0xFF3B82F6),
                        ),
                        const SizedBox(width: 6.5),
                        _buildLiquidGlassItem(
                          symbol: 'K',
                          title: 'Kalium',
                          val: kVal,
                          percent: kRatio,
                          accentColor: const Color(0xFF9333EA),
                          tintColor: const Color(0xFFA855F7),
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
                          color: Colors.white.withOpacity(0.55),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.80),
                            width: 0.8,
                          ),
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
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF10B981).withOpacity(0.3),
                                      blurRadius: 3,
                                    ),
                                  ],
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
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF3B82F6).withOpacity(0.3),
                                      blurRadius: 3,
                                    ),
                                  ],
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
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFA855F7).withOpacity(0.3),
                                      blurRadius: 3,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
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
    required Color tintColor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.78),
              tintColor.withOpacity(0.12),
              Colors.white.withOpacity(0.55),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white,
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: accentColor.withOpacity(0.10),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 3,
              offset: const Offset(0, 1),
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
                    gradient: LinearGradient(
                      colors: [
                        accentColor,
                        tintColor,
                      ],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withOpacity(0.40),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
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
                      fontWeight: FontWeight.w900,
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

  Widget _build3dLiquidGlassOrb({
    required double size,
    required Color primaryColor,
    required Color highlightColor,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // 1. 3D Volumetric Sphere Radial Gradient with Off-center Light Source
        gradient: RadialGradient(
          center: const Alignment(-0.38, -0.38),
          radius: 0.85,
          colors: [
            Colors.white.withOpacity(0.88), // Specular light reflection on top-left
            highlightColor.withOpacity(0.55), // Luminous refraction body
            primaryColor.withOpacity(0.38),    // Core ambient body
            primaryColor.withOpacity(0.12),    // Outer edge falloff
          ],
          stops: const [0.0, 0.28, 0.65, 1.0],
        ),
        // 2. Liquid Glass Diffuse Ambient Glow & Drop Shadow
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.35),
            blurRadius: size * 0.35,
            spreadRadius: size * 0.04,
            offset: const Offset(3, 6),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.70),
            blurRadius: size * 0.18,
            offset: const Offset(-2, -2),
          ),
        ],
        // 3. Specular Rim Glass Border
        border: Border.all(
          color: Colors.white.withOpacity(0.65),
          width: 1.2,
        ),
      ),
      child: ClipOval(
        child: Stack(
          children: [
            // Inner Specular Light Glint Arc (Apple VisionOS / Liquid Glass highlight)
            Positioned(
              top: size * 0.12,
              left: size * 0.16,
              child: Transform.rotate(
                angle: -0.42,
                child: Container(
                  width: size * 0.36,
                  height: size * 0.16,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.elliptical(size * 0.36, size * 0.16)),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withOpacity(0.90),
                        Colors.white.withOpacity(0.0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Bottom-Right Refractive Counter-Glow
            Positioned(
              bottom: size * 0.08,
              right: size * 0.12,
              child: Container(
                width: size * 0.30,
                height: size * 0.14,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.elliptical(size * 0.30, size * 0.14)),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      highlightColor.withOpacity(0.50),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
