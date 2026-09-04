class EventLogModel {
  final String id;
  final String level;
  final String message;
  final String? nodeId;
  final String? nodeName;
  final String? nodeCode;
  final DateTime createdAt;

  EventLogModel({
    required this.id,
    required this.level,
    required this.message,
    this.nodeId,
    this.nodeName,
    this.nodeCode,
    required this.createdAt,
  });

  factory EventLogModel.fromJson(Map<String, dynamic> json) {
    return EventLogModel(
      id: json['id']?.toString() ?? '',
      level: json['level'] ?? 'INFO',
      message: json['message'] ?? '',
      nodeId: json['node_id']?.toString(),
      nodeName: json['node_name'],
      nodeCode: json['node_code'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
