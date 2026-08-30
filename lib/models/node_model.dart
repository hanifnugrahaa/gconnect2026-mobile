import 'sensor_model.dart';

class NodeModel {
  final String id;
  final String nodeCode;
  final String name;
  final String? description;
  final String status;
  final double? latitude;
  final double? longitude;
  final List<SensorModel> sensors;

  NodeModel({
    required this.id,
    required this.nodeCode,
    required this.name,
    this.description,
    required this.status,
    this.latitude,
    this.longitude,
    required this.sensors,
  });

  factory NodeModel.fromJson(Map<String, dynamic> json) {
    final rawSensors = json['sensors'] as List<dynamic>? ?? [];
    return NodeModel(
      id: json['id']?.toString() ?? '',
      nodeCode: json['node_id'] ?? json['node_code'] ?? '',
      name: json['name'] ?? 'Stasiun Agro',
      description: json['description'],
      status: json['status'] ?? 'offline',
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      sensors: rawSensors.map((s) => SensorModel.fromJson(s as Map<String, dynamic>)).toList(),
    );
  }
}
