import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:repair_app/main.dart';

void main() {
  testWidgets('Repair app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const RepairApp());

    // Verify that our app starts up correctly.
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}