import '../services/api_client.dart';

class PersonService {
  final ApiClient _client;

  PersonService(this._client);

  /// Create a new person (party/farmer)
  Future<Map<String, dynamic>> createPerson(Map<String, dynamic> data) async {
    return await _client.postJson('/api/inventory/persons/', data);
  }

  /// Search persons by query
  Future<List<Map<String, dynamic>>> searchPersons(String query) async {
    final response = await _client.getJson('/api/inventory/persons/', queryParams: {'search': query});
    return List<Map<String, dynamic>>.from(response);
  }

  /// Get person by ID
  Future<Map<String, dynamic>> getPerson(int id) async {
    return await _client.getJson('/api/inventory/persons/$id/');
  }
}
