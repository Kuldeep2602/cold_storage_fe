import 'api_client.dart';

class PaymentsService {
  PaymentsService(this._api);

  final ApiClient _api;

  Future<dynamic> listRequests() => _api.getJson('/api/payments/requests/');

  Future<Map<String, dynamic>> getRequest(int id) async {
    final res = await _api.getJson('/api/payments/requests/$id/');
    return (res as Map).cast<String, dynamic>();
  }
}
