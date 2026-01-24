// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'ColdOne';

  @override
  String get storageLogin => 'Storage Login';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get enterPhoneNumber => 'Enter phone number';

  @override
  String get enterMobileNumber => 'Enter mobile number';

  @override
  String get getOTP => 'Get OTP';

  @override
  String get sendOTP => 'Send OTP';

  @override
  String get enterOTP => 'Enter OTP';

  @override
  String get verify => 'Verify';

  @override
  String get verifyOTP => 'Verify OTP';

  @override
  String get logout => 'Logout';

  @override
  String get continueText => 'Continue';

  @override
  String get chooseLanguage => 'Choose your preferred language';

  @override
  String get changeLanguageLater => 'You can change this later in settings';

  @override
  String get languageComingSoon =>
      'This language is coming soon! Please select English for now.';

  @override
  String get selectRole => 'Select role';

  @override
  String get operator => 'Operator';

  @override
  String get operatorDescription => 'Handles day-to-day operations';

  @override
  String get technician => 'Technician';

  @override
  String get technicianDescription => 'Manages technical aspects';

  @override
  String get manager => 'Manager';

  @override
  String get managerDescription => 'Oversees team and operations';

  @override
  String get owner => 'Owner';

  @override
  String get ownerDescription => 'Full access and control';

  @override
  String get admin => 'Admin';

  @override
  String get secureLogin => 'Secure login for storage operations';

  @override
  String get pleaseEnterPhone => 'Please enter your phone number';

  @override
  String get pleaseEnterValidPhone => 'Please enter a valid phone number';

  @override
  String get unauthorizedContact =>
      'Unauthorized: Please contact your administrator to register.';

  @override
  String get enterOTPCode => 'Enter the 6-digit code sent to';

  @override
  String get pleaseEnterCompleteOTP => 'Please enter complete OTP';

  @override
  String get otpSentSuccess => 'OTP sent successfully';

  @override
  String get goBack => 'Go Back?';

  @override
  String get goBackConfirm =>
      'Do you want to go back and change your phone number or role?';

  @override
  String get changePhone => 'Change Phone';

  @override
  String get changeRole => 'Change Role';

  @override
  String resendOTPIn(int seconds) {
    return 'Resend OTP in ${seconds}s';
  }

  @override
  String get resendOTP => 'Resend OTP';

  @override
  String debugOTP(String otp) {
    return 'Debug OTP: $otp';
  }

  @override
  String get accessPending => 'Access Pending';

  @override
  String get accountCreatedNoAccess =>
      'Your account has been created but you don\'t have access yet.';

  @override
  String get contactAdminTo => 'Please contact your administrator to:';

  @override
  String get assignRole => 'Assign you a role (Operator/Manager)';

  @override
  String get activateAccount => 'Activate your account';

  @override
  String get phone => 'Phone';

  @override
  String get statusLabel => 'Status';

  @override
  String get roleLabel => 'Role';

  @override
  String get notAssigned => 'Not Assigned';

  @override
  String get logoutTryAgain => 'Logout & Try Again';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get requests => 'Requests';

  @override
  String get inventory => 'Inventory';

  @override
  String get staff => 'Staff';

  @override
  String get rooms => 'Rooms';

  @override
  String get alerts => 'Alerts';

  @override
  String get reports => 'Reports';

  @override
  String get temp => 'Temp';

  @override
  String get ledger => 'Ledger';

  @override
  String get payments => 'Payments';

  @override
  String get profile => 'Profile';

  @override
  String get operatorMenu => 'Operator Menu';

  @override
  String get selectOperation => 'Select operation';

  @override
  String get inwardEntry => 'Inward Entry';

  @override
  String get stockLoadingEntry => 'Stock loading entry';

  @override
  String get outwardEntry => 'Outward Entry';

  @override
  String get stockUnloadingEntry => 'Stock unloading entry';

  @override
  String get technicianMenu => 'Technician Menu';

  @override
  String get temperatureMonitoring => 'Temperature Monitoring';

  @override
  String get monitorRoomTemp => 'Monitor room temperatures';

  @override
  String get coldStorages => 'Cold Storages';

  @override
  String get addColdStorage => 'Add Cold Storage';

  @override
  String get coldStorageName => 'Cold Storage Name';

  @override
  String get coldStorageCode => 'Cold Storage Code';

  @override
  String get location => 'Location';

  @override
  String get totalCapacity => 'Total Capacity';

  @override
  String get availableCapacity => 'Available Capacity';

  @override
  String get temperature => 'Temperature';

  @override
  String get status => 'Status';

  @override
  String get active => 'Active';

  @override
  String get inactive => 'Inactive';

  @override
  String get staffManagement => 'Staff Management';

  @override
  String get addStaffMember => 'Add Staff Member';

  @override
  String get name => 'Name';

  @override
  String get role => 'Role';

  @override
  String get assignStorages => 'Assign Storages';

  @override
  String get assignRooms => 'Assign Rooms';

  @override
  String get inwardOutwardOperator => 'Inward/Outward Operator';

  @override
  String get technicianTemp => 'Technician (Temperature)';

  @override
  String get roomManagement => 'Room Management';

  @override
  String get addRoom => 'Add Room';

  @override
  String get roomName => 'Room Name';

  @override
  String get roomNumber => 'Room Number';

  @override
  String get capacity => 'Capacity';

  @override
  String get currentOccupancy => 'Current Occupancy';

  @override
  String get temperatureAlerts => 'Temperature Alerts';

  @override
  String get critical => 'Critical';

  @override
  String get warning => 'Warning';

  @override
  String get normal => 'Normal';

  @override
  String get resolveAlert => 'Resolve Alert';

  @override
  String get productName => 'Product Name';

  @override
  String get quantity => 'Quantity';

  @override
  String get unit => 'Unit';

  @override
  String get customerName => 'Customer Name';

  @override
  String get entryDate => 'Entry Date';

  @override
  String get exitDate => 'Exit Date';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get add => 'Add';

  @override
  String get update => 'Update';

  @override
  String get search => 'Search';

  @override
  String get filter => 'Filter';

  @override
  String get refresh => 'Refresh';

  @override
  String get error => 'Error';

  @override
  String get success => 'Success';

  @override
  String get loading => 'Loading...';

  @override
  String get noDataAvailable => 'No data available';

  @override
  String get confirmDelete => 'Are you sure you want to delete?';

  @override
  String get kg => 'kg';

  @override
  String get tons => 'tons';

  @override
  String get liters => 'liters';

  @override
  String get units => 'units';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get english => 'English';

  @override
  String get hindi => 'हिंदी';

  @override
  String get apiBaseUrl => 'API base URL';

  @override
  String get apiBaseUrlExample => 'Example: http://127.0.0.1:8000';

  @override
  String get saveApiUrl => 'Save API URL';

  @override
  String get baseUrlSaved => 'Base URL saved';

  @override
  String get manageUsers => 'Manage users';
}
