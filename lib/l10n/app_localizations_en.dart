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
  String get close => 'Close';

  @override
  String get required => 'Required';

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
  String get days => 'Days';

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

  @override
  String get partyFarmerSelection => '1. Party / Farmer Selection';

  @override
  String get searchParty => 'Search Party';

  @override
  String get searchByNameOrPhone => 'Search by name or phone';

  @override
  String get viewAllParties => 'View all parties';

  @override
  String get selectParty => 'Select Party';

  @override
  String get noPartiesFound => 'No parties found';

  @override
  String get registerNewParty => 'Register New Party';

  @override
  String partyRegisteredSuccess(String name) {
    return 'Party \"$name\" registered successfully!';
  }

  @override
  String get cropDetails => '2. Crop Details';

  @override
  String get cropType => 'Crop Type';

  @override
  String get enterCropName => 'Enter crop name';

  @override
  String get qualityGradeOptional => 'Quality Grade (Optional)';

  @override
  String get gradeA => 'Grade A';

  @override
  String get gradeB => 'Grade B';

  @override
  String get gradeC => 'Grade C';

  @override
  String get sizeOptional => 'Size (Optional)';

  @override
  String get sizeHint => 'e.g. Small, Medium, Large, 45mm';

  @override
  String get quantityDetails => '3. Quantity Details';

  @override
  String enterQuantityIn(String unit) {
    return 'Enter quantity in $unit';
  }

  @override
  String get visualRecord => '4. Visual Record';

  @override
  String get uploadImageOfGoods => 'Upload Image of Goods';

  @override
  String get tapToCaptureOrUpload => 'Tap to capture or upload';

  @override
  String get takePhoto => 'Take Photo';

  @override
  String get chooseFromGallery => 'Choose from Gallery';

  @override
  String get errorPickingImage => 'Error picking image';

  @override
  String get storageDetails => '5. Storage Details';

  @override
  String get storageFacility => 'Storage Facility';

  @override
  String get storageRoom => 'Storage Room';

  @override
  String get selectStorageRoom => 'Select storage room';

  @override
  String get noStorageRoomsAvailable =>
      'No storage rooms available for your assigned facility. Please contact manager.';

  @override
  String get storageDuration => 'Storage Duration';

  @override
  String get sixtyDays => '60 Days';

  @override
  String get ninetyDays => '90 Days';

  @override
  String get oneYear => '1 Year';

  @override
  String get enterDays => 'Enter days';

  @override
  String get saveInwardEntry => 'Save Inward Entry';

  @override
  String get entrySaved => 'Entry Saved';

  @override
  String get inwardEntrySuccess =>
      'Inward entry has been successfully recorded.';

  @override
  String get downloadReceipt => 'Download Receipt';

  @override
  String get pleaseSelectParty => 'Please select a party/farmer';

  @override
  String get pleaseSelectStorageRoom => 'Please select a storage room';

  @override
  String get noStorageAssigned =>
      'Error: No Storage assigned to this operator.';

  @override
  String get selectBookingParty => '1. Select Booking / Party';

  @override
  String get searchStoredInventory => 'Search Stored Inventory';

  @override
  String get searchByPartyPhoneCrop => 'Search by party, phone, or crop';

  @override
  String get noInventoryFound => 'No inventory found';

  @override
  String get availableInventory => 'Available Inventory';

  @override
  String itemsCount(int count) {
    return '$count items';
  }

  @override
  String get party => 'Party';

  @override
  String get available => 'Available';

  @override
  String get quantityToRemove => 'Quantity to remove';

  @override
  String get enterQuantity => 'Enter quantity';

  @override
  String get confirmOutward => 'Confirm Outward';

  @override
  String get outwardRecorded => 'Outward Recorded';

  @override
  String outwardReceiptGenerated(String number) {
    return 'Outward receipt #$number generated.';
  }

  @override
  String get pleaseEnterValidQuantity => 'Please enter a valid quantity';

  @override
  String quantityExceedsStock(String available) {
    return 'Quantity exceeds available stock ($available)';
  }

  @override
  String get processingOutwardEntry => 'Processing outward entry...';

  @override
  String get errorLoadingInventory => 'Error loading inventory';

  @override
  String get quickRegistration =>
      'Quick registration - takes less than 30 seconds';

  @override
  String get enterFullName => 'Enter full name';

  @override
  String get partyType => 'Party Type';

  @override
  String get farmer => 'Farmer';

  @override
  String get traderCompany => 'Trader / Co.';

  @override
  String get transporter => 'Transporter';

  @override
  String get coldStorage => 'Cold Storage';

  @override
  String get pleaseSelectColdStorage => 'Please select a cold storage';

  @override
  String get storage => 'Storage';

  @override
  String get villageCity => 'Village / City';

  @override
  String get enterVillageOrCity => 'Enter village or city name';

  @override
  String get gstNumberOptional => 'GST Number (Optional)';

  @override
  String get notesOptional => 'Notes (Optional)';

  @override
  String get addNotes => 'Add any additional notes...';

  @override
  String get saveParty => 'Save Party';

  @override
  String get ownerOverview => 'Owner Overview';

  @override
  String get highLevelMetrics => 'High-level business metrics';

  @override
  String get overview => 'Overview';

  @override
  String get storages => 'Storages';

  @override
  String get noStorages => 'No storages';

  @override
  String get selectStorage => 'Select Storage';

  @override
  String get storageUtilization => 'Storage Utilization';

  @override
  String get ofCapacity => 'of capacity';

  @override
  String mtOccupied(String value) {
    return '$value MT occupied';
  }

  @override
  String mtTotal(String value) {
    return '$value MT total';
  }

  @override
  String get thisMonth => 'This Month';

  @override
  String get inflow => 'Inflow';

  @override
  String get mtReceived => 'MT received';

  @override
  String get outflow => 'Outflow';

  @override
  String get mtDispatched => 'MT dispatched';

  @override
  String get activeBookings => 'Active Bookings';

  @override
  String get confirmed => 'Confirmed';

  @override
  String get pending => 'Pending';

  @override
  String get alertSummary => 'Alert Summary';

  @override
  String roomsOutOfRange(int count) {
    return '$count rooms out of range';
  }

  @override
  String get allRoomsNormal => 'All rooms normal';

  @override
  String get equipmentStatus => 'Equipment Status';

  @override
  String get allSystemsOperational => 'All systems operational';

  @override
  String get revenueEst => 'Revenue (Est.)';

  @override
  String get avgDuration => 'Avg. Duration';

  @override
  String get manageManagersStaff => 'Manage managers & staff';

  @override
  String get addNewStaffMember => 'Add New Staff Member';

  @override
  String get phoneNumberRequired => 'Phone Number *';

  @override
  String get phoneHint => '+91 ';

  @override
  String get nameRequired => 'Name *';

  @override
  String get enterName => 'Enter name';

  @override
  String get roleRequired => 'Role *';

  @override
  String get fullAccessDescription =>
      'Full access to manage storages, staff & inventory';

  @override
  String get inwardOutwardOnly => 'Inward/Outward operations only';

  @override
  String get tempMonitoringAlerts => 'Temperature monitoring & alerts';

  @override
  String get phoneNameRequired => 'Phone number and name are required';

  @override
  String get staffAddedSuccess => 'Staff member added successfully';

  @override
  String get addStaff => 'Add Staff';

  @override
  String get editStaffMember => 'Edit Staff Member';

  @override
  String phoneLabel(String phone) {
    return 'Phone: $phone';
  }

  @override
  String get fullAccess => 'Full access';

  @override
  String get inwardOutward => 'Inward/Outward';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get staffUpdatedSuccess => 'Staff updated successfully';

  @override
  String get managers => 'Managers';

  @override
  String get canManageOperations => 'Can manage storage operations';

  @override
  String get operators => 'Operators';

  @override
  String get inwardOutwardOps => 'Inward/Outward operations';

  @override
  String get technicians => 'Technicians';

  @override
  String get tempMonitoring => 'Temperature monitoring';

  @override
  String noRoleAddedYet(String role) {
    return 'No $role added yet';
  }

  @override
  String get disabled => 'Disabled';

  @override
  String get enable => 'Enable';

  @override
  String get disable => 'Disable';

  @override
  String get deleteStaff => 'Delete Staff?';

  @override
  String deleteStaffConfirm(String name) {
    return 'Are you sure you want to delete $name? This action cannot be undone.';
  }

  @override
  String get staffDeletedSuccess => 'Staff member deleted successfully';

  @override
  String get errorLoadingStaff => 'Error loading staff';

  @override
  String get errorLoadingStorages => 'Error loading storages';

  @override
  String get manageYourFacilities => 'Manage your facilities';

  @override
  String get addNewStorage => 'Add New Storage';

  @override
  String get addStorage => 'Add Storage';

  @override
  String get editStorage => 'Edit Storage';

  @override
  String get storageType => 'Storage Type';

  @override
  String get silos => 'Silos';

  @override
  String get warehouses => 'Warehouses';

  @override
  String get frozenStorages => 'Frozen Storages';

  @override
  String get ripeningChambers => 'Ripening Chambers';

  @override
  String get controlledAtmosphere => 'Controlled Atmosphere Storage';

  @override
  String get storageNameHint => 'e.g. Storage Main';

  @override
  String get codeRequired => 'Code *';

  @override
  String get codeHint => 'e.g. STR1';

  @override
  String get city => 'City';

  @override
  String get cityHint => 'e.g. Nashik';

  @override
  String get totalCapacityMT => 'Total Capacity (MT)';

  @override
  String get roomsRequired => 'Rooms *';

  @override
  String get addAtLeastOneRoom => 'Add at least one room for this storage';

  @override
  String get roomsHint => 'e.g. Room A, Room B, Room C (comma separated)';

  @override
  String get separateWithCommas => 'Separate multiple rooms with commas';

  @override
  String get nameCodeRequired => 'Name and Code are required';

  @override
  String get storageDeleted => 'Storage deleted';

  @override
  String get atLeastOneRoomRequired => 'At least one room is required';

  @override
  String get storageCreatedSuccess => 'Storage created successfully';

  @override
  String get storageUpdatedSuccess => 'Storage updated successfully';

  @override
  String get create => 'Create';

  @override
  String yourStoragesCount(int count) {
    return 'Your Storages ($count)';
  }

  @override
  String get noStoragesYet => 'No storages yet';

  @override
  String get addFirstStorage => 'Add your first storage facility';

  @override
  String get capacityUsage => 'Capacity Usage';

  @override
  String mtUsed(String value) {
    return '$value MT used';
  }

  @override
  String get managerLabel => 'Manager:';

  @override
  String get change => 'Change';

  @override
  String get assign => 'Assign';

  @override
  String get view => 'View';

  @override
  String get assignManager => 'Assign Manager';

  @override
  String coldStorageLabel(String name) {
    return 'Cold Storage: $name';
  }

  @override
  String get selectManager => 'Select Manager:';

  @override
  String get noManager => 'No Manager';

  @override
  String get managerAssignedSuccess => 'Manager assigned successfully';

  @override
  String get code => 'Code';

  @override
  String get occupied => 'Occupied';

  @override
  String get errorLoadingColdStorages => 'Error loading cold storages';

  @override
  String get temperatureAlertsSummary => 'Temperature Alerts';

  @override
  String get allRoomsOperational => 'All rooms operational';

  @override
  String get roomsNeedAttention => 'rooms need attention';

  @override
  String get managerDashboard => 'Manager Dashboard';

  @override
  String welcome(String name) {
    return 'Welcome, $name';
  }

  @override
  String storageLabel(String names) {
    return 'Storage: $names';
  }

  @override
  String get noStorageAssignedTitle => 'No Storage Assigned';

  @override
  String get contactOwnerMessage =>
      'Please contact the owner to assign you a storage.';

  @override
  String get mt => 'MT';

  @override
  String activeEntriesCount(int count) {
    return '$count active entries';
  }

  @override
  String get inventorySummary => 'Inventory Summary';

  @override
  String get viewStoredCrops => 'View stored crops';

  @override
  String alertsActiveCount(int count) {
    return '$count alerts active';
  }

  @override
  String teamMembersCount(int count) {
    return '$count team members';
  }

  @override
  String get pendingRequests => 'Pending Requests';

  @override
  String get awaitingApproval => 'Awaiting approval';

  @override
  String get totalStock => 'Total Stock';

  @override
  String acrossCropTypes(int count) {
    return 'Across $count crop types';
  }

  @override
  String get addInward => 'Add Inward';

  @override
  String get markOutward => 'Mark Outward';

  @override
  String get unknown => 'Unknown';

  @override
  String get inStorage => 'In storage';

  @override
  String get inwardDate => 'Inward Date';

  @override
  String get expectedOut => 'Expected Out';

  @override
  String get addAndManageStaff => 'Add and manage storage staff';

  @override
  String get deleteStaffMember => 'Delete Staff Member';

  @override
  String get deleteStaffMemberConfirm =>
      'Are you sure you want to delete this staff member?';

  @override
  String errorMessage(String error) {
    return 'Error: $error';
  }

  @override
  String get staffMemberAddedSuccess => 'Staff member added successfully';

  @override
  String get editStaff => 'Edit Staff Member';

  @override
  String get staffMemberUpdatedSuccess => 'Staff member updated successfully';

  @override
  String staffMembersCount(int count) {
    return 'Staff Members ($count)';
  }

  @override
  String get noRole => 'No Role';

  @override
  String activeAlertsCount(int count) {
    return '$count active alerts';
  }

  @override
  String get activeAlerts => 'Active Alerts';

  @override
  String get allClear => 'All Clear!';

  @override
  String get noActiveAlerts => 'No active temperature alerts';

  @override
  String get normalStatus => 'Normal Status';

  @override
  String get unknownRoom => 'Unknown Room';

  @override
  String get currentTemp => 'Current Temp';

  @override
  String get allowedRange => 'Allowed Range';

  @override
  String tempRange(String min, String max) {
    return '$min°C to $max°C';
  }

  @override
  String get takeAction => 'Take Action';

  @override
  String actionTaken(String roomName) {
    return 'Action - $roomName';
  }

  @override
  String get acknowledge => 'Acknowledge';

  @override
  String get markAsSeen => 'Mark as seen';

  @override
  String get resolve => 'Resolve';

  @override
  String get issueFixed => 'Issue has been fixed';

  @override
  String alertActionSuccess(String action) {
    return 'Alert ${action}d successfully';
  }

  @override
  String get withinRange => 'Within range';

  @override
  String errorLoadingAlerts(String error) {
    return 'Error loading alerts: $error';
  }

  @override
  String get roomTemperatureSettings => 'Room Temperature Settings';

  @override
  String roomsCount(int count) {
    return '$count rooms';
  }

  @override
  String get noRoomsFound => 'No rooms found';

  @override
  String get addNewRoom => 'Add New Room';

  @override
  String get coldStorageRequired => 'Cold Storage *';

  @override
  String get roomNameRequired => 'Room Name *';

  @override
  String get roomNameHint => 'e.g. Room A';

  @override
  String get capacityMT => 'Capacity (MT)';

  @override
  String get capacityPlaceholder => '100';

  @override
  String get minTemperature => 'Min Temperature (°C)';

  @override
  String get minTempPlaceholder => '-5';

  @override
  String get maxTemperature => 'Max Temperature (°C)';

  @override
  String get maxTempPlaceholder => '0';

  @override
  String get roomNameStorageRequired => 'Room name and storage are required';

  @override
  String get roomAddedSuccess => 'Room added successfully';

  @override
  String get setTemperatureRange => 'Set Temperature Range';

  @override
  String get minimumTemperature => 'Minimum Temperature (°C)';

  @override
  String get minTempExample => 'e.g., -5';

  @override
  String get maximumTemperature => 'Maximum Temperature (°C)';

  @override
  String get maxTempExample => 'e.g., 0';

  @override
  String get temperatureAlertInfo =>
      'Alerts will be created when temperature goes outside this range';

  @override
  String get minLessThanMax => 'Minimum must be less than maximum';

  @override
  String get temperatureRangeUpdated =>
      'Temperature range updated successfully';

  @override
  String get editTemperatureRange => 'Edit Temperature Range';

  @override
  String get noStoragesAssigned => 'No storages assigned to you';

  @override
  String get bookingRequests => 'Booking Requests';

  @override
  String get manageStorageRequests => 'Manage storage requests';

  @override
  String get underDevelopment => 'Under Development';

  @override
  String get featureComingSoon =>
      'This feature is coming soon!\\nBooking requests and approvals will be available here.';

  @override
  String get versionFeature => 'Version 2.0 Feature';

  @override
  String errorLoadingRooms(String error) {
    return 'Error loading rooms: $error';
  }

  @override
  String get pleaseSelectRoom => 'Please select a room';

  @override
  String get pleaseEnterTemperature => 'Please enter temperature';

  @override
  String get tempLoggedSuccess =>
      '✓ Temperature logged successfully - Within range';

  @override
  String get tempLoggedWarning =>
      '⚠ Temperature logged - Warning: Out of range';

  @override
  String get tempLoggedCritical =>
      '⚠ Temperature logged - CRITICAL: Alert created';

  @override
  String errorLoggingTemp(String error) {
    return 'Error logging temperature: $error';
  }

  @override
  String get noStorageRoomsAssigned => 'No storage rooms assigned';

  @override
  String get contactManager => 'Please contact your manager';

  @override
  String get selectRoomInstruction =>
      'Select a room and enter the current temperature reading';

  @override
  String get selectStorageRoomRequired => 'Select Storage Room *';

  @override
  String get chooseRoom => 'Choose a room';

  @override
  String get temperatureCelsius => 'Temperature (°C) *';

  @override
  String get enterTempHint => 'Enter temperature (e.g., -2.5)';

  @override
  String get celsiusUnit => '°C';

  @override
  String get logTemperature => 'Log Temperature';

  @override
  String get assignedRooms => 'Assigned Rooms';
}
