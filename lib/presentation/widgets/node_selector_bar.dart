import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../models/node_model.dart';

class NodeSelectorBar extends StatelessWidget {
  final List<NodeModel> nodes;
  final String? selectedNodeId;
  final Function(String) onSelect;

  const NodeSelectorBar({
    super.key,
    required this.nodes,
    required this.selectedNodeId,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    if (nodes.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: nodes.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, idx) {
          final node = nodes[idx];
          final isSelected = node.id == selectedNodeId;
          final isOnline = node.status.toLowerCase() == 'online';

          return InkWell(
            onTap: () => onSelect(node.id),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.border,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: isOnline ? AppColors.success : AppColors.danger,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    node.name,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
