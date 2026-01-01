import 'api_client.dart';

class UserService {
  UserService(this._api);

  final ApiClient _api;

  Future<Map<String, dynamic>> me() async {
    final res = await _api.getJson('/api/users/me/');
    return (res as Map).cast<String, dynamic>();
  }

  Future<dynamic> listUsers() => _api.getJson('/api/users/');

  Future<Map<String, dynamic>> createUser({
    required String phoneNumber,
    required String role,
    bool isActive = true,
  }) {
    return _api.postJson('/api/users/', {
      'phone_number': phoneNumber,
      'role': role,
      'is_active': isActive,
    });
  }

  Future<Map<String, dynamic>> updateLanguagePreference(String languageCode) async {
    final res = await _api.patchJson('/api/users/me/', {
      'preferred_language': languageCode,
    });
    return (res as Map).cast<String, dynamic>();
  }
}

