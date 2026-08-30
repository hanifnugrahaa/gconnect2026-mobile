import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/constants.dart';
import '../../models/node_model.dart';

class StationHeroHeader extends StatelessWidget {
  final NodeModel node;
  final List<NodeModel> allNodes;
  final Function(String) onSelectNode;

  const StationHeroHeader({
    super.key,
    required this.node,
    required this.allNodes,
    required this.onSelectNode,
  });

  @override
  Widget build(BuildContext context) {
    final isOnline = node.status.toLowerCase() == 'online';
    final nowFormatted = DateFormat('HH:mm').format(DateTime.now());
    final displayCode = node.nodeCode.isNotEmpty ? node.nodeCode : 'NODE-01';

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Station Code & Status Indicator
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBg,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.primaryLight.withOpacity(0.3)),
                    ),
                    child: Text(
                      displayCode,
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: (isOnline ? AppColors.success : AppColors.danger).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: isOnline ? AppColors.success : AppColors.danger,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          isOnline ? 'LIVE STREAMING' : 'OFFLINE',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: isOnline ? AppColors.success : AppColors.danger,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Time Stamp Indicator
              Text(
                'WIB $nowFormatted',
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textMuted),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Station Name
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  node.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
              if (allNodes.length > 1) ...[
                PopupMenuButton<String>(
                  onSelected: onSelectNode,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Row(
                      children: [
                        Icon(LucideIcons.arrowLeftRight, size: 12, color: AppColors.textSecondary),
                        SizedBox(width: 4),
                        Text('Ganti', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  itemBuilder: (context) => allNodes.map((n) {
                    return PopupMenuItem<String>(
                      value: n.id,
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: n.status.toLowerCase() == 'online' ? AppColors.success : AppColors.danger,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(n.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
