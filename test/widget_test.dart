// This is a basic Flutter widget test.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:cold_storage_erp/main.dart';
import 'package:cold_storage_erp/state/app_state.dart';

void main() {
  testWidgets('App initializes correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AppState()..init(),
        child: const ColdStorageApp(),
      ),
    );

    // Verify that app loads
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
