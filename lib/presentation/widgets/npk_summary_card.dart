import 'package:flutter/material.dart';
import '../../core/constants.dart';

class NpkSummaryCard extends StatelessWidget {
  final double nVal;
  final double pVal;
  final double kVal;

  const NpkSummaryCard({
    super.key,
    required this.nVal,
    required this.pVal,
    required this.kVal,
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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Keseimbangan Hara NPK',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
              ),
              Text(
                'Rasio Ideal',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 3 Column Values
          Row(
            children: [
              _buildNpkItem('Nitrogen (N)', nVal, AppColors.nitrogen),
              _buildDivider(),
              _buildNpkItem('Phosphor (P)', pVal, AppColors.phosphorus),
              _buildDivider(),
              _buildNpkItem('Kalium (K)', kVal, AppColors.potassium),
            ],
          ),
          const SizedBox(height: 14),

          // Distribution Multi-Color Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              height: 8,
              child: Row(
                children: [
                  Expanded(flex: nRatio.round(), child: Container(color: AppColors.nitrogen)),
                  const SizedBox(width: 2),
                  Expanded(flex: pRatio.round(), child: Container(color: AppColors.phosphorus)),
                  const SizedBox(width: 2),
                  Expanded(flex: kRatio.round(), child: Container(color: AppColors.potassium)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNpkItem(String title, double val, Color color) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
              const SizedBox(width: 5),
              Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            val > 0 ? '${val.toStringAsFixed(1)} mg/kg' : '--',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(width: 1, height: 28, color: AppColors.border);
  }
}
