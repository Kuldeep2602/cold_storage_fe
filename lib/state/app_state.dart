import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';
import '../services/api_client.dart';
import '../services/auth_service.dart';
import '../services/dashboard_service.dart';
import '../services/inventory_service.dart';
import '../services/ledger_service.dart';
import '../services/payments_service.dart';
import '../services/person_service.dart';
import '../services/staff_service.dart';
import '../services/temperature_service.dart';
import '../services/user_service.dart';
import '../utils/default_base_url.dart';

class AppState extends ChangeNotifier {
  bool _initialized = false;

  late SharedPreferences _prefs;

  late ApiClient _api;
  late AuthService auth;
  late InventoryService inventory;
  late TemperatureService temperature;
  late LedgerService ledger;
  late PaymentsService payments;
  late UserService users;
  late DashboardService dashboard;
  late PersonService persons;
  late StaffService staff;

  String _baseUrl = defaultBaseUrl();
  String? _accessToken;
  String? _refreshToken;
  User? _user;

  String? _selectedLanguage;
  String? _selectedRole;

  bool get initialized => _initialized;
  String get baseUrl => _baseUrl;
  String? get accessToken => _accessToken;
  User? get user => _user;
  bool get isAuthenticated => (_accessToken ?? '').isNotEmpty;

  // Expose the API client
  ApiClient get client => _api;

  // Role and Language Getters
  bool get hasSelectedLanguage =>
      _selectedLanguage != null && _selectedLanguage!.isNotEmpty;
  bool get hasSelectedRole =>
      _selectedRole != null && _selectedRole!.isNotEmpty;
  bool get hasRole => _user?.role != null && _user!.role!.isNotEmpty;
  String? get selectedRole => _selectedRole;
  String? get selectedLanguage => _selectedLanguage;

  bool get isManagerOrAdmin {
    final role = _user?.role ?? '';
    return role == 'manager' || role == 'admin';
  }

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();

    _baseUrl = _prefs.getString('baseUrl') ?? defaultBaseUrl();
    _accessToken = _prefs.getString('accessToken');
    _refreshToken = _prefs.getString('refreshToken');
    _selectedLanguage = _prefs.getString('selectedLanguage');
    _selectedRole = _prefs.getString('selectedRole');

    final userJson = _prefs.getString('userJson');
    if (userJson != null && userJson.isNotEmpty) {
      try {
        _user = User.fromJson(jsonDecode(userJson) as Map<String, dynamic>);
      } catch (_) {
        _user = null;
      }
    }

    _rebuildApi();
    _initialized = true;
    notifyListeners();
  }

  void _rebuildApi() {
    _api = ApiClient(
      baseUrl: _baseUrl,
      onUnauthorized: () {
        // Handle 401 errors by logging out
        debugPrint('ApiClient: Unauthorized - logging out');
        logout();
      },
    );
    _api.accessToken = _accessToken;

    // Debug: Log token status
    if (kDebugMode) {
      debugPrint(
          'ApiClient initialized: baseUrl=$_baseUrl, hasToken=${(_accessToken ?? "").isNotEmpty}');
    }

    auth = AuthService(_api);
    inventory = InventoryService(_api);
    temperature = TemperatureService(_api);
    ledger = LedgerService(_api);
    payments = PaymentsService(_api);
    users = UserService(_api);
    dashboard = DashboardService(_api);
    persons = PersonService(_api);
    staff = StaffService(_api);
  }

  Future<void> setBaseUrl(String value) async {
    final v = value.trim();
    if (v.isEmpty) return;
    _baseUrl = v;
    await _prefs.setString('baseUrl', _baseUrl);
    _rebuildApi();
    notifyListeners();
  }

  // Language & Role Methods

  Future<void> setSelectedLanguage(String language) async {
    _selectedLanguage = language;
    await _prefs.setString('selectedLanguage', language);
    notifyListeners();
  }

  Future<void> setSelectedRole(String role) async {
    _selectedRole = role;
    await _prefs.setString('selectedRole', role);
    notifyListeners();
  }

  Future<void> clearSelectedRole() async {
    _selectedRole = null;
    await _prefs.remove('selectedRole');
    notifyListeners();
  }

  Future<void> clearSelectedLanguage() async {
    _selectedLanguage = null;
    await _prefs.remove('selectedLanguage');
    notifyListeners();
  }

  /// Signup a new user with phone number (also sends OTP)
  Future<Map<String, dynamic>> signup(String phoneNumber) {
    return auth.signup(phoneNumber);
  }

  Future<Map<String, dynamic>> requestOtp(String phoneNumber) {
    // Pass the selected role to help disambiguate users with same phone number
    return auth.requestOtp(phoneNumber, role: _selectedRole);
  }

  Future<void> verifyOtp(
      {required String phoneNumber, required String code}) async {
    // Pass the selected role to help disambiguate users with same phone number
    final res = await auth.verifyOtp(
      phoneNumber: phoneNumber,
      code: code,
      role: _selectedRole,
    );

    // Parse user data first to check role
    final userMap = (res['user'] as Map?)?.cast<String, dynamic>();
    final authenticatedUser = userMap == null ? null : User.fromJson(userMap);

    // Strict Role Check: Ensure the logged-in user's role matches the selected role
    // Exception: Owners often have 'admin' role in backend, or 'owner'.
    if (authenticatedUser != null && _selectedRole != null) {
      final userRole = (authenticatedUser.role ?? '').toLowerCase();
      final selectedRole = _selectedRole!.toLowerCase();

      // Allow if roles match exactly
      bool isMismatch = userRole != selectedRole;

      // Special case: 'admin' user can login as 'owner'
      if (selectedRole == 'owner' && userRole == 'admin') {
        isMismatch = false;
      }

      if (isMismatch) {
        // If roles mismatch, do not log in. Throw error.
        throw ApiException(
          403,
          {
            'detail':
                'Role mismatch. You cannot login to this role with your account.'
          },
        );
      }
    }

    _accessToken = (res['access'] as String?) ?? '';
    _refreshToken = (res['refresh'] as String?) ?? '';
    _user = authenticatedUser;

    _api.accessToken = _accessToken;

    await _prefs.setString('accessToken', _accessToken ?? '');
    await _prefs.setString('refreshToken', _refreshToken ?? '');
    await _prefs.setString('userJson', jsonEncode(_user?.toJson()));

    notifyListeners();
  }

  Future<void> logout() async {
    _accessToken = null;
    _refreshToken = null;
    _user = null;
    _api.accessToken = null;
    // We might NOT want to clear language on logout, but clearing role might be appropriate depending on UX
    // Keeping language preference is standard.

    await _prefs.remove('accessToken');
    await _prefs.remove('refreshToken');
    await _prefs.remove('userJson');

    // Optionally clear role selection if you want them to re-select role on next login
    // await clearSelectedRole();

    notifyListeners();
  }
}
