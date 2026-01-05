import 'api_client.dart';

class StaffService {
  StaffService(this._api);

  final ApiClient _api;

  /// Get all staff members
  Future<List<Map<String, dynamic>>> getStaff() async {
    final data = await _api.getJson('/api/staff/');
    return (data as List).cast<Map<String, dynamic>>();
  }

  /// Create a new staff member
  Future<Map<String, dynamic>> createStaff({
    required String phoneNumber,
    required String name,
    required String role,
  }) {
    return _api.postJson('/api/staff/', {
      'phone_number': phoneNumber,
      'name': name,
      'role': role,
    });
  }

  /// Toggle staff member active status
  Future<Map<String, dynamic>> toggleStatus(int staffId) {
    return _api.postJson('/api/staff/$staffId/toggle-status/', {});
  }

  /// Update staff member role
  Future<Map<String, dynamic>> updateRole(int staffId, String newRole) {
    return _api.postJson('/api/staff/$staffId/update-role/', {
      'role': newRole,
    });
  }

  /// Update staff member details
  Future<Map<String, dynamic>> updateStaff(int staffId, Map<String, dynamic> data) {
    return _api.patchJson('/api/staff/$staffId/', data);
  }
}
