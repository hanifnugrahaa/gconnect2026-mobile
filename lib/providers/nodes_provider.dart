import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/node_model.dart';
import '../models/sensor_model.dart';
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
      if (list.isNotEmpty) {
        state = NodesState(
          isLoading: false,
          nodes: list,
          selectedNodeId: state.selectedNodeId ?? list.first.id,
        );
      } else {
        _loadFallbackNodes();
      }
    } catch (e) {
      _loadFallbackNodes(error: 'Gagal terhubung ke backend (Offline). Menampilkan data demo.');
    }
  }

  void _loadFallbackNodes({String? error}) {
    final demoNode = NodeModel(
      id: 'demo-node-001',
      nodeCode: 'NODE001',
      name: 'IoT Lab ELINS (Demo)',
      description: 'Stasiun telemetri lahan presisi',
      status: 'online',
      latitude: -7.7713,
      longitude: 110.3775,
      sensors: [
        SensorModel(id: '1', name: 'Nitrogen (N)', type: 'npk', unit: 'mg/kg'),
        SensorModel(id: '2', name: 'Phosphorus (P)', type: 'npk', unit: 'mg/kg'),
        SensorModel(id: '3', name: 'Potassium (K)', type: 'npk', unit: 'mg/kg'),
        SensorModel(id: '4', name: 'Kelembaban Tanah 1', type: 'soil', unit: '%'),
        SensorModel(id: '5', name: 'Kelembaban Tanah 2', type: 'soil', unit: '%'),
        SensorModel(id: '6', name: 'pH Tanah', type: 'soil', unit: 'pH'),
        SensorModel(id: '7', name: 'EC Tanah (Konduktivitas)', type: 'soil', unit: 'uS/cm'),
        SensorModel(id: '8', name: 'Suhu Tanah', type: 'soil', unit: '°C'),
        SensorModel(id: '9', name: 'Suhu Lingkungan', type: 'environment', unit: '°C'),
        SensorModel(id: '10', name: 'Kelembaban Udara', type: 'environment', unit: '%'),
        SensorModel(id: '11', name: 'Suhu Boks IoT', type: 'environment', unit: '°C'),
        SensorModel(id: '12', name: 'Tegangan Baterai', type: 'environment', unit: 'V'),
      ],
    );

    state = NodesState(
      isLoading: false,
      nodes: [demoNode],
      selectedNodeId: demoNode.id,
      errorMessage: error,
    );
  }

  void selectNode(String id) {
    state = state.copyWith(selectedNodeId: id);
  }
}

final nodesProvider = StateNotifierProvider<NodesNotifier, NodesState>((ref) {
  return NodesNotifier();
});
