import 'api_client.dart';

class DashboardService {
  DashboardService(this._api);

  final ApiClient _api;

  /// Get dashboard statistics
  Future<Map<String, dynamic>> getDashboardStats() async {
    final data = await _api.getJson('/api/dashboard/');
    return data as Map<String, dynamic>;
  }
}


class AlertsService {
  AlertsService(this._api);

  final ApiClient _api;

  /// Get all storage rooms
  Future<List<Map<String, dynamic>>> getRooms() async {
    final data = await _api.getJson('/api/temperature/rooms/');
    return (data as List).cast<Map<String, dynamic>>();
  }

  /// Get temperature alerts
  Future<List<Map<String, dynamic>>> getAlerts({String? status}) async {
    final query = <String, String>{};
    if (status != null) query['status'] = status;
    final data = await _api.getJson('/api/temperature/alerts/', query: query);
    return (data as List).cast<Map<String, dynamic>>();
  }

  /// Get active alerts count
  Future<int> getActiveAlertsCount() async {
    final data = await _api.getJson('/api/temperature/alerts/active-count/');
    return (data as Map<String, dynamic>)['count'] as int? ?? 0;
  }

  /// Take action on an alert
  Future<Map<String, dynamic>> takeAction(int alertId, String action, {String? actionTaken}) {
    final body = <String, dynamic>{
      'action': action,
    };
    if (actionTaken != null) body['action_taken'] = actionTaken;
    return _api.postJson('/api/temperature/alerts/$alertId/take-action/', body);
  }

  /// Update room temperature
  Future<Map<String, dynamic>> updateRoomTemperature(int roomId, double temperature) {
    return _api.postJson('/api/temperature/rooms/$roomId/update-temperature/', {
      'temperature': temperature,
    });
  }
}
