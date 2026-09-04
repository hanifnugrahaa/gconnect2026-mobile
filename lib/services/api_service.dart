import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants.dart';
import '../models/user_model.dart';
import '../models/node_model.dart';
import '../models/sensor_model.dart';
import '../models/telemetry_feed_model.dart';
import 'storage_service.dart';

class ApiService {
  final StorageService _storage = StorageService();
  String _baseUrl = AppConstants.defaultBaseUrl;

  void setBaseUrl(String url) {
    _baseUrl = url;
  }

  String get baseUrl => _baseUrl;

  Future<Map<String, String>> _getHeaders({bool requireAuth = false}) async {
    final headers = {'Content-Type': 'application/json'};
    if (requireAuth) {
      final token = await _storage.getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  Future<String> login(String username, String password) async {
    final uri = Uri.parse('$_baseUrl/auth/login');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'username': username,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['access_token'] as String;
      await _storage.saveToken(token);
      return token;
    } else {
      final data = jsonDecode(response.body);
      throw Exception(data['detail'] ?? 'Gagal login, periksa username dan password Anda');
    }
  }

  Future<UserModel> getCurrentUser() async {
    final uri = Uri.parse('$_baseUrl/auth/me');
    final headers = await _getHeaders(requireAuth: true);
    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final user = UserModel.fromJson(data);
      await _storage.saveUser(user);
      return user;
    } else {
      throw Exception('Sesi telah berakhir, silakan login kembali.');
    }
  }

  Future<List<NodeModel>> getNodes() async {
    final uri = Uri.parse('$_baseUrl/nodes/');
    final headers = await _getHeaders(requireAuth: false);
    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      final nodes = data.map((json) => NodeModel.fromJson(json as Map<String, dynamic>)).toList();

      for (int i = 0; i < nodes.length; i++) {
        final node = nodes[i];
        final code = node.nodeCode.isNotEmpty ? node.nodeCode : node.id;
        try {
          final sUri = Uri.parse('$_baseUrl/nodes/$code/sensors/');
          final sResp = await http.get(sUri, headers: headers);
          if (sResp.statusCode == 200) {
            final sData = jsonDecode(sResp.body) as List<dynamic>;
            final sensors = sData.map((s) => SensorModel.fromJson(s as Map<String, dynamic>)).toList();
            nodes[i] = NodeModel(
              id: node.id,
              nodeCode: node.nodeCode,
              name: node.name,
              description: node.description,
              status: node.status,
              latitude: node.latitude,
              longitude: node.longitude,
              sensors: sensors,
            );
          }
        } catch (_) {}
      }
      return nodes;
    } else {
      throw Exception('Gagal memuat daftar stasiun IoT.');
    }
  }

  Future<List<TelemetryFeedModel>> getTelemetryHistory(String nodeId, {String range = '1d'}) async {
    final uri = Uri.parse('$_baseUrl/nodes/$nodeId/telemetry/history?range=$range');
    final headers = await _getHeaders(requireAuth: false);
    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final feeds = (data['feeds'] as List<dynamic>? ?? []);
      return feeds.map((f) => TelemetryFeedModel.fromJson(f as Map<String, dynamic>)).toList();
    } else {
      // Return empty list instead of throwing to prevent app crashes when node has no feeds yet
      return [];
    }
  }
}
