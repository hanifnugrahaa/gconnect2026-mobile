import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/node_model.dart';
import 'liquid_glass_panel.dart';
import 'event_logs_bottom_sheet.dart';

class StationHeroHeader extends StatelessWidget {
  final NodeModel node;
  final List<NodeModel> allNodes;
  final Function(String) onSelectNode;
  final double? ambientTemp;
  final double? ambientHumidity;

  const StationHeroHeader({
    super.key,
    required this.node,
    required this.allNodes,
    required this.onSelectNode,
    this.ambientTemp,
    this.ambientHumidity,
  });

  void _showStationPickerBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF071B13),
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            border: Border(
              top: BorderSide(color: Color(0xFF10B981), width: 1.2),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag Handle
              Center(
                child: Container(
                  width: 38,
                  height: 4.5,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),

              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withOpacity(0.18),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(0xFF10B981).withOpacity(0.35),
                            width: 0.8,
                          ),
                        ),
                        child: const Icon(
                          LucideIcons.radio,
                          size: 18,
                          color: Color(0xFF34D399),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pilih Stasiun / Plot',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '${allNodes.length} stasiun IoT terdaftar',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(ctx).pop(),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(LucideIcons.x, size: 16, color: Colors.white70),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // List of Nodes
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.45,
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: allNodes.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 9),
                  itemBuilder: (context, idx) {
                    final item = allNodes[idx];
                    final isSelected = item.id == node.id;
                    final itemOnline = item.status.toLowerCase() == 'online';

                    return GestureDetector(
                      onTap: () {
                        onSelectNode(item.id);
                        Navigator.of(ctx).pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF10B981).withOpacity(0.18)
                              : Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF34D399)
                                : Colors.white.withOpacity(0.08),
                            width: isSelected ? 1.4 : 0.8,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: itemOnline ? const Color(0xFF34D399) : const Color(0xFFF43F5E),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    item.location ?? 'Greenhouse Pertanian',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 10.5,
                                      color: const Color(0xFF94A3B8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              const Icon(LucideIcons.circleCheck, size: 18, color: Color(0xFF34D399)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isOnline = node.status.toLowerCase() == 'online';
    final nowFormatted = DateFormat('EEEE, d MMM yyyy').format(DateTime.now());
    final displayTemp = ambientTemp ?? 30.5;
    final displayHum = ambientHumidity ?? 68.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── TOP BAR: Station Capsule Dropdown + Profile Icons ──────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Station Selector Capsule
            GestureDetector(
              onTap: () => _showStationPickerBottomSheet(context),
              child: LiquidGlassPanel(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                borderRadius: 30,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Live Dot
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: isOnline ? const Color(0xFF34D399) : const Color(0xFFF43F5E),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: (isOnline ? const Color(0xFF34D399) : const Color(0xFFF43F5E)).withOpacity(0.8),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Node name
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 150),
                      child: Text(
                        node.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),

                    const Icon(LucideIcons.chevronDown, size: 14, color: Colors.white70),
                  ],
                ),
              ),
            ),

            // Top Right Action Buttons
            Row(
              children: [
                // Notification Bell
                LiquidGlassPanel(
                  onTap: () => showEventLogsBottomSheet(context),
                  padding: const EdgeInsets.all(9),
                  borderRadius: 30,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(LucideIcons.bell, size: 16, color: Colors.white),
                      Positioned(
                        right: -2,
                        top: -2,
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF59E0B),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // Avatar
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF34D399), width: 1.5),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/cucumber_3d.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 18),

        // ── HERO METRIC SECTION (Cultiveq Style) ──────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Left: Date & Big Temperature Typography
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nowFormatted,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFA7F3D0),
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ambientTemp != null ? ambientTemp!.toStringAsFixed(0) : '--',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 52,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        height: 1.0,
                        letterSpacing: -2,
                      ),
                    ),
                    Text(
                      '°C',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF6EE7B7),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Right: Micro-Climate Capsule
            LiquidGlassPanel(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              borderRadius: 18,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(LucideIcons.sun, size: 14, color: Color(0xFFFCD34D)),
                      const SizedBox(width: 5),
                      Text(
                        ambientHumidity != null ? 'Lembab ${ambientHumidity!.toStringAsFixed(0)}%' : 'Lembab --%',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Builder(
                    builder: (context) {
                      String climateStatus = 'Zona Tumbuh Optimal';
                      Color climateColor = const Color(0xFF6EE7B7);
                      if (ambientTemp != null && ambientTemp! > 34.0) {
                        climateStatus = 'Suhu Udara Panas';
                        climateColor = const Color(0xFFF43F5E);
                      } else if (ambientTemp != null && ambientTemp! < 20.0) {
                        climateStatus = 'Suhu Udara Dingin';
                        climateColor = const Color(0xFF38BDF8);
                      } else if (ambientHumidity != null && ambientHumidity! < 40.0) {
                        climateStatus = 'Udara Kering';
                        climateColor = const Color(0xFFF59E0B);
                      } else if (ambientHumidity != null && ambientHumidity! > 85.0) {
                        climateStatus = 'Kelembaban Jenuh';
                        climateColor = const Color(0xFFA78BFA);
                      }

                      return Text(
                        climateStatus,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w600,
                          color: climateColor,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
