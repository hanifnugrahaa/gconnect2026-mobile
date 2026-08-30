class SensorModel {
  final String id;
  final String name;
  final String type;
  final String unit;
  final String? thingspeakField;
  final String? fieldKey;
  final String? channelId;
  final double? minThreshold;
  final double? maxThreshold;

  SensorModel({
    required this.id,
    required this.name,
    required this.type,
    required this.unit,
    this.thingspeakField,
    this.fieldKey,
    this.channelId,
    this.minThreshold,
    this.maxThreshold,
  });

  factory SensorModel.fromJson(Map<String, dynamic> json) {
    return SensorModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? 'numeric',
      unit: json['unit'] ?? '',
      thingspeakField: json['thingspeak_field']?.toString(),
      fieldKey: json['field_key']?.toString(),
      channelId: json['channel_id']?.toString(),
      minThreshold: (json['min_threshold'] as num?)?.toDouble(),
      maxThreshold: (json['max_threshold'] as num?)?.toDouble(),
    );
  }
}
