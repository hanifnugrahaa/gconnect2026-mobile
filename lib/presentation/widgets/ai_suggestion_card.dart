import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'liquid_glass_panel.dart';

class AiSuggestionCard extends StatelessWidget {
  final double? nVal;
  final double? pVal;
  final double? kVal;
  final double? soilMoisture;
  final double? boxTemp;
  final VoidCallback? onDosingTap;
  final VoidCallback? onIrrigationTap;
  final VoidCallback? onThermalTap;

  const AiSuggestionCard({
    super.key,
    this.nVal,
    this.pVal,
    this.kVal,
    this.soilMoisture,
    this.boxTemp,
    this.onDosingTap,
    this.onIrrigationTap,
    this.onThermalTap,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Determine NPK Suggestion
    String npkTitle = 'Pemupukan NPK';
    String npkDesc = nVal != null ? 'Nutrisi tanah dalam batas seimbang.' : 'Menunggu pembacaan sensor NPK...';
    Color npkColor = const Color(0xFF10B981);
    if (nVal != null && nVal! < 20) {
      npkTitle = 'Tambah Pupuk Urea (N)';
      npkDesc = 'Kadar Nitrogen rendah (${nVal!.toStringAsFixed(0)} mg/kg). Tambah pupuk N.';
      npkColor = const Color(0xFFF59E0B);
    } else if (nVal != null && nVal! > 60) {
      npkTitle = 'Kurangi Dosis Nitrogen';
      npkDesc = 'Kadar N tinggi (${nVal!.toStringAsFixed(0)} mg/kg). Cegah pertumbuhan vegetatif berlebih.';
      npkColor = const Color(0xFFF43F5E);
    } else if (pVal != null && pVal! < 15) {
      npkTitle = 'Aplikasi Pupuk Fosfor (P)';
      npkDesc = 'Defisiensi P (${pVal!.toStringAsFixed(0)} mg/kg). Diperlukan untuk perakaran.';
      npkColor = const Color(0xFF3B82F6);
    } else if (kVal != null && kVal! < 20) {
      npkTitle = 'Aplikasi Pupuk Kalium (K)';
      npkDesc = 'Defisiensi K (${kVal!.toStringAsFixed(0)} mg/kg). Diperlukan untuk pembentukan buah.';
      npkColor = const Color(0xFFEC4899);
    }

    // 2. Determine Irrigation Suggestion
    String irrTitle = 'Irigasi Tanah';
    String irrDesc = soilMoisture != null
        ? 'Kelembaban media optimal (${soilMoisture!.toStringAsFixed(1)}%).'
        : 'Menunggu sensor lengas tanah...';
    Color irrColor = const Color(0xFF06B6D4);
    if (soilMoisture != null && soilMoisture! < 30) {
      irrTitle = 'Jadwal Siram Diperlukan';
      irrDesc = 'Tanah kering (${soilMoisture!.toStringAsFixed(1)}%). Segera lakukan irigasi tetes.';
      irrColor = const Color(0xFFF59E0B);
    } else if (soilMoisture != null && soilMoisture! > 85) {
      irrTitle = 'Tanah Jenuh Air';
      irrDesc = 'Kelembaban tinggi (${soilMoisture!.toStringAsFixed(1)}%). Tunda penyiraman.';
      irrColor = const Color(0xFF6366F1);
    }

    // 3. Determine Thermal / Climate Suggestion
    String thermTitle = 'Iklim Mikro & Boks';
    String thermDesc = boxTemp != null
        ? 'Suhu boks ${boxTemp!.toStringAsFixed(1)}°C aman (< 55°C).'
        : 'Menunggu telemetri suhu panel...';
    Color thermColor = const Color(0xFF10B981);
    if (boxTemp != null && boxTemp! > 45) {
      thermTitle = 'Suhu Boks IoT Tinggi';
      thermDesc = 'Suhu mencapai ${boxTemp!.toStringAsFixed(1)}°C. Periksa exhaust fan.';
      thermColor = const Color(0xFFEF4444);
    }

    return LiquidGlassPanel(
      padding: const EdgeInsets.all(16),
      borderRadius: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Today's AI Suggestion",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.3,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.18),
                    width: 0.8,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      LucideIcons.sparkles,
                      size: 11,
                      color: const Color(0xFF34D399),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Smart AI',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF6EE7B7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 3 Action Tile Items
          _buildActionItem(
            icon: LucideIcons.sprout,
            iconBg: npkColor.withOpacity(0.20),
            iconColor: npkColor,
            title: npkTitle,
            subtitle: npkDesc,
            onTap: onDosingTap,
          ),
          const SizedBox(height: 9),
          _buildActionItem(
            icon: LucideIcons.droplets,
            iconBg: irrColor.withOpacity(0.20),
            iconColor: irrColor,
            title: irrTitle,
            subtitle: irrDesc,
            onTap: onIrrigationTap,
          ),
          const SizedBox(height: 9),
          _buildActionItem(
            icon: LucideIcons.cpu,
            iconBg: thermColor.withOpacity(0.20),
            iconColor: thermColor,
            title: thermTitle,
            subtitle: thermDesc,
            onTap: onThermalTap,
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
          width: 0.8,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                // Icon Capsule
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: iconBg,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: iconColor.withOpacity(0.35),
                      width: 1,
                    ),
                  ),
                  child: Icon(icon, size: 16, color: iconColor),
                ),
                const SizedBox(width: 12),

                // Text details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 1.5),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // Chevron icon
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    LucideIcons.chevronRight,
                    size: 13,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
