import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

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
    if (boxTemp > 45) return const Color(0xFFE11D48);
    return const Color(0xFF10B981);
  }

  @override
  Widget build(BuildContext context) {
    final boxTemp = enclosureTemp ?? 32.4;
    final airTemp = ambientTemp ?? 28.1;
    final airHum = ambientHumidity ?? 72.0;
    final volt = batteryVolt ?? 12.6;

    final statusText = _getThermalStatus(boxTemp);
    final statusColor = _getStatusColor(boxTemp);

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
                const Color(0xFFFFF1F2).withOpacity(0.55),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.92),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFB7185).withOpacity(0.12),
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
              // 3D Liquid Glass Orb 1 (Top Left Rose Solar Orb)
              Positioned(
                left: -12,
                top: -12,
                child: _build3dLiquidGlassOrb(
                  size: 88,
                  primaryColor: const Color(0xFFF43F5E),
                  highlightColor: const Color(0xFFFDA4AF),
                ),
              ),

              // 3D Liquid Glass Orb 2 (Top Right Sky Blue Ambient Orb)
              Positioned(
                right: -8,
                top: -8,
                child: _build3dLiquidGlassOrb(
                  size: 78,
                  primaryColor: const Color(0xFF0284C7),
                  highlightColor: const Color(0xFF7DD3FC),
                ),
              ),

              // 3D Liquid Glass Orb 3 (Bottom Emerald Battery Orb)
              Positioned(
                right: 46,
                bottom: -18,
                child: _build3dLiquidGlassOrb(
                  size: 84,
                  primaryColor: const Color(0xFF10B981),
                  highlightColor: const Color(0xFF6EE7B7),
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
                                    const Color(0xFFFFE4E6).withOpacity(0.85),
                                  ],
                                ),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1.2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFE11D48).withOpacity(0.20),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(LucideIcons.cpu, size: 13, color: Color(0xFFE11D48)),
                            ),
                            const SizedBox(width: 7),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Status Termal & Boks IoT',
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF0F172A),
                                    letterSpacing: -0.3,
                                  ),
                                ),
                                Text(
                                  'Enclosure & Suhu Lingkungan',
                                  style: TextStyle(
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
                                color: statusColor.withOpacity(0.20),
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
                                  color: statusColor,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: statusColor.withOpacity(0.8),
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
                                  color: statusColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.5),

                    // 4 Grid KPI Values with Liquid Glass Micro-Cells
                    Row(
                      children: [
                        _buildLiquidThermalItem(
                          icon: LucideIcons.cpu,
                          title: 'Boks Panel',
                          val: '${boxTemp.toStringAsFixed(1)}°C',
                          accentColor: const Color(0xFFE11D48),
                          tintColor: const Color(0xFFFB7185),
                        ),
                        const SizedBox(width: 5.5),
                        _buildLiquidThermalItem(
                          icon: LucideIcons.sun,
                          title: 'Suhu Udara',
                          val: '${airTemp.toStringAsFixed(1)}°C',
                          accentColor: const Color(0xFFEA580C),
                          tintColor: const Color(0xFFFB923C),
                        ),
                        const SizedBox(width: 5.5),
                        _buildLiquidThermalItem(
                          icon: LucideIcons.wind,
                          title: 'Kelembaban',
                          val: '${airHum.toStringAsFixed(0)}%',
                          accentColor: const Color(0xFF0284C7),
                          tintColor: const Color(0xFF38BDF8),
                        ),
                        const SizedBox(width: 5.5),
                        _buildLiquidThermalItem(
                          icon: LucideIcons.batteryCharging,
                          title: 'Tegangan',
                          val: '${volt.toStringAsFixed(1)} V',
                          accentColor: const Color(0xFF059669),
                          tintColor: const Color(0xFF34D399),
                        ),
                      ],
                    ),
                    const SizedBox(height: 7.5),

                    // Liquid Thermal Safe Zone Track Indicator (<55 safe)
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
                              flex: ((boxTemp / 60.0) * 100).clamp(5, 100).round(),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: boxTemp > 45
                                        ? [const Color(0xFFFB7185), const Color(0xFFE11D48)]
                                        : [const Color(0xFF34D399), const Color(0xFF059669)],
                                  ),
                                  borderRadius: BorderRadius.circular(3),
                                  boxShadow: [
                                    BoxShadow(
                                      color: (boxTemp > 45 ? const Color(0xFFE11D48) : const Color(0xFF059669)).withOpacity(0.35),
                                      blurRadius: 3,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: (100 - ((boxTemp / 60.0) * 100).clamp(5, 100)).round(),
                              child: const SizedBox.shrink(),
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

  Widget _buildLiquidThermalItem({
    required IconData icon,
    required String title,
    required String val,
    required Color accentColor,
    required Color tintColor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5.5, vertical: 5),
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
            // Top Row: Mini Icon + Title
            Row(
              children: [
                Icon(icon, size: 10, color: accentColor),
                const SizedBox(width: 3),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: accentColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 3),

            // Value Text
            Text(
              val,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w900,
                color: Color(0xFF0F172A),
                letterSpacing: -0.3,
              ),
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
