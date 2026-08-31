import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
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
    final statusBg = isOnline ? const Color(0xFFECFDF5) : const Color(0xFFFFF1F2);
    final statusBorder = isOnline ? const Color(0xFFA7F3D0) : const Color(0xFFFECDD3);
    final statusColor = isOnline ? const Color(0xFF047857) : const Color(0xFFE11D48);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Code Badge + Live Status Badge + Timestamp
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // Node Code Pill
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: const Color(0xFFBBF7D0),
                        width: 0.8,
                      ),
                    ),
                    child: Text(
                      displayCode,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF047857),
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 7),

                  // Online/Offline Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7.5, vertical: 3),
                    decoration: BoxDecoration(
                      color: statusBg,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: statusBorder,
                        width: 0.8,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 5.5,
                          height: 5.5,
                          decoration: BoxDecoration(
                            color: statusColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4.5),
                        Text(
                          isOnline ? 'LIVE STREAMING' : 'OFFLINE',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: statusColor,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Timestamp with Clock Icon
              Row(
                children: [
                  const Icon(LucideIcons.clock, size: 11, color: Color(0xFF64748B)),
                  const SizedBox(width: 4),
                  Text(
                    'WIB $nowFormatted',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Station Name & Switch Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  node.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF0F172A),
                    letterSpacing: -0.3,
                  ),
                ),
              ),
              if (allNodes.length > 1) ...[
                PopupMenuButton<String>(
                  onSelected: onSelectNode,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.5, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFFE2E8F0),
                        width: 1,
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(LucideIcons.arrowLeftRight, size: 11.5, color: Color(0xFF475569)),
                        SizedBox(width: 4),
                        Text(
                          'Ganti',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF475569),
                          ),
                        ),
                      ],
                    ),
                  ),
                  itemBuilder: (context) => allNodes.map((n) {
                    final nodeOnline = n.status.toLowerCase() == 'online';
                    return PopupMenuItem<String>(
                      value: n.id,
                      child: Row(
                        children: [
                          Container(
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              color: nodeOnline ? const Color(0xFF10B981) : const Color(0xFFE11D48),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            n.name,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                          ),
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
