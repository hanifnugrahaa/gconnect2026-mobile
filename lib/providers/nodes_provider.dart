import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/node_model.dart';
import '../services/api_service.dart';

class NodesState {
  final bool isLoading;
  final List<NodeModel> nodes;
  final String? selectedNodeId;
  final String? errorMessage;

  NodesState({
    this.isLoading = false,
    this.nodes = const [],
    this.selectedNodeId,
    this.errorMessage,
  });

  NodeModel? get selectedNode {
    if (nodes.isEmpty) return null;
    if (selectedNodeId == null) return nodes.first;
    try {
      return nodes.firstWhere((n) => n.id == selectedNodeId);
    } catch (_) {
      return nodes.first;
    }
  }

  NodesState copyWith({
    bool? isLoading,
    List<NodeModel>? nodes,
    String? selectedNodeId,
    String? errorMessage,
  }) {
    return NodesState(
      isLoading: isLoading ?? this.isLoading,
      nodes: nodes ?? this.nodes,
      selectedNodeId: selectedNodeId ?? this.selectedNodeId,
      errorMessage: errorMessage,
    );
  }
}

class NodesNotifier extends StateNotifier<NodesState> {
  final ApiService _api = ApiService();

  NodesNotifier() : super(NodesState(isLoading: true)) {
    fetchNodes();
  }

  Future<void> fetchNodes() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final list = await _api.getNodes();
      state = NodesState(
        isLoading: false,
        nodes: list,
        selectedNodeId: state.selectedNodeId ?? (list.isNotEmpty ? list.first.id : null),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  void selectNode(String id) {
    state = state.copyWith(selectedNodeId: id);
  }
}

final nodesProvider = StateNotifierProvider<NodesNotifier, NodesState>((ref) {
  return NodesNotifier();
});
