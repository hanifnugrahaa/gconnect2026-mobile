import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/constants.dart';

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

  @override
  Widget build(BuildContext context) {
    final total = nVal + pVal + kVal;
    final nRatio = total > 0 ? (nVal / total) * 100 : 33.3;
    final pRatio = total > 0 ? (pVal / total) * 100 : 33.3;
    final kRatio = total > 0 ? (kVal / total) * 100 : 33.4;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(LucideIcons.flaskConical, size: 16, color: AppColors.nitrogen),
                  SizedBox(width: 6),
                  Text(
                    'Keseimbangan Hara NPK',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  insightText ?? 'Seimbang & Subur',
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 3 Column Values with Soft Tinted Pill Boxes
          Row(
            children: [
              _buildNpkItem('Nitrogen (N)', nVal, nRatio, AppColors.nitrogen),
              const SizedBox(width: 8),
              _buildNpkItem('Phosphor (P)', pVal, pRatio, AppColors.phosphorus),
              const SizedBox(width: 8),
              _buildNpkItem('Kalium (K)', kVal, kRatio, AppColors.potassium),
            ],
          ),
          const SizedBox(height: 12),

          // Segmented Distribution Multi-Color Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              height: 7,
              child: Row(
                children: [
                  Expanded(flex: nRatio.round().clamp(1, 100), child: Container(color: AppColors.nitrogen)),
                  const SizedBox(width: 2),
                  Expanded(flex: pRatio.round().clamp(1, 100), child: Container(color: AppColors.phosphorus)),
                  const SizedBox(width: 2),
                  Expanded(flex: kRatio.round().clamp(1, 100), child: Container(color: AppColors.potassium)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNpkItem(String title, double val, double percent, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.15)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title.split(' ')[0],
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: color),
                ),
                Text(
                  '${percent.toStringAsFixed(0)}%',
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: color),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              val > 0 ? val.toStringAsFixed(1) : '--',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
            ),
            const Text(
              'mg/kg',
              style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}
