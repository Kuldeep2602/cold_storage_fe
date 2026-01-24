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
  String get inwardEntry => 'आवक प्रविष्टि';

  @override
  String get stockLoadingEntry => 'स्टॉक लोडिंग प्रविष्टि';

  @override
  String get outwardEntry => 'जावक प्रविष्टि';

  @override
  String get stockUnloadingEntry => 'स्टॉक अनलोडिंग प्रविष्टि';

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
  String get close => 'बंद करें';

  @override
  String get required => 'आवश्यक';

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
  String get days => 'दिन';

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

  @override
  String get partyFarmerSelection => '1. पार्टी / किसान चयन';

  @override
  String get searchParty => 'पार्टी खोजें';

  @override
  String get searchByNameOrPhone => 'नाम या फ़ोन से खोजें';

  @override
  String get viewAllParties => 'सभी पार्टियां देखें';

  @override
  String get selectParty => 'पार्टी चुनें';

  @override
  String get noPartiesFound => 'कोई पार्टी नहीं मिली';

  @override
  String get registerNewParty => 'नई पार्टी पंजीकृत करें';

  @override
  String partyRegisteredSuccess(String name) {
    return 'पार्टी \"$name\" सफलतापूर्वक पंजीकृत!';
  }

  @override
  String get cropDetails => '2. फसल विवरण';

  @override
  String get cropType => 'फसल का प्रकार';

  @override
  String get enterCropName => 'फसल का नाम दर्ज करें';

  @override
  String get qualityGradeOptional => 'गुणवत्ता ग्रेड (वैकल्पिक)';

  @override
  String get gradeA => 'ग्रेड A';

  @override
  String get gradeB => 'ग्रेड B';

  @override
  String get gradeC => 'ग्रेड C';

  @override
  String get sizeOptional => 'आकार (वैकल्पिक)';

  @override
  String get sizeHint => 'जैसे छोटा, मध्यम, बड़ा, 45mm';

  @override
  String get quantityDetails => '3. मात्रा विवरण';

  @override
  String enterQuantityIn(String unit) {
    return '$unit में मात्रा दर्ज करें';
  }

  @override
  String get visualRecord => '4. दृश्य रिकॉर्ड';

  @override
  String get uploadImageOfGoods => 'माल की छवि अपलोड करें';

  @override
  String get tapToCaptureOrUpload => 'कैप्चर या अपलोड करने के लिए टैप करें';

  @override
  String get takePhoto => 'फोटो लें';

  @override
  String get chooseFromGallery => 'गैलरी से चुनें';

  @override
  String get errorPickingImage => 'छवि चुनने में त्रुटि';

  @override
  String get storageDetails => '5. स्टोरेज विवरण';

  @override
  String get storageFacility => 'स्टोरेज सुविधा';

  @override
  String get storageRoom => 'स्टोरेज कमरा';

  @override
  String get selectStorageRoom => 'स्टोरेज कमरा चुनें';

  @override
  String get noStorageRoomsAvailable =>
      'आपकी आवंटित सुविधा के लिए कोई स्टोरेज कमरा उपलब्ध नहीं है। कृपया प्रबंधक से संपर्क करें।';

  @override
  String get storageDuration => 'स्टोरेज अवधि';

  @override
  String get sixtyDays => '60 दिन';

  @override
  String get ninetyDays => '90 दिन';

  @override
  String get oneYear => '1 वर्ष';

  @override
  String get enterDays => 'दिन दर्ज करें';

  @override
  String get saveInwardEntry => 'आवक प्रविष्टि सहेजें';

  @override
  String get entrySaved => 'प्रविष्टि सहेजी गई';

  @override
  String get inwardEntrySuccess => 'आवक प्रविष्टि सफलतापूर्वक दर्ज की गई।';

  @override
  String get downloadReceipt => 'रसीद डाउनलोड करें';

  @override
  String get pleaseSelectParty => 'कृपया एक पार्टी/किसान चुनें';

  @override
  String get pleaseSelectStorageRoom => 'कृपया एक स्टोरेज कमरा चुनें';

  @override
  String get noStorageAssigned =>
      'त्रुटि: इस ऑपरेटर को कोई स्टोरेज आवंटित नहीं है।';

  @override
  String get selectBookingParty => '1. बुकिंग / पार्टी चुनें';

  @override
  String get searchStoredInventory => 'संग्रहित इन्वेंटरी खोजें';

  @override
  String get searchByPartyPhoneCrop => 'पार्टी, फ़ोन या फसल से खोजें';

  @override
  String get noInventoryFound => 'कोई इन्वेंटरी नहीं मिली';

  @override
  String get availableInventory => 'उपलब्ध इन्वेंटरी';

  @override
  String itemsCount(int count) {
    return '$count आइटम';
  }

  @override
  String get party => 'पार्टी';

  @override
  String get available => 'उपलब्ध';

  @override
  String get quantityToRemove => 'निकालने की मात्रा';

  @override
  String get enterQuantity => 'मात्रा दर्ज करें';

  @override
  String get confirmOutward => 'जावक की पुष्टि करें';

  @override
  String get outwardRecorded => 'जावक दर्ज';

  @override
  String outwardReceiptGenerated(String number) {
    return 'जावक रसीद #$number बनाई गई।';
  }

  @override
  String get pleaseEnterValidQuantity => 'कृपया एक वैध मात्रा दर्ज करें';

  @override
  String quantityExceedsStock(String available) {
    return 'मात्रा उपलब्ध स्टॉक ($available) से अधिक है';
  }

  @override
  String get processingOutwardEntry => 'जावक प्रविष्टि प्रोसेस हो रही है...';

  @override
  String get errorLoadingInventory => 'इन्वेंटरी लोड करने में त्रुटि';

  @override
  String get quickRegistration => 'त्वरित पंजीकरण - 30 सेकंड से कम समय लगता है';

  @override
  String get enterFullName => 'पूरा नाम दर्ज करें';

  @override
  String get partyType => 'पार्टी का प्रकार';

  @override
  String get farmer => 'किसान';

  @override
  String get traderCompany => 'व्यापारी / कंपनी';

  @override
  String get transporter => 'ट्रांसपोर्टर';

  @override
  String get coldStorage => 'कोल्ड स्टोरेज';

  @override
  String get pleaseSelectColdStorage => 'कृपया कोल्ड स्टोरेज चुनें';

  @override
  String get storage => 'स्टोरेज';

  @override
  String get villageCity => 'गांव / शहर';

  @override
  String get enterVillageOrCity => 'गांव या शहर का नाम दर्ज करें';

  @override
  String get gstNumberOptional => 'GST नंबर (वैकल्पिक)';

  @override
  String get notesOptional => 'नोट्स (वैकल्पिक)';

  @override
  String get addNotes => 'अतिरिक्त नोट्स जोड़ें...';

  @override
  String get saveParty => 'पार्टी सहेजें';

  @override
  String get ownerOverview => 'मालिक अवलोकन';

  @override
  String get highLevelMetrics => 'उच्च स्तरीय व्यापार मेट्रिक्स';

  @override
  String get overview => 'अवलोकन';

  @override
  String get storages => 'स्टोरेज';

  @override
  String get noStorages => 'कोई स्टोरेज नहीं';

  @override
  String get selectStorage => 'स्टोरेज चुनें';

  @override
  String get storageUtilization => 'स्टोरेज उपयोग';

  @override
  String get ofCapacity => 'क्षमता का';

  @override
  String mtOccupied(String value) {
    return '$value MT भरा हुआ';
  }

  @override
  String mtTotal(String value) {
    return '$value MT कुल';
  }

  @override
  String get thisMonth => 'इस महीने';

  @override
  String get inflow => 'आवक';

  @override
  String get mtReceived => 'MT प्राप्त';

  @override
  String get outflow => 'जावक';

  @override
  String get mtDispatched => 'MT भेजा गया';

  @override
  String get activeBookings => 'सक्रिय बुकिंग';

  @override
  String get confirmed => 'पुष्टि';

  @override
  String get pending => 'लंबित';

  @override
  String get alertSummary => 'अलर्ट सारांश';

  @override
  String roomsOutOfRange(int count) {
    return '$count कमरे सीमा से बाहर';
  }

  @override
  String get allRoomsNormal => 'सभी कमरे सामान्य';

  @override
  String get equipmentStatus => 'उपकरण स्थिति';

  @override
  String get allSystemsOperational => 'सभी सिस्टम चालू';

  @override
  String get revenueEst => 'राजस्व (अनुमानित)';

  @override
  String get avgDuration => 'औसत अवधि';

  @override
  String get manageManagersStaff => 'प्रबंधक और कर्मचारी प्रबंधित करें';

  @override
  String get addNewStaffMember => 'नया कर्मचारी जोड़ें';

  @override
  String get phoneNumberRequired => 'फ़ोन नंबर *';

  @override
  String get phoneHint => '+91 ';

  @override
  String get nameRequired => 'नाम *';

  @override
  String get enterName => 'नाम दर्ज करें';

  @override
  String get roleRequired => 'भूमिका *';

  @override
  String get fullAccessDescription =>
      'स्टोरेज, कर्मचारी और इन्वेंटरी प्रबंधित करने की पूर्ण पहुंच';

  @override
  String get inwardOutwardOnly => 'केवल आवक/जावक संचालन';

  @override
  String get tempMonitoringAlerts => 'तापमान निगरानी और अलर्ट';

  @override
  String get phoneNameRequired => 'फ़ोन नंबर और नाम आवश्यक हैं';

  @override
  String get staffAddedSuccess => 'कर्मचारी सफलतापूर्वक जोड़ा गया';

  @override
  String get addStaff => 'कर्मचारी जोड़ें';

  @override
  String get editStaffMember => 'कर्मचारी संपादित करें';

  @override
  String phoneLabel(String phone) {
    return 'फ़ोन: $phone';
  }

  @override
  String get fullAccess => 'पूर्ण पहुंच';

  @override
  String get inwardOutward => 'आवक/जावक';

  @override
  String get saveChanges => 'बदलाव सहेजें';

  @override
  String get staffUpdatedSuccess => 'कर्मचारी सफलतापूर्वक अपडेट किया गया';

  @override
  String get managers => 'प्रबंधक';

  @override
  String get canManageOperations => 'स्टोरेज संचालन प्रबंधित कर सकते हैं';

  @override
  String get operators => 'ऑपरेटर';

  @override
  String get inwardOutwardOps => 'आवक/जावक संचालन';

  @override
  String get technicians => 'तकनीशियन';

  @override
  String get tempMonitoring => 'तापमान निगरानी';

  @override
  String noRoleAddedYet(String role) {
    return 'अभी तक कोई $role नहीं जोड़ा';
  }

  @override
  String get disabled => 'अक्षम';

  @override
  String get enable => 'सक्षम करें';

  @override
  String get disable => 'अक्षम करें';

  @override
  String get deleteStaff => 'कर्मचारी हटाएं?';

  @override
  String deleteStaffConfirm(String name) {
    return 'क्या आप वाकई $name को हटाना चाहते हैं? यह कार्रवाई पूर्ववत नहीं की जा सकती।';
  }

  @override
  String get staffDeletedSuccess => 'कर्मचारी सफलतापूर्वक हटाया गया';

  @override
  String get errorLoadingStaff => 'कर्मचारी लोड करने में त्रुटि';

  @override
  String get errorLoadingStorages => 'स्टोरेज लोड करने में त्रुटि';

  @override
  String get manageYourFacilities => 'अपनी सुविधाएं प्रबंधित करें';

  @override
  String get addNewStorage => 'नया स्टोरेज जोड़ें';

  @override
  String get addStorage => 'स्टोरेज जोड़ें';

  @override
  String get editStorage => 'स्टोरेज संपादित करें';

  @override
  String get storageType => 'स्टोरेज प्रकार';

  @override
  String get silos => 'साइलो';

  @override
  String get warehouses => 'गोदाम';

  @override
  String get frozenStorages => 'फ्रोजन स्टोरेज';

  @override
  String get ripeningChambers => 'पकाने के कमरे';

  @override
  String get controlledAtmosphere => 'नियंत्रित वातावरण स्टोरेज';

  @override
  String get storageNameHint => 'जैसे स्टोरेज मुख्य';

  @override
  String get codeRequired => 'कोड *';

  @override
  String get codeHint => 'जैसे STR1';

  @override
  String get city => 'शहर';

  @override
  String get cityHint => 'जैसे नासिक';

  @override
  String get totalCapacityMT => 'कुल क्षमता (MT)';

  @override
  String get roomsRequired => 'कमरे *';

  @override
  String get addAtLeastOneRoom => 'इस स्टोरेज के लिए कम से कम एक कमरा जोड़ें';

  @override
  String get roomsHint => 'जैसे कमरा A, कमरा B, कमरा C (कॉमा से अलग)';

  @override
  String get separateWithCommas => 'कई कमरों को कॉमा से अलग करें';

  @override
  String get nameCodeRequired => 'नाम और कोड आवश्यक हैं';

  @override
  String get storageDeleted => 'स्टोरेज हटाया गया';

  @override
  String get atLeastOneRoomRequired => 'कम से कम एक कमरा आवश्यक है';

  @override
  String get storageCreatedSuccess => 'स्टोरेज सफलतापूर्वक बनाया गया';

  @override
  String get storageUpdatedSuccess => 'स्टोरेज सफलतापूर्वक अपडेट किया गया';

  @override
  String get create => 'बनाएं';

  @override
  String yourStoragesCount(int count) {
    return 'आपके स्टोरेज ($count)';
  }

  @override
  String get noStoragesYet => 'अभी कोई स्टोरेज नहीं';

  @override
  String get addFirstStorage => 'अपनी पहली स्टोरेज सुविधा जोड़ें';

  @override
  String get capacityUsage => 'क्षमता उपयोग';

  @override
  String mtUsed(String value) {
    return '$value MT उपयोग';
  }

  @override
  String get managerLabel => 'प्रबंधक:';

  @override
  String get change => 'बदलें';

  @override
  String get assign => 'आवंटित करें';

  @override
  String get view => 'देखें';

  @override
  String get assignManager => 'प्रबंधक आवंटित करें';

  @override
  String coldStorageLabel(String name) {
    return 'कोल्ड स्टोरेज: $name';
  }

  @override
  String get selectManager => 'प्रबंधक चुनें:';

  @override
  String get noManager => 'कोई प्रबंधक नहीं';

  @override
  String get managerAssignedSuccess => 'प्रबंधक सफलतापूर्वक आवंटित किया गया';

  @override
  String get code => 'कोड';

  @override
  String get occupied => 'भरा हुआ';

  @override
  String get errorLoadingColdStorages => 'कोल्ड स्टोरेज लोड करने में त्रुटि';

  @override
  String get temperatureAlertsSummary => 'तापमान अलर्ट';

  @override
  String get allRoomsOperational => 'सभी कमरे चालू';

  @override
  String get roomsNeedAttention => 'कमरों को ध्यान देने की जरूरत है';

  @override
  String get managerDashboard => 'प्रबंधक डैशबोर्ड';

  @override
  String welcome(String name) {
    return 'स्वागत है, $name';
  }

  @override
  String storageLabel(String names) {
    return 'स्टोरेज: $names';
  }

  @override
  String get noStorageAssignedTitle => 'कोई स्टोरेज आवंटित नहीं';

  @override
  String get contactOwnerMessage =>
      'कृपया स्टोरेज आवंटित करने के लिए मालिक से संपर्क करें।';

  @override
  String get mt => 'MT';

  @override
  String activeEntriesCount(int count) {
    return '$count सक्रिय प्रविष्टियाँ';
  }

  @override
  String get inventorySummary => 'इन्वेंटरी सारांश';

  @override
  String get viewStoredCrops => 'संग्रहीत फसलें देखें';

  @override
  String alertsActiveCount(int count) {
    return '$count अलर्ट सक्रिय';
  }

  @override
  String teamMembersCount(int count) {
    return '$count टीम सदस्य';
  }

  @override
  String get pendingRequests => 'लंबित अनुरोध';

  @override
  String get awaitingApproval => 'अनुमोदन की प्रतीक्षा में';

  @override
  String get totalStock => 'कुल स्टॉक';

  @override
  String acrossCropTypes(int count) {
    return '$count फसल प्रकारों में';
  }

  @override
  String get addInward => 'इनवर्ड जोड़ें';

  @override
  String get markOutward => 'आउटवर्ड मार्क करें';

  @override
  String get unknown => 'अज्ञात';

  @override
  String get inStorage => 'स्टोरेज में';

  @override
  String get inwardDate => 'इनवर्ड तिथि';

  @override
  String get expectedOut => 'अपेक्षित आउट';

  @override
  String get addAndManageStaff => 'स्टोरेज स्टाफ जोड़ें और प्रबंधित करें';

  @override
  String get deleteStaffMember => 'स्टाफ सदस्य हटाएं';

  @override
  String get deleteStaffMemberConfirm =>
      'क्या आप वाकई इस स्टाफ सदस्य को हटाना चाहते हैं?';

  @override
  String errorMessage(String error) {
    return 'त्रुटि: $error';
  }

  @override
  String get staffMemberAddedSuccess => 'स्टाफ सदस्य सफलतापूर्वक जोड़ा गया';

  @override
  String get editStaff => 'स्टाफ सदस्य संपादित करें';

  @override
  String get staffMemberUpdatedSuccess =>
      'स्टाफ सदस्य सफलतापूर्वक अपडेट किया गया';

  @override
  String staffMembersCount(int count) {
    return 'स्टाफ सदस्य ($count)';
  }

  @override
  String get noRole => 'कोई भूमिका नहीं';

  @override
  String activeAlertsCount(int count) {
    return '$count सक्रिय अलर्ट';
  }

  @override
  String get activeAlerts => 'सक्रिय अलर्ट';

  @override
  String get allClear => 'सब ठीक है!';

  @override
  String get noActiveAlerts => 'कोई सक्रिय तापमान अलर्ट नहीं';

  @override
  String get normalStatus => 'सामान्य स्थिति';

  @override
  String get unknownRoom => 'अज्ञात कमरा';

  @override
  String get currentTemp => 'वर्तमान तापमान';

  @override
  String get allowedRange => 'अनुमत रेंज';

  @override
  String tempRange(String min, String max) {
    return '$min°C से $max°C';
  }

  @override
  String get takeAction => 'कार्रवाई करें';

  @override
  String actionTaken(String roomName) {
    return 'कार्रवाई - $roomName';
  }

  @override
  String get acknowledge => 'स्वीकार करें';

  @override
  String get markAsSeen => 'देखा गया मार्क करें';

  @override
  String get resolve => 'समाधान करें';

  @override
  String get issueFixed => 'समस्या ठीक हो गई है';

  @override
  String alertActionSuccess(String action) {
    return 'अलर्ट $action सफलतापूर्वक';
  }

  @override
  String get withinRange => 'रेंज के भीतर';

  @override
  String errorLoadingAlerts(String error) {
    return 'अलर्ट लोड करने में त्रुटि: $error';
  }

  @override
  String get roomTemperatureSettings => 'कमरे की तापमान सेटिंग्स';

  @override
  String roomsCount(int count) {
    return '$count कमरे';
  }

  @override
  String get noRoomsFound => 'कोई कमरा नहीं मिला';

  @override
  String get addNewRoom => 'नया कमरा जोड़ें';

  @override
  String get coldStorageRequired => 'कोल्ड स्टोरेज *';

  @override
  String get roomNameRequired => 'कमरे का नाम *';

  @override
  String get roomNameHint => 'जैसे कमरा A';

  @override
  String get capacityMT => 'क्षमता (MT)';

  @override
  String get capacityPlaceholder => '100';

  @override
  String get minTemperature => 'न्यूनतम तापमान (°C)';

  @override
  String get minTempPlaceholder => '-5';

  @override
  String get maxTemperature => 'अधिकतम तापमान (°C)';

  @override
  String get maxTempPlaceholder => '0';

  @override
  String get roomNameStorageRequired => 'कमरे का नाम और स्टोरेज आवश्यक है';

  @override
  String get roomAddedSuccess => 'कमरा सफलतापूर्वक जोड़ा गया';

  @override
  String get setTemperatureRange => 'तापमान रेंज सेट करें';

  @override
  String get minimumTemperature => 'न्यूनतम तापमान (°C)';

  @override
  String get minTempExample => 'जैसे, -5';

  @override
  String get maximumTemperature => 'अधिकतम तापमान (°C)';

  @override
  String get maxTempExample => 'जैसे, 0';

  @override
  String get temperatureAlertInfo =>
      'जब तापमान इस रेंज से बाहर जाता है तो अलर्ट बनाया जाएगा';

  @override
  String get minLessThanMax => 'न्यूनतम अधिकतम से कम होना चाहिए';

  @override
  String get temperatureRangeUpdated => 'तापमान रेंज सफलतापूर्वक अपडेट की गई';

  @override
  String get editTemperatureRange => 'तापमान रेंज संपादित करें';

  @override
  String get noStoragesAssigned => 'आपको कोई स्टोरेज आवंटित नहीं किया गया';

  @override
  String get bookingRequests => 'बुकिंग अनुरोध';

  @override
  String get manageStorageRequests => 'स्टोरेज अनुरोध प्रबंधित करें';

  @override
  String get underDevelopment => 'विकास में';

  @override
  String get featureComingSoon =>
      'यह सुविधा जल्द ही आ रही है!\\nबुकिंग अनुरोध और अनुमोदन यहां उपलब्ध होंगे।';

  @override
  String get versionFeature => 'संस्करण 2.0 सुविधा';

  @override
  String errorLoadingRooms(String error) {
    return 'कमरे लोड करने में त्रुटि: $error';
  }

  @override
  String get pleaseSelectRoom => 'कृपया एक कमरा चुनें';

  @override
  String get pleaseEnterTemperature => 'कृपया तापमान दर्ज करें';

  @override
  String get tempLoggedSuccess =>
      '✓ तापमान सफलतापूर्वक लॉग किया गया - रेंज के भीतर';

  @override
  String get tempLoggedWarning =>
      '⚠ तापमान लॉग किया गया - चेतावनी: रेंज से बाहर';

  @override
  String get tempLoggedCritical =>
      '⚠ तापमान लॉग किया गया - गंभीर: अलर्ट बनाया गया';

  @override
  String errorLoggingTemp(String error) {
    return 'तापमान लॉग करने में त्रुटि: $error';
  }

  @override
  String get noStorageRoomsAssigned => 'कोई स्टोरेज कमरा आवंटित नहीं';

  @override
  String get contactManager => 'कृपया अपने प्रबंधक से संपर्क करें';

  @override
  String get selectRoomInstruction =>
      'एक कमरा चुनें और वर्तमान तापमान रीडिंग दर्ज करें';

  @override
  String get selectStorageRoomRequired => 'स्टोरेज कमरा चुनें *';

  @override
  String get chooseRoom => 'एक कमरा चुनें';

  @override
  String get temperatureCelsius => 'तापमान (°C) *';

  @override
  String get enterTempHint => 'तापमान दर्ज करें (जैसे, -2.5)';

  @override
  String get celsiusUnit => '°C';

  @override
  String get logTemperature => 'तापमान लॉग करें';

  @override
  String get assignedRooms => 'आवंटित कमरे';
}
