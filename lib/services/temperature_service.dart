import 'api_client.dart';

class TemperatureService {
  TemperatureService(this._api);

  final ApiClient _api;

  Future<dynamic> listLogs() => _api.getJson('/api/temperature/logs/');

  Future<Map<String, dynamic>> createLog({
    required DateTime loggedAt,
    required String temperature,
  }) {
    return _api.postJson('/api/temperature/logs/', {
      'logged_at': loggedAt.toIso8601String(),
      'temperature': temperature,
    });
  }

  Future<Map<String, dynamic>> updateLog({
    required int id,
    required DateTime loggedAt,
    required String temperature,
  }) {
    return _api.putJson('/api/temperature/logs/$id/', {
      'logged_at': loggedAt.toIso8601String(),
      'temperature': temperature,
    });
  }
}
