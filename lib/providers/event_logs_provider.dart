import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../core/constants.dart';
import '../models/event_log_model.dart';

class EventLogsState {
  final List<EventLogModel> logs;
  final bool isLoading;
  final String? error;

  const EventLogsState({
    this.logs = const [],
    this.isLoading = false,
    this.error,
  });

  EventLogsState copyWith({
    List<EventLogModel>? logs,
    bool? isLoading,
    String? error,
  }) {
    return EventLogsState(
      logs: logs ?? this.logs,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class EventLogsNotifier extends StateNotifier<EventLogsState> {
  EventLogsNotifier() : super(const EventLogsState()) {
    fetchLogs();
  }

  Future<void> fetchLogs({String? level}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      String url = '${AppConstants.defaultBaseUrl}/event-logs/?limit=30';
      if (level != null && level.isNotEmpty) {
        url += '&level=$level';
      }

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final parsed = data.map((x) => EventLogModel.fromJson(x)).toList();
        state = state.copyWith(logs: parsed, isLoading: false);
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Gagal memuat event logs (${response.statusCode})',
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final eventLogsProvider = StateNotifierProvider<EventLogsNotifier, EventLogsState>((ref) {
  return EventLogsNotifier();
});
