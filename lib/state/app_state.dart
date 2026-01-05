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
import '../services/staff_service.dart';
import '../services/temperature_service.dart';
import '../services/user_service.dart';
import '../services/person_service.dart';
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
  late StaffService staff;
  late DashboardService dashboard;

  AppState() {
    _api = ApiClient(
      baseUrl: defaultBaseUrl(),
      onUnauthorized: logout,
    );
    auth = AuthService(_api);
    inventory = InventoryService(_api);
    temperature = TemperatureService(_api);
    ledger = LedgerService(_api);
    payments = PaymentsService(_api);
    users = UserService(_api);
    staff = StaffService(_api);
    dashboard = DashboardService(_api);
    persons = PersonService(_api);
  }

  late PersonService persons;

  String _baseUrl = defaultBaseUrl();
  String? _accessToken;
  String? _refreshToken;
  User? _user;
  String? _selectedLanguage;
  String? _selectedRole;

  bool get initialized => _initialized;
  String get baseUrl => _baseUrl;
  ApiClient get client => _api;
  String? get accessToken => _accessToken;
  User? get user => _user;
  bool get isAuthenticated => (_accessToken ?? '').isNotEmpty;
  String? get selectedLanguage => _selectedLanguage;
  String? get selectedRole => _selectedRole;
  
  /// Check if language has been selected
  bool get hasSelectedLanguage => (_selectedLanguage ?? '').isNotEmpty;
  
  /// Check if role has been selected
  bool get hasSelectedRole => (_selectedRole ?? '').isNotEmpty;

  /// Check if user has any role assigned
  bool get hasRole => _user?.hasRole ?? false;

  /// Check if user has manager-level access
  bool get isManagerOrAdmin => _user?.isManagerOrHigher ?? false;

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
      onUnauthorized: logout,
    );
    _api.accessToken = _accessToken;

    auth = AuthService(_api);
    inventory = InventoryService(_api);
    temperature = TemperatureService(_api);
    ledger = LedgerService(_api);
    payments = PaymentsService(_api);
    users = UserService(_api);
    staff = StaffService(_api);
    dashboard = DashboardService(_api);
    persons = PersonService(_api);
  }

  Future<void> setBaseUrl(String value) async {
    final v = value.trim();
    if (v.isEmpty) return;
    _baseUrl = v;
    await _prefs.setString('baseUrl', _baseUrl);
    _rebuildApi();
    notifyListeners();
  }

  /// Signup a new user with phone number and role (also sends OTP)
  Future<Map<String, dynamic>> signup(String phoneNumber, {String? role}) {
    return auth.signup(phoneNumber, role: role ?? _selectedRole);
  }

  Future<Map<String, dynamic>> requestOtp(String phoneNumber) {
    return auth.requestOtp(phoneNumber);
  }

  Future<void> verifyOtp({required String phoneNumber, required String code}) async {
    final res = await auth.verifyOtp(phoneNumber: phoneNumber, code: code);

    _accessToken = (res['access'] as String?) ?? '';
    _refreshToken = (res['refresh'] as String?) ?? '';
    final userMap = (res['user'] as Map?)?.cast<String, dynamic>();
    _user = userMap == null ? null : User.fromJson(userMap);

    _api.accessToken = _accessToken;

    await _prefs.setString('accessToken', _accessToken ?? '');
    await _prefs.setString('refreshToken', _refreshToken ?? '');
    await _prefs.setString('userJson', jsonEncode(_user?.toJson()));

    notifyListeners();
  }

  Future<void> setSelectedLanguage(String languageCode) async {
    _selectedLanguage = languageCode;
    await _prefs.setString('selectedLanguage', languageCode);
    
    // If user is already authenticated, sync to backend
    if (isAuthenticated && _user != null) {
      try {
        await users.updateLanguagePreference(languageCode);
        // Update local user object
        final updatedUserJson = _prefs.getString('userJson');
        if (updatedUserJson != null) {
          final userMap = jsonDecode(updatedUserJson) as Map<String, dynamic>;
          userMap['preferred_language'] = languageCode;
          _user = User.fromJson(userMap);
          await _prefs.setString('userJson', jsonEncode(_user?.toJson()));
        }
      } catch (_) {
        // Silent fail - will sync on next login
      }
    }
    
    notifyListeners();
  }

  Future<void> setSelectedRole(String roleCode) async {
    _selectedRole = roleCode;
    await _prefs.setString('selectedRole', roleCode);
    notifyListeners();
  }

  /// Clear the selected role (allows user to change role)
  Future<void> clearSelectedRole() async {
    _selectedRole = null;
    await _prefs.remove('selectedRole');
    notifyListeners();
  }

  /// Clear the selected language (allows user to change language)
  Future<void> clearSelectedLanguage() async {
    _selectedLanguage = null;
    await _prefs.remove('selectedLanguage');
    notifyListeners();
  }

  Future<void> logout() async {
    _accessToken = null;
    _refreshToken = null;
    _user = null;
    _api.accessToken = null;

    await _prefs.remove('accessToken');
    await _prefs.remove('refreshToken');
    await _prefs.remove('userJson');
    // Don't remove selectedLanguage on logout
    notifyListeners();
  }
}
