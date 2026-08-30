import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/telemetry_feed_model.dart';
import '../models/sensor_model.dart';
import '../services/api_service.dart';
import '../services/websocket_service.dart';

class TelemetryState {
  final bool isLoading;
  final List<TelemetryFeedModel> historyFeeds;
  final Map<String, dynamic> latestLivePayload;
  final String selectedRange; // '1d', '1w', '1M'
  final String? errorMessage;

  TelemetryState({
    this.isLoading = false,
    this.historyFeeds = const [],
    this.latestLivePayload = const {},
    this.selectedRange = '1d',
    this.errorMessage,
  });

  TelemetryState copyWith({
    bool? isLoading,
    List<TelemetryFeedModel>? historyFeeds,
    Map<String, dynamic>? latestLivePayload,
    String? selectedRange,
    String? errorMessage,
  }) {
    return TelemetryState(
      isLoading: isLoading ?? this.isLoading,
      historyFeeds: historyFeeds ?? this.historyFeeds,
      latestLivePayload: latestLivePayload ?? this.latestLivePayload,
      selectedRange: selectedRange ?? this.selectedRange,
      errorMessage: errorMessage,
    );
  }
}

class TelemetryNotifier extends StateNotifier<TelemetryState> {
  final ApiService _api = ApiService();
  final WebSocketService _ws = WebSocketService();

  TelemetryNotifier() : super(TelemetryState()) {
    _initWebSocket();
  }

  void _initWebSocket() {
    _ws.connect();
    _ws.stream.listen((payload) {
      state = state.copyWith(latestLivePayload: payload);
    });
  }

  Future<void> fetchHistory(String nodeId, {String? range}) async {
    final activeRange = range ?? state.selectedRange;
    state = state.copyWith(isLoading: true, selectedRange: activeRange, errorMessage: null);

    try {
      final feeds = await _api.getTelemetryHistory(nodeId, range: activeRange);
      state = state.copyWith(
        isLoading: false,
        historyFeeds: feeds,
        selectedRange: activeRange,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  double? getLiveSensorValue(SensorModel sensor) {
    // 1. Try from live websocket payload first
    final liveFeeds = state.latestLivePayload['feeds'];
    if (liveFeeds is List && liveFeeds.isNotEmpty) {
      final last = liveFeeds.last;
      if (last is Map<String, dynamic>) {
        final feedModel = TelemetryFeedModel.fromJson(last);
        final val = feedModel.getValue(sensor.channelId, sensor.thingspeakField ?? sensor.fieldKey, sensor.name);
        if (val != null) return val;
      }
    }

    // 2. Try from history feeds
    if (state.historyFeeds.isNotEmpty) {
      final last = state.historyFeeds.last;
      return last.getValue(sensor.channelId, sensor.thingspeakField ?? sensor.fieldKey, sensor.name);
    }

    return null;
  }

  @override
  void dispose() {
    _ws.disconnect();
    super.dispose();
  }
}

final telemetryProvider = StateNotifierProvider<TelemetryNotifier, TelemetryState>((ref) {
  return TelemetryNotifier();
});
