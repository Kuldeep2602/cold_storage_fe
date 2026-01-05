import 'package:flutter/foundation.dart';

/// Production backend URL (Render deployment)
const String kProductionBackendUrl = 'https://cold-storage-be-owdb.onrender.com';

/// Local development backend URL
const String kLocalBackendUrl = 'http://127.0.0.1:8000';

/// Android emulator localhost URL
const String kEmulatorBackendUrl = 'http://10.0.2.2:8000';

String defaultBaseUrl() {
  // Web development uses localhost
  if (kIsWeb) return kLocalBackendUrl;
  
  // Debug mode: Use emulator URL for Android, localhost for others
  if (kDebugMode) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      // For Android emulator - uncomment below and comment production
      // return kEmulatorBackendUrl;
      // For real Android device - use production URL
      return kProductionBackendUrl;
    }
    return kLocalBackendUrl;
  }
  
  // Release mode: Always use production URL
  return kProductionBackendUrl;
}

