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

  Color _getStatusBg() {
    final status = _getNpkStatus();
    if (status.contains('Tinggi') || status.contains('Kritis')) return const Color(0xFFFFF1F2);
    if (status.contains('Rendah') || status.contains('Defisiensi')) return const Color(0xFFFEF3C7);
    return const Color(0xFFECFDF5);
  }

  Color _getStatusBorder() {
    final status = _getNpkStatus();
    if (status.contains('Tinggi') || status.contains('Kritis')) return const Color(0xFFFECDD3);
    if (status.contains('Rendah') || status.contains('Defisiensi')) return const Color(0xFFFDE68A);
    return const Color(0xFFA7F3D0);
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

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
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
                    padding: const EdgeInsets.all(4.5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECFDF5),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFA7F3D0), width: 0.8),
                    ),
                    child: const Icon(LucideIcons.flaskConical, size: 14, color: Color(0xFF008F00)),
                  ),
                  const SizedBox(width: 7),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Keseimbangan Hara NPK',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0F172A),
                          letterSpacing: -0.2,
                        ),
                      ),
                      Text(
                        'Rasio N:P:K (${nVal.toStringAsFixed(0)}:${pVal.toStringAsFixed(0)}:${kVal.toStringAsFixed(0)})',
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

              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: _getStatusBg(),
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(color: _getStatusBorder(), width: 0.8),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w800,
                    color: _getStatusText(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),

          // 3 Column Values with Web Nuance Styling
          Row(
            children: [
              _buildNpkItem(
                title: 'Nitrogen',
                val: nVal,
                percent: nRatio,
                bgColor: const Color(0xFFF0FDF4),
                borderColor: const Color(0xFFBBF7D0),
                textColor: const Color(0xFF047857),
              ),
              const SizedBox(width: 7),
              _buildNpkItem(
                title: 'Phosphor',
                val: pVal,
                percent: pRatio,
                bgColor: const Color(0xFFEFF6FF),
                borderColor: const Color(0xFFBFDBFE),
                textColor: const Color(0xFF1D4ED8),
              ),
              const SizedBox(width: 7),
              _buildNpkItem(
                title: 'Kalium',
                val: kVal,
                percent: kRatio,
                bgColor: const Color(0xFFFAF5FF),
                borderColor: const Color(0xFFE9D5FF),
                textColor: const Color(0xFF7E22CE),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Segmented Distribution Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              height: 5.5,
              child: Row(
                children: [
                  Expanded(
                    flex: nRatio.round().clamp(1, 100),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFF10B981),
                        borderRadius: BorderRadius.horizontal(left: Radius.circular(3)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 2),
                  Expanded(
                    flex: pRatio.round().clamp(1, 100),
                    child: Container(color: const Color(0xFF3B82F6)),
                  ),
                  const SizedBox(width: 2),
                  Expanded(
                    flex: kRatio.round().clamp(1, 100),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFFA855F7),
                        borderRadius: BorderRadius.horizontal(right: Radius.circular(3)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNpkItem({
    required String title,
    required double val,
    required double percent,
    required Color bgColor,
    required Color borderColor,
    required Color textColor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5.5),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor),
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
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w800,
                    color: textColor,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 3.5, vertical: 0.5),
                  decoration: BoxDecoration(
                    color: textColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${percent.toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w900,
                      color: textColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2.5),
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
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(width: 2.5),
                const Text(
                  'mg/kg',
                  style: TextStyle(
                    fontSize: 8.5,
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
