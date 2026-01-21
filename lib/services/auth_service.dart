import 'api_client.dart';

class AuthService {
  AuthService(this._api);

  final ApiClient _api;

  /// Signup a new user with phone number (also sends OTP)
  Future<Map<String, dynamic>> signup(String phoneNumber) {
    return _api.postJson('/api/auth/signup/', {
      'phone_number': phoneNumber,
    });
  }

  Future<Map<String, dynamic>> requestOtp(String phoneNumber) {
    return _api.postJson('/api/auth/request-otp/', {
      'phone_number': phoneNumber,
    });
  }

  Future<Map<String, dynamic>> verifyOtp({
    required String phoneNumber,
    required String code,
  }) async {
    final res = await _api.postJson('/api/auth/verify-otp/', {
      'phone_number': phoneNumber,
      'code': code,
    });

    final access = res['access'] as String?;
    if (access != null && access.isNotEmpty) {
      _api.accessToken = access;
    }
    return res;
  }
}
