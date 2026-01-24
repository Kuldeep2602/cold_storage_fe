import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'screens/access_pending_screen.dart';
import 'screens/home_screen.dart';
import 'screens/language_selection_screen.dart';
import 'screens/phone_entry_screen.dart';
import 'screens/role_selection_screen.dart';
import 'state/app_state.dart';
import 'widgets/app_loading.dart';
import 'l10n/app_localizations.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState()..init(),
      child: const ColdStorageApp(),
    ),
  );
}

class ColdStorageApp extends StatelessWidget {
  const ColdStorageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (_, app, __) {
        return MaterialApp(
          title: 'Cold Storage ERP',
          theme: ThemeData(useMaterial3: true),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English
            Locale('hi', ''), // Hindi
          ],
          locale: Locale(app.selectedLanguage ?? 'en'),
          home: _buildHome(app),
        );
      },
    );
  }

  Widget _buildHome(AppState app) {
    if (!app.initialized) return const Scaffold(body: AppLoadingView(label: 'Initializing...'));
    
    // First check if language has been selected
    if (!app.hasSelectedLanguage) return const LanguageSelectionScreen();
    
    // Second check if role has been selected
    if (!app.hasSelectedRole) return const RoleSelectionScreen();
    
    // Then check authentication
    if (!app.isAuthenticated) return const PhoneEntryScreen();
    
    // Check if user has a role assigned
    if (!app.hasRole) return const AccessPendingScreen();
    
    return const HomeScreen();
  }
}

