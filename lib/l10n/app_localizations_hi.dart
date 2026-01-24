// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'कोल्डवन';

  @override
  String get storageLogin => 'स्टोरेज लॉगिन';

  @override
  String get phoneNumber => 'फ़ोन नंबर';

  @override
  String get enterPhoneNumber => 'फ़ोन नंबर दर्ज करें';

  @override
  String get enterMobileNumber => 'मोबाइल नंबर दर्ज करें';

  @override
  String get getOTP => 'OTP प्राप्त करें';

  @override
  String get sendOTP => 'OTP भेजें';

  @override
  String get enterOTP => 'OTP दर्ज करें';

  @override
  String get verify => 'सत्यापित करें';

  @override
  String get verifyOTP => 'OTP सत्यापित करें';

  @override
  String get logout => 'लॉग आउट';

  @override
  String get continueText => 'जारी रखें';

  @override
  String get chooseLanguage => 'अपनी पसंदीदा भाषा चुनें';

  @override
  String get changeLanguageLater => 'आप इसे बाद में सेटिंग्स में बदल सकते हैं';

  @override
  String get languageComingSoon =>
      'यह भाषा जल्द आ रही है! कृपया अभी अंग्रेज़ी चुनें।';

  @override
  String get selectRole => 'भूमिका चुनें';

  @override
  String get operator => 'ऑपरेटर';

  @override
  String get operatorDescription => 'दैनिक कार्यों को संभालता है';

  @override
  String get technician => 'तकनीशियन';

  @override
  String get technicianDescription => 'तकनीकी पहलुओं का प्रबंधन करता है';

  @override
  String get manager => 'प्रबंधक';

  @override
  String get managerDescription => 'टीम और संचालन की देखरेख करता है';

  @override
  String get owner => 'मालिक';

  @override
  String get ownerDescription => 'पूर्ण पहुंच और नियंत्रण';

  @override
  String get admin => 'व्यवस्थापक';

  @override
  String get secureLogin => 'स्टोरेज संचालन के लिए सुरक्षित लॉगिन';

  @override
  String get pleaseEnterPhone => 'कृपया अपना फ़ोन नंबर दर्ज करें';

  @override
  String get pleaseEnterValidPhone => 'कृपया एक वैध फ़ोन नंबर दर्ज करें';

  @override
  String get unauthorizedContact =>
      'अनधिकृत: कृपया पंजीकरण के लिए अपने व्यवस्थापक से संपर्क करें।';

  @override
  String get enterOTPCode => 'इस नंबर पर भेजा गया 6 अंकों का कोड दर्ज करें';

  @override
  String get pleaseEnterCompleteOTP => 'कृपया पूरा OTP दर्ज करें';

  @override
  String get otpSentSuccess => 'OTP सफलतापूर्वक भेजा गया';

  @override
  String get goBack => 'वापस जाएं?';

  @override
  String get goBackConfirm =>
      'क्या आप वापस जाकर अपना फ़ोन नंबर या भूमिका बदलना चाहते हैं?';

  @override
  String get changePhone => 'फ़ोन बदलें';

  @override
  String get changeRole => 'भूमिका बदलें';

  @override
  String resendOTPIn(int seconds) {
    return '$seconds सेकंड में OTP पुनः भेजें';
  }

  @override
  String get resendOTP => 'OTP पुनः भेजें';

  @override
  String debugOTP(String otp) {
    return 'डीबग OTP: $otp';
  }

  @override
  String get accessPending => 'पहुंच लंबित';

  @override
  String get accountCreatedNoAccess =>
      'आपका खाता बना दिया गया है लेकिन आपको अभी पहुंच नहीं है।';

  @override
  String get contactAdminTo => 'कृपया अपने व्यवस्थापक से संपर्क करें:';

  @override
  String get assignRole => 'आपको एक भूमिका सौंपें (ऑपरेटर/प्रबंधक)';

  @override
  String get activateAccount => 'अपना खाता सक्रिय करें';

  @override
  String get phone => 'फ़ोन';

  @override
  String get statusLabel => 'स्थिति';

  @override
  String get roleLabel => 'भूमिका';

  @override
  String get notAssigned => 'नियुक्त नहीं';

  @override
  String get logoutTryAgain => 'लॉगआउट करें और पुनः प्रयास करें';

  @override
  String get dashboard => 'डैशबोर्ड';

  @override
  String get requests => 'अनुरोध';

  @override
  String get inventory => 'इन्वेंटरी';

  @override
  String get staff => 'कर्मचारी';

  @override
  String get rooms => 'कमरे';

  @override
  String get alerts => 'अलर्ट';

  @override
  String get reports => 'रिपोर्ट';

  @override
  String get temp => 'तापमान';

  @override
  String get ledger => 'खाता बही';

  @override
  String get payments => 'भुगतान';

  @override
  String get profile => 'प्रोफ़ाइल';

  @override
  String get operatorMenu => 'ऑपरेटर मेनू';

  @override
  String get selectOperation => 'संचालन चुनें';

  @override
  String get inwardEntry => 'आवक प्रवेश';

  @override
  String get stockLoadingEntry => 'स्टॉक लोडिंग प्रवेश';

  @override
  String get outwardEntry => 'जावक प्रवेश';

  @override
  String get stockUnloadingEntry => 'स्टॉक अनलोडिंग प्रवेश';

  @override
  String get technicianMenu => 'तकनीशियन मेनू';

  @override
  String get temperatureMonitoring => 'तापमान निगरानी';

  @override
  String get monitorRoomTemp => 'कमरे के तापमान की निगरानी करें';

  @override
  String get coldStorages => 'कोल्ड स्टोरेज';

  @override
  String get addColdStorage => 'कोल्ड स्टोरेज जोड़ें';

  @override
  String get coldStorageName => 'कोल्ड स्टोरेज का नाम';

  @override
  String get coldStorageCode => 'कोल्ड स्टोरेज कोड';

  @override
  String get location => 'स्थान';

  @override
  String get totalCapacity => 'कुल क्षमता';

  @override
  String get availableCapacity => 'उपलब्ध क्षमता';

  @override
  String get temperature => 'तापमान';

  @override
  String get status => 'स्थिति';

  @override
  String get active => 'सक्रिय';

  @override
  String get inactive => 'निष्क्रिय';

  @override
  String get staffManagement => 'कर्मचारी प्रबंधन';

  @override
  String get addStaffMember => 'कर्मचारी जोड़ें';

  @override
  String get name => 'नाम';

  @override
  String get role => 'भूमिका';

  @override
  String get assignStorages => 'स्टोरेज आवंटित करें';

  @override
  String get assignRooms => 'कमरे आवंटित करें';

  @override
  String get inwardOutwardOperator => 'आवक/जावक संचालक';

  @override
  String get technicianTemp => 'तकनीशियन (तापमान)';

  @override
  String get roomManagement => 'कमरा प्रबंधन';

  @override
  String get addRoom => 'कमरा जोड़ें';

  @override
  String get roomName => 'कमरे का नाम';

  @override
  String get roomNumber => 'कमरा नंबर';

  @override
  String get capacity => 'क्षमता';

  @override
  String get currentOccupancy => 'वर्तमान अधिभोग';

  @override
  String get temperatureAlerts => 'तापमान अलर्ट';

  @override
  String get critical => 'गंभीर';

  @override
  String get warning => 'चेतावनी';

  @override
  String get normal => 'सामान्य';

  @override
  String get resolveAlert => 'अलर्ट समाधान करें';

  @override
  String get productName => 'उत्पाद का नाम';

  @override
  String get quantity => 'मात्रा';

  @override
  String get unit => 'इकाई';

  @override
  String get customerName => 'ग्राहक का नाम';

  @override
  String get entryDate => 'प्रवेश तिथि';

  @override
  String get exitDate => 'निकास तिथि';

  @override
  String get save => 'सहेजें';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get delete => 'हटाएं';

  @override
  String get edit => 'संपादित करें';

  @override
  String get add => 'जोड़ें';

  @override
  String get update => 'अपडेट करें';

  @override
  String get search => 'खोजें';

  @override
  String get filter => 'फ़िल्टर';

  @override
  String get refresh => 'ताज़ा करें';

  @override
  String get error => 'त्रुटि';

  @override
  String get success => 'सफलता';

  @override
  String get loading => 'लोड हो रहा है...';

  @override
  String get noDataAvailable => 'कोई डेटा उपलब्ध नहीं';

  @override
  String get confirmDelete => 'क्या आप वाकई हटाना चाहते हैं?';

  @override
  String get kg => 'किग्रा';

  @override
  String get tons => 'टन';

  @override
  String get liters => 'लीटर';

  @override
  String get units => 'इकाइयाँ';

  @override
  String get selectLanguage => 'भाषा चुनें';

  @override
  String get english => 'English';

  @override
  String get hindi => 'हिंदी';

  @override
  String get apiBaseUrl => 'API बेस URL';

  @override
  String get apiBaseUrlExample => 'उदाहरण: http://127.0.0.1:8000';

  @override
  String get saveApiUrl => 'API URL सहेजें';

  @override
  String get baseUrlSaved => 'बेस URL सहेजा गया';

  @override
  String get manageUsers => 'उपयोगकर्ता प्रबंधित करें';
}
