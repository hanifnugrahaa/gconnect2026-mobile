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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(LucideIcons.flaskConical, size: 15, color: AppColors.nitrogen),
                  SizedBox(width: 6),
                  Text(
                    'Keseimbangan Hara NPK',
                    style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  insightText ?? 'Seimbang & Subur',
                  style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // 3 Column Values
          Row(
            children: [
              _buildNpkItem('Nitrogen', nVal, nRatio, AppColors.nitrogen),
              const SizedBox(width: 6),
              _buildNpkItem('Phosphor', pVal, pRatio, AppColors.phosphorus),
              const SizedBox(width: 6),
              _buildNpkItem('Kalium', kVal, kRatio, AppColors.potassium),
            ],
          ),
          const SizedBox(height: 8),

          // Segmented Distribution Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              height: 5,
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
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.06),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.15)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: color),
                ),
                Text(
                  '${percent.toStringAsFixed(0)}%',
                  style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.w800, color: color),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              val > 0 ? val.toStringAsFixed(1) : '--',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}
