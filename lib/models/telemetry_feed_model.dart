class TelemetryFeedModel {
  final DateTime createdAt;
  final int entryId;
  final Map<String, dynamic> rawFields;

  TelemetryFeedModel({
    required this.createdAt,
    required this.entryId,
    required this.rawFields,
  });

  factory TelemetryFeedModel.fromJson(Map<String, dynamic> json) {
    final dateStr = json['created_at']?.toString() ?? DateTime.now().toIso8601String();
    return TelemetryFeedModel(
      createdAt: DateTime.tryParse(dateStr) ?? DateTime.now(),
      entryId: json['entry_id'] is int ? json['entry_id'] : int.tryParse(json['entry_id']?.toString() ?? '0') ?? 0,
      rawFields: json,
    );
  }

  double? getValue(String? channelId, String? tsField, String? name) {
    if (channelId != null && tsField != null) {
      final composite = '${channelId}_${tsField}'.toLowerCase();
      if (rawFields.containsKey(composite)) {
        return _toDouble(rawFields[composite]);
      }
    }
    if (tsField != null && rawFields.containsKey(tsField)) {
      return _toDouble(rawFields[tsField]);
    }
    if (name != null && rawFields.containsKey(name)) {
      return _toDouble(rawFields[name]);
    }
    for (final entry in rawFields.entries) {
      if (tsField != null && entry.key.toLowerCase().endsWith('_${tsField.toLowerCase()}')) {
        return _toDouble(entry.value);
      }
      if (name != null && entry.key.toLowerCase() == name.toLowerCase()) {
        return _toDouble(entry.value);
      }
    }
    return null;
  }

  double? _toDouble(dynamic val) {
    if (val == null) return null;
    if (val is num) return val.toDouble();
    return double.tryParse(val.toString());
  }
}
