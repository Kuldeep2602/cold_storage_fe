import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'ColdOne'**
  String get appTitle;

  /// No description provided for @storageLogin.
  ///
  /// In en, this message translates to:
  /// **'Storage Login'**
  String get storageLogin;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @enterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter phone number'**
  String get enterPhoneNumber;

  /// No description provided for @enterMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter mobile number'**
  String get enterMobileNumber;

  /// No description provided for @getOTP.
  ///
  /// In en, this message translates to:
  /// **'Get OTP'**
  String get getOTP;

  /// No description provided for @sendOTP.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendOTP;

  /// No description provided for @enterOTP.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP'**
  String get enterOTP;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @verifyOTP.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get verifyOTP;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @continueText.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueText;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred language'**
  String get chooseLanguage;

  /// No description provided for @changeLanguageLater.
  ///
  /// In en, this message translates to:
  /// **'You can change this later in settings'**
  String get changeLanguageLater;

  /// No description provided for @languageComingSoon.
  ///
  /// In en, this message translates to:
  /// **'This language is coming soon! Please select English for now.'**
  String get languageComingSoon;

  /// No description provided for @selectRole.
  ///
  /// In en, this message translates to:
  /// **'Select role'**
  String get selectRole;

  /// No description provided for @operator.
  ///
  /// In en, this message translates to:
  /// **'Operator'**
  String get operator;

  /// No description provided for @operatorDescription.
  ///
  /// In en, this message translates to:
  /// **'Handles day-to-day operations'**
  String get operatorDescription;

  /// No description provided for @technician.
  ///
  /// In en, this message translates to:
  /// **'Technician'**
  String get technician;

  /// No description provided for @technicianDescription.
  ///
  /// In en, this message translates to:
  /// **'Manages technical aspects'**
  String get technicianDescription;

  /// No description provided for @manager.
  ///
  /// In en, this message translates to:
  /// **'Manager'**
  String get manager;

  /// No description provided for @managerDescription.
  ///
  /// In en, this message translates to:
  /// **'Oversees team and operations'**
  String get managerDescription;

  /// No description provided for @owner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get owner;

  /// No description provided for @ownerDescription.
  ///
  /// In en, this message translates to:
  /// **'Full access and control'**
  String get ownerDescription;

  /// No description provided for @admin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get admin;

  /// No description provided for @secureLogin.
  ///
  /// In en, this message translates to:
  /// **'Secure login for storage operations'**
  String get secureLogin;

  /// No description provided for @pleaseEnterPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get pleaseEnterPhone;

  /// No description provided for @pleaseEnterValidPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get pleaseEnterValidPhone;

  /// No description provided for @unauthorizedContact.
  ///
  /// In en, this message translates to:
  /// **'Unauthorized: Please contact your administrator to register.'**
  String get unauthorizedContact;

  /// No description provided for @enterOTPCode.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code sent to'**
  String get enterOTPCode;

  /// No description provided for @pleaseEnterCompleteOTP.
  ///
  /// In en, this message translates to:
  /// **'Please enter complete OTP'**
  String get pleaseEnterCompleteOTP;

  /// No description provided for @otpSentSuccess.
  ///
  /// In en, this message translates to:
  /// **'OTP sent successfully'**
  String get otpSentSuccess;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go Back?'**
  String get goBack;

  /// No description provided for @goBackConfirm.
  ///
  /// In en, this message translates to:
  /// **'Do you want to go back and change your phone number or role?'**
  String get goBackConfirm;

  /// No description provided for @changePhone.
  ///
  /// In en, this message translates to:
  /// **'Change Phone'**
  String get changePhone;

  /// No description provided for @changeRole.
  ///
  /// In en, this message translates to:
  /// **'Change Role'**
  String get changeRole;

  /// No description provided for @resendOTPIn.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP in {seconds}s'**
  String resendOTPIn(int seconds);

  /// No description provided for @resendOTP.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get resendOTP;

  /// No description provided for @debugOTP.
  ///
  /// In en, this message translates to:
  /// **'Debug OTP: {otp}'**
  String debugOTP(String otp);

  /// No description provided for @accessPending.
  ///
  /// In en, this message translates to:
  /// **'Access Pending'**
  String get accessPending;

  /// No description provided for @accountCreatedNoAccess.
  ///
  /// In en, this message translates to:
  /// **'Your account has been created but you don\'t have access yet.'**
  String get accountCreatedNoAccess;

  /// No description provided for @contactAdminTo.
  ///
  /// In en, this message translates to:
  /// **'Please contact your administrator to:'**
  String get contactAdminTo;

  /// No description provided for @assignRole.
  ///
  /// In en, this message translates to:
  /// **'Assign you a role (Operator/Manager)'**
  String get assignRole;

  /// No description provided for @activateAccount.
  ///
  /// In en, this message translates to:
  /// **'Activate your account'**
  String get activateAccount;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @statusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get statusLabel;

  /// No description provided for @roleLabel.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get roleLabel;

  /// No description provided for @notAssigned.
  ///
  /// In en, this message translates to:
  /// **'Not Assigned'**
  String get notAssigned;

  /// No description provided for @logoutTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Logout & Try Again'**
  String get logoutTryAgain;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @requests.
  ///
  /// In en, this message translates to:
  /// **'Requests'**
  String get requests;

  /// No description provided for @inventory.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get inventory;

  /// No description provided for @staff.
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get staff;

  /// No description provided for @rooms.
  ///
  /// In en, this message translates to:
  /// **'Rooms'**
  String get rooms;

  /// No description provided for @alerts.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get alerts;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @temp.
  ///
  /// In en, this message translates to:
  /// **'Temp'**
  String get temp;

  /// No description provided for @ledger.
  ///
  /// In en, this message translates to:
  /// **'Ledger'**
  String get ledger;

  /// No description provided for @payments.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get payments;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @operatorMenu.
  ///
  /// In en, this message translates to:
  /// **'Operator Menu'**
  String get operatorMenu;

  /// No description provided for @selectOperation.
  ///
  /// In en, this message translates to:
  /// **'Select operation'**
  String get selectOperation;

  /// No description provided for @inwardEntry.
  ///
  /// In en, this message translates to:
  /// **'Inward Entry'**
  String get inwardEntry;

  /// No description provided for @stockLoadingEntry.
  ///
  /// In en, this message translates to:
  /// **'Stock loading entry'**
  String get stockLoadingEntry;

  /// No description provided for @outwardEntry.
  ///
  /// In en, this message translates to:
  /// **'Outward Entry'**
  String get outwardEntry;

  /// No description provided for @stockUnloadingEntry.
  ///
  /// In en, this message translates to:
  /// **'Stock unloading entry'**
  String get stockUnloadingEntry;

  /// No description provided for @technicianMenu.
  ///
  /// In en, this message translates to:
  /// **'Technician Menu'**
  String get technicianMenu;

  /// No description provided for @temperatureMonitoring.
  ///
  /// In en, this message translates to:
  /// **'Temperature Monitoring'**
  String get temperatureMonitoring;

  /// No description provided for @monitorRoomTemp.
  ///
  /// In en, this message translates to:
  /// **'Monitor room temperatures'**
  String get monitorRoomTemp;

  /// No description provided for @coldStorages.
  ///
  /// In en, this message translates to:
  /// **'Cold Storages'**
  String get coldStorages;

  /// No description provided for @addColdStorage.
  ///
  /// In en, this message translates to:
  /// **'Add Cold Storage'**
  String get addColdStorage;

  /// No description provided for @coldStorageName.
  ///
  /// In en, this message translates to:
  /// **'Cold Storage Name'**
  String get coldStorageName;

  /// No description provided for @coldStorageCode.
  ///
  /// In en, this message translates to:
  /// **'Cold Storage Code'**
  String get coldStorageCode;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @totalCapacity.
  ///
  /// In en, this message translates to:
  /// **'Total Capacity'**
  String get totalCapacity;

  /// No description provided for @availableCapacity.
  ///
  /// In en, this message translates to:
  /// **'Available Capacity'**
  String get availableCapacity;

  /// No description provided for @temperature.
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get temperature;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @staffManagement.
  ///
  /// In en, this message translates to:
  /// **'Staff Management'**
  String get staffManagement;

  /// No description provided for @addStaffMember.
  ///
  /// In en, this message translates to:
  /// **'Add Staff Member'**
  String get addStaffMember;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// No description provided for @assignStorages.
  ///
  /// In en, this message translates to:
  /// **'Assign Storages'**
  String get assignStorages;

  /// No description provided for @assignRooms.
  ///
  /// In en, this message translates to:
  /// **'Assign Rooms'**
  String get assignRooms;

  /// No description provided for @inwardOutwardOperator.
  ///
  /// In en, this message translates to:
  /// **'Inward/Outward Operator'**
  String get inwardOutwardOperator;

  /// No description provided for @technicianTemp.
  ///
  /// In en, this message translates to:
  /// **'Technician (Temperature)'**
  String get technicianTemp;

  /// No description provided for @roomManagement.
  ///
  /// In en, this message translates to:
  /// **'Room Management'**
  String get roomManagement;

  /// No description provided for @addRoom.
  ///
  /// In en, this message translates to:
  /// **'Add Room'**
  String get addRoom;

  /// No description provided for @roomName.
  ///
  /// In en, this message translates to:
  /// **'Room Name'**
  String get roomName;

  /// No description provided for @roomNumber.
  ///
  /// In en, this message translates to:
  /// **'Room Number'**
  String get roomNumber;

  /// No description provided for @capacity.
  ///
  /// In en, this message translates to:
  /// **'Capacity'**
  String get capacity;

  /// No description provided for @currentOccupancy.
  ///
  /// In en, this message translates to:
  /// **'Current Occupancy'**
  String get currentOccupancy;

  /// No description provided for @temperatureAlerts.
  ///
  /// In en, this message translates to:
  /// **'Temperature Alerts'**
  String get temperatureAlerts;

  /// No description provided for @critical.
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get critical;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @normal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get normal;

  /// No description provided for @resolveAlert.
  ///
  /// In en, this message translates to:
  /// **'Resolve Alert'**
  String get resolveAlert;

  /// No description provided for @productName.
  ///
  /// In en, this message translates to:
  /// **'Product Name'**
  String get productName;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @unit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unit;

  /// No description provided for @customerName.
  ///
  /// In en, this message translates to:
  /// **'Customer Name'**
  String get customerName;

  /// No description provided for @entryDate.
  ///
  /// In en, this message translates to:
  /// **'Entry Date'**
  String get entryDate;

  /// No description provided for @exitDate.
  ///
  /// In en, this message translates to:
  /// **'Exit Date'**
  String get exitDate;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @noDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noDataAvailable;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete?'**
  String get confirmDelete;

  /// No description provided for @kg.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get kg;

  /// No description provided for @tons.
  ///
  /// In en, this message translates to:
  /// **'tons'**
  String get tons;

  /// No description provided for @liters.
  ///
  /// In en, this message translates to:
  /// **'liters'**
  String get liters;

  /// No description provided for @units.
  ///
  /// In en, this message translates to:
  /// **'units'**
  String get units;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get days;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @hindi.
  ///
  /// In en, this message translates to:
  /// **'हिंदी'**
  String get hindi;

  /// No description provided for @apiBaseUrl.
  ///
  /// In en, this message translates to:
  /// **'API base URL'**
  String get apiBaseUrl;

  /// No description provided for @apiBaseUrlExample.
  ///
  /// In en, this message translates to:
  /// **'Example: http://127.0.0.1:8000'**
  String get apiBaseUrlExample;

  /// No description provided for @saveApiUrl.
  ///
  /// In en, this message translates to:
  /// **'Save API URL'**
  String get saveApiUrl;

  /// No description provided for @baseUrlSaved.
  ///
  /// In en, this message translates to:
  /// **'Base URL saved'**
  String get baseUrlSaved;

  /// No description provided for @manageUsers.
  ///
  /// In en, this message translates to:
  /// **'Manage users'**
  String get manageUsers;

  /// No description provided for @partyFarmerSelection.
  ///
  /// In en, this message translates to:
  /// **'1. Party / Farmer Selection'**
  String get partyFarmerSelection;

  /// No description provided for @searchParty.
  ///
  /// In en, this message translates to:
  /// **'Search Party'**
  String get searchParty;

  /// No description provided for @searchByNameOrPhone.
  ///
  /// In en, this message translates to:
  /// **'Search by name or phone'**
  String get searchByNameOrPhone;

  /// No description provided for @viewAllParties.
  ///
  /// In en, this message translates to:
  /// **'View all parties'**
  String get viewAllParties;

  /// No description provided for @selectParty.
  ///
  /// In en, this message translates to:
  /// **'Select Party'**
  String get selectParty;

  /// No description provided for @noPartiesFound.
  ///
  /// In en, this message translates to:
  /// **'No parties found'**
  String get noPartiesFound;

  /// No description provided for @registerNewParty.
  ///
  /// In en, this message translates to:
  /// **'Register New Party'**
  String get registerNewParty;

  /// No description provided for @partyRegisteredSuccess.
  ///
  /// In en, this message translates to:
  /// **'Party \"{name}\" registered successfully!'**
  String partyRegisteredSuccess(String name);

  /// No description provided for @cropDetails.
  ///
  /// In en, this message translates to:
  /// **'2. Crop Details'**
  String get cropDetails;

  /// No description provided for @cropType.
  ///
  /// In en, this message translates to:
  /// **'Crop Type'**
  String get cropType;

  /// No description provided for @enterCropName.
  ///
  /// In en, this message translates to:
  /// **'Enter crop name'**
  String get enterCropName;

  /// No description provided for @qualityGradeOptional.
  ///
  /// In en, this message translates to:
  /// **'Quality Grade (Optional)'**
  String get qualityGradeOptional;

  /// No description provided for @gradeA.
  ///
  /// In en, this message translates to:
  /// **'Grade A'**
  String get gradeA;

  /// No description provided for @gradeB.
  ///
  /// In en, this message translates to:
  /// **'Grade B'**
  String get gradeB;

  /// No description provided for @gradeC.
  ///
  /// In en, this message translates to:
  /// **'Grade C'**
  String get gradeC;

  /// No description provided for @sizeOptional.
  ///
  /// In en, this message translates to:
  /// **'Size (Optional)'**
  String get sizeOptional;

  /// No description provided for @sizeHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Small, Medium, Large, 45mm'**
  String get sizeHint;

  /// No description provided for @quantityDetails.
  ///
  /// In en, this message translates to:
  /// **'3. Quantity Details'**
  String get quantityDetails;

  /// No description provided for @enterQuantityIn.
  ///
  /// In en, this message translates to:
  /// **'Enter quantity in {unit}'**
  String enterQuantityIn(String unit);

  /// No description provided for @visualRecord.
  ///
  /// In en, this message translates to:
  /// **'4. Visual Record'**
  String get visualRecord;

  /// No description provided for @uploadImageOfGoods.
  ///
  /// In en, this message translates to:
  /// **'Upload Image of Goods'**
  String get uploadImageOfGoods;

  /// No description provided for @tapToCaptureOrUpload.
  ///
  /// In en, this message translates to:
  /// **'Tap to capture or upload'**
  String get tapToCaptureOrUpload;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get chooseFromGallery;

  /// No description provided for @errorPickingImage.
  ///
  /// In en, this message translates to:
  /// **'Error picking image'**
  String get errorPickingImage;

  /// No description provided for @storageDetails.
  ///
  /// In en, this message translates to:
  /// **'5. Storage Details'**
  String get storageDetails;

  /// No description provided for @storageFacility.
  ///
  /// In en, this message translates to:
  /// **'Storage Facility'**
  String get storageFacility;

  /// No description provided for @storageRoom.
  ///
  /// In en, this message translates to:
  /// **'Storage Room'**
  String get storageRoom;

  /// No description provided for @selectStorageRoom.
  ///
  /// In en, this message translates to:
  /// **'Select storage room'**
  String get selectStorageRoom;

  /// No description provided for @noStorageRoomsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No storage rooms available for your assigned facility. Please contact manager.'**
  String get noStorageRoomsAvailable;

  /// No description provided for @storageDuration.
  ///
  /// In en, this message translates to:
  /// **'Storage Duration'**
  String get storageDuration;

  /// No description provided for @sixtyDays.
  ///
  /// In en, this message translates to:
  /// **'60 Days'**
  String get sixtyDays;

  /// No description provided for @ninetyDays.
  ///
  /// In en, this message translates to:
  /// **'90 Days'**
  String get ninetyDays;

  /// No description provided for @oneYear.
  ///
  /// In en, this message translates to:
  /// **'1 Year'**
  String get oneYear;

  /// No description provided for @enterDays.
  ///
  /// In en, this message translates to:
  /// **'Enter days'**
  String get enterDays;

  /// No description provided for @saveInwardEntry.
  ///
  /// In en, this message translates to:
  /// **'Save Inward Entry'**
  String get saveInwardEntry;

  /// No description provided for @entrySaved.
  ///
  /// In en, this message translates to:
  /// **'Entry Saved'**
  String get entrySaved;

  /// No description provided for @inwardEntrySuccess.
  ///
  /// In en, this message translates to:
  /// **'Inward entry has been successfully recorded.'**
  String get inwardEntrySuccess;

  /// No description provided for @downloadReceipt.
  ///
  /// In en, this message translates to:
  /// **'Download Receipt'**
  String get downloadReceipt;

  /// No description provided for @pleaseSelectParty.
  ///
  /// In en, this message translates to:
  /// **'Please select a party/farmer'**
  String get pleaseSelectParty;

  /// No description provided for @pleaseSelectStorageRoom.
  ///
  /// In en, this message translates to:
  /// **'Please select a storage room'**
  String get pleaseSelectStorageRoom;

  /// No description provided for @noStorageAssigned.
  ///
  /// In en, this message translates to:
  /// **'Error: No Storage assigned to this operator.'**
  String get noStorageAssigned;

  /// No description provided for @selectBookingParty.
  ///
  /// In en, this message translates to:
  /// **'1. Select Booking / Party'**
  String get selectBookingParty;

  /// No description provided for @searchStoredInventory.
  ///
  /// In en, this message translates to:
  /// **'Search Stored Inventory'**
  String get searchStoredInventory;

  /// No description provided for @searchByPartyPhoneCrop.
  ///
  /// In en, this message translates to:
  /// **'Search by party, phone, or crop'**
  String get searchByPartyPhoneCrop;

  /// No description provided for @noInventoryFound.
  ///
  /// In en, this message translates to:
  /// **'No inventory found'**
  String get noInventoryFound;

  /// No description provided for @availableInventory.
  ///
  /// In en, this message translates to:
  /// **'Available Inventory'**
  String get availableInventory;

  /// No description provided for @itemsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} items'**
  String itemsCount(int count);

  /// No description provided for @party.
  ///
  /// In en, this message translates to:
  /// **'Party'**
  String get party;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @quantityToRemove.
  ///
  /// In en, this message translates to:
  /// **'Quantity to remove'**
  String get quantityToRemove;

  /// No description provided for @enterQuantity.
  ///
  /// In en, this message translates to:
  /// **'Enter quantity'**
  String get enterQuantity;

  /// No description provided for @confirmOutward.
  ///
  /// In en, this message translates to:
  /// **'Confirm Outward'**
  String get confirmOutward;

  /// No description provided for @outwardRecorded.
  ///
  /// In en, this message translates to:
  /// **'Outward Recorded'**
  String get outwardRecorded;

  /// No description provided for @outwardReceiptGenerated.
  ///
  /// In en, this message translates to:
  /// **'Outward receipt #{number} generated.'**
  String outwardReceiptGenerated(String number);

  /// No description provided for @pleaseEnterValidQuantity.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid quantity'**
  String get pleaseEnterValidQuantity;

  /// No description provided for @quantityExceedsStock.
  ///
  /// In en, this message translates to:
  /// **'Quantity exceeds available stock ({available})'**
  String quantityExceedsStock(String available);

  /// No description provided for @processingOutwardEntry.
  ///
  /// In en, this message translates to:
  /// **'Processing outward entry...'**
  String get processingOutwardEntry;

  /// No description provided for @errorLoadingInventory.
  ///
  /// In en, this message translates to:
  /// **'Error loading inventory'**
  String get errorLoadingInventory;

  /// No description provided for @quickRegistration.
  ///
  /// In en, this message translates to:
  /// **'Quick registration - takes less than 30 seconds'**
  String get quickRegistration;

  /// No description provided for @enterFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter full name'**
  String get enterFullName;

  /// No description provided for @partyType.
  ///
  /// In en, this message translates to:
  /// **'Party Type'**
  String get partyType;

  /// No description provided for @farmer.
  ///
  /// In en, this message translates to:
  /// **'Farmer'**
  String get farmer;

  /// No description provided for @traderCompany.
  ///
  /// In en, this message translates to:
  /// **'Trader / Co.'**
  String get traderCompany;

  /// No description provided for @transporter.
  ///
  /// In en, this message translates to:
  /// **'Transporter'**
  String get transporter;

  /// No description provided for @coldStorage.
  ///
  /// In en, this message translates to:
  /// **'Cold Storage'**
  String get coldStorage;

  /// No description provided for @pleaseSelectColdStorage.
  ///
  /// In en, this message translates to:
  /// **'Please select a cold storage'**
  String get pleaseSelectColdStorage;

  /// No description provided for @storage.
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get storage;

  /// No description provided for @villageCity.
  ///
  /// In en, this message translates to:
  /// **'Village / City'**
  String get villageCity;

  /// No description provided for @enterVillageOrCity.
  ///
  /// In en, this message translates to:
  /// **'Enter village or city name'**
  String get enterVillageOrCity;

  /// No description provided for @gstNumberOptional.
  ///
  /// In en, this message translates to:
  /// **'GST Number (Optional)'**
  String get gstNumberOptional;

  /// No description provided for @notesOptional.
  ///
  /// In en, this message translates to:
  /// **'Notes (Optional)'**
  String get notesOptional;

  /// No description provided for @addNotes.
  ///
  /// In en, this message translates to:
  /// **'Add any additional notes...'**
  String get addNotes;

  /// No description provided for @saveParty.
  ///
  /// In en, this message translates to:
  /// **'Save Party'**
  String get saveParty;

  /// No description provided for @ownerOverview.
  ///
  /// In en, this message translates to:
  /// **'Owner Overview'**
  String get ownerOverview;

  /// No description provided for @highLevelMetrics.
  ///
  /// In en, this message translates to:
  /// **'High-level business metrics'**
  String get highLevelMetrics;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @storages.
  ///
  /// In en, this message translates to:
  /// **'Storages'**
  String get storages;

  /// No description provided for @noStorages.
  ///
  /// In en, this message translates to:
  /// **'No storages'**
  String get noStorages;

  /// No description provided for @selectStorage.
  ///
  /// In en, this message translates to:
  /// **'Select Storage'**
  String get selectStorage;

  /// No description provided for @storageUtilization.
  ///
  /// In en, this message translates to:
  /// **'Storage Utilization'**
  String get storageUtilization;

  /// No description provided for @ofCapacity.
  ///
  /// In en, this message translates to:
  /// **'of capacity'**
  String get ofCapacity;

  /// No description provided for @mtOccupied.
  ///
  /// In en, this message translates to:
  /// **'{value} MT occupied'**
  String mtOccupied(String value);

  /// No description provided for @mtTotal.
  ///
  /// In en, this message translates to:
  /// **'{value} MT total'**
  String mtTotal(String value);

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// No description provided for @inflow.
  ///
  /// In en, this message translates to:
  /// **'Inflow'**
  String get inflow;

  /// No description provided for @mtReceived.
  ///
  /// In en, this message translates to:
  /// **'MT received'**
  String get mtReceived;

  /// No description provided for @outflow.
  ///
  /// In en, this message translates to:
  /// **'Outflow'**
  String get outflow;

  /// No description provided for @mtDispatched.
  ///
  /// In en, this message translates to:
  /// **'MT dispatched'**
  String get mtDispatched;

  /// No description provided for @activeBookings.
  ///
  /// In en, this message translates to:
  /// **'Active Bookings'**
  String get activeBookings;

  /// No description provided for @confirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get confirmed;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @alertSummary.
  ///
  /// In en, this message translates to:
  /// **'Alert Summary'**
  String get alertSummary;

  /// No description provided for @roomsOutOfRange.
  ///
  /// In en, this message translates to:
  /// **'{count} rooms out of range'**
  String roomsOutOfRange(int count);

  /// No description provided for @allRoomsNormal.
  ///
  /// In en, this message translates to:
  /// **'All rooms normal'**
  String get allRoomsNormal;

  /// No description provided for @equipmentStatus.
  ///
  /// In en, this message translates to:
  /// **'Equipment Status'**
  String get equipmentStatus;

  /// No description provided for @allSystemsOperational.
  ///
  /// In en, this message translates to:
  /// **'All systems operational'**
  String get allSystemsOperational;

  /// No description provided for @revenueEst.
  ///
  /// In en, this message translates to:
  /// **'Revenue (Est.)'**
  String get revenueEst;

  /// No description provided for @avgDuration.
  ///
  /// In en, this message translates to:
  /// **'Avg. Duration'**
  String get avgDuration;

  /// No description provided for @manageManagersStaff.
  ///
  /// In en, this message translates to:
  /// **'Manage managers & staff'**
  String get manageManagersStaff;

  /// No description provided for @addNewStaffMember.
  ///
  /// In en, this message translates to:
  /// **'Add New Staff Member'**
  String get addNewStaffMember;

  /// No description provided for @phoneNumberRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone Number *'**
  String get phoneNumberRequired;

  /// No description provided for @phoneHint.
  ///
  /// In en, this message translates to:
  /// **'+91 '**
  String get phoneHint;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name *'**
  String get nameRequired;

  /// No description provided for @enterName.
  ///
  /// In en, this message translates to:
  /// **'Enter name'**
  String get enterName;

  /// No description provided for @roleRequired.
  ///
  /// In en, this message translates to:
  /// **'Role *'**
  String get roleRequired;

  /// No description provided for @fullAccessDescription.
  ///
  /// In en, this message translates to:
  /// **'Full access to manage storages, staff & inventory'**
  String get fullAccessDescription;

  /// No description provided for @inwardOutwardOnly.
  ///
  /// In en, this message translates to:
  /// **'Inward/Outward operations only'**
  String get inwardOutwardOnly;

  /// No description provided for @tempMonitoringAlerts.
  ///
  /// In en, this message translates to:
  /// **'Temperature monitoring & alerts'**
  String get tempMonitoringAlerts;

  /// No description provided for @phoneNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number and name are required'**
  String get phoneNameRequired;

  /// No description provided for @staffAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Staff member added successfully'**
  String get staffAddedSuccess;

  /// No description provided for @addStaff.
  ///
  /// In en, this message translates to:
  /// **'Add Staff'**
  String get addStaff;

  /// No description provided for @editStaffMember.
  ///
  /// In en, this message translates to:
  /// **'Edit Staff Member'**
  String get editStaffMember;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone: {phone}'**
  String phoneLabel(String phone);

  /// No description provided for @fullAccess.
  ///
  /// In en, this message translates to:
  /// **'Full access'**
  String get fullAccess;

  /// No description provided for @inwardOutward.
  ///
  /// In en, this message translates to:
  /// **'Inward/Outward'**
  String get inwardOutward;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @staffUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Staff updated successfully'**
  String get staffUpdatedSuccess;

  /// No description provided for @managers.
  ///
  /// In en, this message translates to:
  /// **'Managers'**
  String get managers;

  /// No description provided for @canManageOperations.
  ///
  /// In en, this message translates to:
  /// **'Can manage storage operations'**
  String get canManageOperations;

  /// No description provided for @operators.
  ///
  /// In en, this message translates to:
  /// **'Operators'**
  String get operators;

  /// No description provided for @inwardOutwardOps.
  ///
  /// In en, this message translates to:
  /// **'Inward/Outward operations'**
  String get inwardOutwardOps;

  /// No description provided for @technicians.
  ///
  /// In en, this message translates to:
  /// **'Technicians'**
  String get technicians;

  /// No description provided for @tempMonitoring.
  ///
  /// In en, this message translates to:
  /// **'Temperature monitoring'**
  String get tempMonitoring;

  /// No description provided for @noRoleAddedYet.
  ///
  /// In en, this message translates to:
  /// **'No {role} added yet'**
  String noRoleAddedYet(String role);

  /// No description provided for @disabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get disabled;

  /// No description provided for @enable.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get enable;

  /// No description provided for @disable.
  ///
  /// In en, this message translates to:
  /// **'Disable'**
  String get disable;

  /// No description provided for @deleteStaff.
  ///
  /// In en, this message translates to:
  /// **'Delete Staff?'**
  String get deleteStaff;

  /// No description provided for @deleteStaffConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {name}? This action cannot be undone.'**
  String deleteStaffConfirm(String name);

  /// No description provided for @staffDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Staff member deleted successfully'**
  String get staffDeletedSuccess;

  /// No description provided for @errorLoadingStaff.
  ///
  /// In en, this message translates to:
  /// **'Error loading staff'**
  String get errorLoadingStaff;

  /// No description provided for @errorLoadingStorages.
  ///
  /// In en, this message translates to:
  /// **'Error loading storages'**
  String get errorLoadingStorages;

  /// No description provided for @manageYourFacilities.
  ///
  /// In en, this message translates to:
  /// **'Manage your facilities'**
  String get manageYourFacilities;

  /// No description provided for @addNewStorage.
  ///
  /// In en, this message translates to:
  /// **'Add New Storage'**
  String get addNewStorage;

  /// No description provided for @addStorage.
  ///
  /// In en, this message translates to:
  /// **'Add Storage'**
  String get addStorage;

  /// No description provided for @editStorage.
  ///
  /// In en, this message translates to:
  /// **'Edit Storage'**
  String get editStorage;

  /// No description provided for @storageType.
  ///
  /// In en, this message translates to:
  /// **'Storage Type'**
  String get storageType;

  /// No description provided for @silos.
  ///
  /// In en, this message translates to:
  /// **'Silos'**
  String get silos;

  /// No description provided for @warehouses.
  ///
  /// In en, this message translates to:
  /// **'Warehouses'**
  String get warehouses;

  /// No description provided for @frozenStorages.
  ///
  /// In en, this message translates to:
  /// **'Frozen Storages'**
  String get frozenStorages;

  /// No description provided for @ripeningChambers.
  ///
  /// In en, this message translates to:
  /// **'Ripening Chambers'**
  String get ripeningChambers;

  /// No description provided for @controlledAtmosphere.
  ///
  /// In en, this message translates to:
  /// **'Controlled Atmosphere Storage'**
  String get controlledAtmosphere;

  /// No description provided for @storageNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Storage Main'**
  String get storageNameHint;

  /// No description provided for @codeRequired.
  ///
  /// In en, this message translates to:
  /// **'Code *'**
  String get codeRequired;

  /// No description provided for @codeHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. STR1'**
  String get codeHint;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @cityHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Nashik'**
  String get cityHint;

  /// No description provided for @totalCapacityMT.
  ///
  /// In en, this message translates to:
  /// **'Total Capacity (MT)'**
  String get totalCapacityMT;

  /// No description provided for @roomsRequired.
  ///
  /// In en, this message translates to:
  /// **'Rooms *'**
  String get roomsRequired;

  /// No description provided for @addAtLeastOneRoom.
  ///
  /// In en, this message translates to:
  /// **'Add at least one room for this storage'**
  String get addAtLeastOneRoom;

  /// No description provided for @roomsHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Room A, Room B, Room C (comma separated)'**
  String get roomsHint;

  /// No description provided for @separateWithCommas.
  ///
  /// In en, this message translates to:
  /// **'Separate multiple rooms with commas'**
  String get separateWithCommas;

  /// No description provided for @nameCodeRequired.
  ///
  /// In en, this message translates to:
  /// **'Name and Code are required'**
  String get nameCodeRequired;

  /// No description provided for @storageDeleted.
  ///
  /// In en, this message translates to:
  /// **'Storage deleted'**
  String get storageDeleted;

  /// No description provided for @atLeastOneRoomRequired.
  ///
  /// In en, this message translates to:
  /// **'At least one room is required'**
  String get atLeastOneRoomRequired;

  /// No description provided for @storageCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Storage created successfully'**
  String get storageCreatedSuccess;

  /// No description provided for @storageUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Storage updated successfully'**
  String get storageUpdatedSuccess;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @yourStoragesCount.
  ///
  /// In en, this message translates to:
  /// **'Your Storages ({count})'**
  String yourStoragesCount(int count);

  /// No description provided for @noStoragesYet.
  ///
  /// In en, this message translates to:
  /// **'No storages yet'**
  String get noStoragesYet;

  /// No description provided for @addFirstStorage.
  ///
  /// In en, this message translates to:
  /// **'Add your first storage facility'**
  String get addFirstStorage;

  /// No description provided for @capacityUsage.
  ///
  /// In en, this message translates to:
  /// **'Capacity Usage'**
  String get capacityUsage;

  /// No description provided for @mtUsed.
  ///
  /// In en, this message translates to:
  /// **'{value} MT used'**
  String mtUsed(String value);

  /// No description provided for @managerLabel.
  ///
  /// In en, this message translates to:
  /// **'Manager:'**
  String get managerLabel;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @assign.
  ///
  /// In en, this message translates to:
  /// **'Assign'**
  String get assign;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @assignManager.
  ///
  /// In en, this message translates to:
  /// **'Assign Manager'**
  String get assignManager;

  /// No description provided for @coldStorageLabel.
  ///
  /// In en, this message translates to:
  /// **'Cold Storage: {name}'**
  String coldStorageLabel(String name);

  /// No description provided for @selectManager.
  ///
  /// In en, this message translates to:
  /// **'Select Manager:'**
  String get selectManager;

  /// No description provided for @noManager.
  ///
  /// In en, this message translates to:
  /// **'No Manager'**
  String get noManager;

  /// No description provided for @managerAssignedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Manager assigned successfully'**
  String get managerAssignedSuccess;

  /// No description provided for @code.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get code;

  /// No description provided for @occupied.
  ///
  /// In en, this message translates to:
  /// **'Occupied'**
  String get occupied;

  /// No description provided for @errorLoadingColdStorages.
  ///
  /// In en, this message translates to:
  /// **'Error loading cold storages'**
  String get errorLoadingColdStorages;

  /// No description provided for @temperatureAlertsSummary.
  ///
  /// In en, this message translates to:
  /// **'Temperature Alerts'**
  String get temperatureAlertsSummary;

  /// No description provided for @allRoomsOperational.
  ///
  /// In en, this message translates to:
  /// **'All rooms operational'**
  String get allRoomsOperational;

  /// No description provided for @roomsNeedAttention.
  ///
  /// In en, this message translates to:
  /// **'rooms need attention'**
  String get roomsNeedAttention;

  /// No description provided for @managerDashboard.
  ///
  /// In en, this message translates to:
  /// **'Manager Dashboard'**
  String get managerDashboard;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {name}'**
  String welcome(String name);

  /// No description provided for @storageLabel.
  ///
  /// In en, this message translates to:
  /// **'Storage: {names}'**
  String storageLabel(String names);

  /// No description provided for @noStorageAssignedTitle.
  ///
  /// In en, this message translates to:
  /// **'No Storage Assigned'**
  String get noStorageAssignedTitle;

  /// No description provided for @contactOwnerMessage.
  ///
  /// In en, this message translates to:
  /// **'Please contact the owner to assign you a storage.'**
  String get contactOwnerMessage;

  /// No description provided for @mt.
  ///
  /// In en, this message translates to:
  /// **'MT'**
  String get mt;

  /// No description provided for @activeEntriesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} active entries'**
  String activeEntriesCount(int count);

  /// No description provided for @inventorySummary.
  ///
  /// In en, this message translates to:
  /// **'Inventory Summary'**
  String get inventorySummary;

  /// No description provided for @viewStoredCrops.
  ///
  /// In en, this message translates to:
  /// **'View stored crops'**
  String get viewStoredCrops;

  /// No description provided for @alertsActiveCount.
  ///
  /// In en, this message translates to:
  /// **'{count} alerts active'**
  String alertsActiveCount(int count);

  /// No description provided for @teamMembersCount.
  ///
  /// In en, this message translates to:
  /// **'{count} team members'**
  String teamMembersCount(int count);

  /// No description provided for @pendingRequests.
  ///
  /// In en, this message translates to:
  /// **'Pending Requests'**
  String get pendingRequests;

  /// No description provided for @awaitingApproval.
  ///
  /// In en, this message translates to:
  /// **'Awaiting approval'**
  String get awaitingApproval;

  /// No description provided for @totalStock.
  ///
  /// In en, this message translates to:
  /// **'Total Stock'**
  String get totalStock;

  /// No description provided for @acrossCropTypes.
  ///
  /// In en, this message translates to:
  /// **'Across {count} crop types'**
  String acrossCropTypes(int count);

  /// No description provided for @addInward.
  ///
  /// In en, this message translates to:
  /// **'Add Inward'**
  String get addInward;

  /// No description provided for @markOutward.
  ///
  /// In en, this message translates to:
  /// **'Mark Outward'**
  String get markOutward;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @inStorage.
  ///
  /// In en, this message translates to:
  /// **'In storage'**
  String get inStorage;

  /// No description provided for @inwardDate.
  ///
  /// In en, this message translates to:
  /// **'Inward Date'**
  String get inwardDate;

  /// No description provided for @expectedOut.
  ///
  /// In en, this message translates to:
  /// **'Expected Out'**
  String get expectedOut;

  /// No description provided for @addAndManageStaff.
  ///
  /// In en, this message translates to:
  /// **'Add and manage storage staff'**
  String get addAndManageStaff;

  /// No description provided for @deleteStaffMember.
  ///
  /// In en, this message translates to:
  /// **'Delete Staff Member'**
  String get deleteStaffMember;

  /// No description provided for @deleteStaffMemberConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this staff member?'**
  String get deleteStaffMemberConfirm;

  /// No description provided for @errorMessage.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String errorMessage(String error);

  /// No description provided for @staffMemberAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Staff member added successfully'**
  String get staffMemberAddedSuccess;

  /// No description provided for @editStaff.
  ///
  /// In en, this message translates to:
  /// **'Edit Staff Member'**
  String get editStaff;

  /// No description provided for @staffMemberUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Staff member updated successfully'**
  String get staffMemberUpdatedSuccess;

  /// No description provided for @staffMembersCount.
  ///
  /// In en, this message translates to:
  /// **'Staff Members ({count})'**
  String staffMembersCount(int count);

  /// No description provided for @noRole.
  ///
  /// In en, this message translates to:
  /// **'No Role'**
  String get noRole;

  /// No description provided for @activeAlertsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} active alerts'**
  String activeAlertsCount(int count);

  /// No description provided for @activeAlerts.
  ///
  /// In en, this message translates to:
  /// **'Active Alerts'**
  String get activeAlerts;

  /// No description provided for @allClear.
  ///
  /// In en, this message translates to:
  /// **'All Clear!'**
  String get allClear;

  /// No description provided for @noActiveAlerts.
  ///
  /// In en, this message translates to:
  /// **'No active temperature alerts'**
  String get noActiveAlerts;

  /// No description provided for @normalStatus.
  ///
  /// In en, this message translates to:
  /// **'Normal Status'**
  String get normalStatus;

  /// No description provided for @unknownRoom.
  ///
  /// In en, this message translates to:
  /// **'Unknown Room'**
  String get unknownRoom;

  /// No description provided for @currentTemp.
  ///
  /// In en, this message translates to:
  /// **'Current Temp'**
  String get currentTemp;

  /// No description provided for @allowedRange.
  ///
  /// In en, this message translates to:
  /// **'Allowed Range'**
  String get allowedRange;

  /// No description provided for @tempRange.
  ///
  /// In en, this message translates to:
  /// **'{min}°C to {max}°C'**
  String tempRange(String min, String max);

  /// No description provided for @takeAction.
  ///
  /// In en, this message translates to:
  /// **'Take Action'**
  String get takeAction;

  /// No description provided for @actionTaken.
  ///
  /// In en, this message translates to:
  /// **'Action - {roomName}'**
  String actionTaken(String roomName);

  /// No description provided for @acknowledge.
  ///
  /// In en, this message translates to:
  /// **'Acknowledge'**
  String get acknowledge;

  /// No description provided for @markAsSeen.
  ///
  /// In en, this message translates to:
  /// **'Mark as seen'**
  String get markAsSeen;

  /// No description provided for @resolve.
  ///
  /// In en, this message translates to:
  /// **'Resolve'**
  String get resolve;

  /// No description provided for @issueFixed.
  ///
  /// In en, this message translates to:
  /// **'Issue has been fixed'**
  String get issueFixed;

  /// No description provided for @alertActionSuccess.
  ///
  /// In en, this message translates to:
  /// **'Alert {action}d successfully'**
  String alertActionSuccess(String action);

  /// No description provided for @withinRange.
  ///
  /// In en, this message translates to:
  /// **'Within range'**
  String get withinRange;

  /// No description provided for @errorLoadingAlerts.
  ///
  /// In en, this message translates to:
  /// **'Error loading alerts: {error}'**
  String errorLoadingAlerts(String error);

  /// No description provided for @roomTemperatureSettings.
  ///
  /// In en, this message translates to:
  /// **'Room Temperature Settings'**
  String get roomTemperatureSettings;

  /// No description provided for @roomsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} rooms'**
  String roomsCount(int count);

  /// No description provided for @noRoomsFound.
  ///
  /// In en, this message translates to:
  /// **'No rooms found'**
  String get noRoomsFound;

  /// No description provided for @addNewRoom.
  ///
  /// In en, this message translates to:
  /// **'Add New Room'**
  String get addNewRoom;

  /// No description provided for @coldStorageRequired.
  ///
  /// In en, this message translates to:
  /// **'Cold Storage *'**
  String get coldStorageRequired;

  /// No description provided for @roomNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Room Name *'**
  String get roomNameRequired;

  /// No description provided for @roomNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Room A'**
  String get roomNameHint;

  /// No description provided for @capacityMT.
  ///
  /// In en, this message translates to:
  /// **'Capacity (MT)'**
  String get capacityMT;

  /// No description provided for @capacityPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'100'**
  String get capacityPlaceholder;

  /// No description provided for @minTemperature.
  ///
  /// In en, this message translates to:
  /// **'Min Temperature (°C)'**
  String get minTemperature;

  /// No description provided for @minTempPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'-5'**
  String get minTempPlaceholder;

  /// No description provided for @maxTemperature.
  ///
  /// In en, this message translates to:
  /// **'Max Temperature (°C)'**
  String get maxTemperature;

  /// No description provided for @maxTempPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'0'**
  String get maxTempPlaceholder;

  /// No description provided for @roomNameStorageRequired.
  ///
  /// In en, this message translates to:
  /// **'Room name and storage are required'**
  String get roomNameStorageRequired;

  /// No description provided for @roomAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Room added successfully'**
  String get roomAddedSuccess;

  /// No description provided for @setTemperatureRange.
  ///
  /// In en, this message translates to:
  /// **'Set Temperature Range'**
  String get setTemperatureRange;

  /// No description provided for @minimumTemperature.
  ///
  /// In en, this message translates to:
  /// **'Minimum Temperature (°C)'**
  String get minimumTemperature;

  /// No description provided for @minTempExample.
  ///
  /// In en, this message translates to:
  /// **'e.g., -5'**
  String get minTempExample;

  /// No description provided for @maximumTemperature.
  ///
  /// In en, this message translates to:
  /// **'Maximum Temperature (°C)'**
  String get maximumTemperature;

  /// No description provided for @maxTempExample.
  ///
  /// In en, this message translates to:
  /// **'e.g., 0'**
  String get maxTempExample;

  /// No description provided for @temperatureAlertInfo.
  ///
  /// In en, this message translates to:
  /// **'Alerts will be created when temperature goes outside this range'**
  String get temperatureAlertInfo;

  /// No description provided for @minLessThanMax.
  ///
  /// In en, this message translates to:
  /// **'Minimum must be less than maximum'**
  String get minLessThanMax;

  /// No description provided for @temperatureRangeUpdated.
  ///
  /// In en, this message translates to:
  /// **'Temperature range updated successfully'**
  String get temperatureRangeUpdated;

  /// No description provided for @editTemperatureRange.
  ///
  /// In en, this message translates to:
  /// **'Edit Temperature Range'**
  String get editTemperatureRange;

  /// No description provided for @noStoragesAssigned.
  ///
  /// In en, this message translates to:
  /// **'No storages assigned to you'**
  String get noStoragesAssigned;

  /// No description provided for @bookingRequests.
  ///
  /// In en, this message translates to:
  /// **'Booking Requests'**
  String get bookingRequests;

  /// No description provided for @manageStorageRequests.
  ///
  /// In en, this message translates to:
  /// **'Manage storage requests'**
  String get manageStorageRequests;

  /// No description provided for @underDevelopment.
  ///
  /// In en, this message translates to:
  /// **'Under Development'**
  String get underDevelopment;

  /// No description provided for @featureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'This feature is coming soon!\\nBooking requests and approvals will be available here.'**
  String get featureComingSoon;

  /// No description provided for @versionFeature.
  ///
  /// In en, this message translates to:
  /// **'Version 2.0 Feature'**
  String get versionFeature;

  /// No description provided for @errorLoadingRooms.
  ///
  /// In en, this message translates to:
  /// **'Error loading rooms: {error}'**
  String errorLoadingRooms(String error);

  /// No description provided for @pleaseSelectRoom.
  ///
  /// In en, this message translates to:
  /// **'Please select a room'**
  String get pleaseSelectRoom;

  /// No description provided for @pleaseEnterTemperature.
  ///
  /// In en, this message translates to:
  /// **'Please enter temperature'**
  String get pleaseEnterTemperature;

  /// No description provided for @tempLoggedSuccess.
  ///
  /// In en, this message translates to:
  /// **'✓ Temperature logged successfully - Within range'**
  String get tempLoggedSuccess;

  /// No description provided for @tempLoggedWarning.
  ///
  /// In en, this message translates to:
  /// **'⚠ Temperature logged - Warning: Out of range'**
  String get tempLoggedWarning;

  /// No description provided for @tempLoggedCritical.
  ///
  /// In en, this message translates to:
  /// **'⚠ Temperature logged - CRITICAL: Alert created'**
  String get tempLoggedCritical;

  /// No description provided for @errorLoggingTemp.
  ///
  /// In en, this message translates to:
  /// **'Error logging temperature: {error}'**
  String errorLoggingTemp(String error);

  /// No description provided for @noStorageRoomsAssigned.
  ///
  /// In en, this message translates to:
  /// **'No storage rooms assigned'**
  String get noStorageRoomsAssigned;

  /// No description provided for @contactManager.
  ///
  /// In en, this message translates to:
  /// **'Please contact your manager'**
  String get contactManager;

  /// No description provided for @selectRoomInstruction.
  ///
  /// In en, this message translates to:
  /// **'Select a room and enter the current temperature reading'**
  String get selectRoomInstruction;

  /// No description provided for @selectStorageRoomRequired.
  ///
  /// In en, this message translates to:
  /// **'Select Storage Room *'**
  String get selectStorageRoomRequired;

  /// No description provided for @chooseRoom.
  ///
  /// In en, this message translates to:
  /// **'Choose a room'**
  String get chooseRoom;

  /// No description provided for @temperatureCelsius.
  ///
  /// In en, this message translates to:
  /// **'Temperature (°C) *'**
  String get temperatureCelsius;

  /// No description provided for @enterTempHint.
  ///
  /// In en, this message translates to:
  /// **'Enter temperature (e.g., -2.5)'**
  String get enterTempHint;

  /// No description provided for @celsiusUnit.
  ///
  /// In en, this message translates to:
  /// **'°C'**
  String get celsiusUnit;

  /// No description provided for @logTemperature.
  ///
  /// In en, this message translates to:
  /// **'Log Temperature'**
  String get logTemperature;

  /// No description provided for @assignedRooms.
  ///
  /// In en, this message translates to:
  /// **'Assigned Rooms'**
  String get assignedRooms;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
