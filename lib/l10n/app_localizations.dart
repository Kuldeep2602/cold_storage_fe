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
