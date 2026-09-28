import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:repair_app/core/widgets/pill_selector.dart';
import 'package:repair_app/data/static_data.dart';
import 'package:repair_app/features/manage/manage_screen.dart';
import 'package:repair_app/main.dart';

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  Future<void> pumpApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const RepairApp());
    await tester.pumpAndSettle();
  }

  testWidgets('opens on the map with the selected garage preview', (tester) async {
    await pumpApp(tester);

    expect(find.text('GPS MAP'), findsOneWidget);
    expect(find.text('ABC Motor Shop & Garage'), findsOneWidget);
  });

  testWidgets('every tab renders without layout errors', (tester) async {
    await pumpApp(tester);

    for (final (tab, subtitle) in [
      ('Services', 'SERVICE HUB'),
      ('Store', 'PARTS STORE'),
      ('Manage', 'VEHICLE MANAGEMENT'),
      ('Profile', 'TECHNICIAN PROFILE'),
    ]) {
      await tester.tap(find.text(tab).last);
      await tester.pumpAndSettle();
      expect(find.text(subtitle), findsOneWidget, reason: '$tab tab header');
    }
  });

  testWidgets('store filters parts by category', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.text('Store').last);
    await tester.pumpAndSettle();

    final tires = find.text('TIRES');
    await tester.scrollUntilVisible(
      tires,
      200,
      scrollable: find.descendant(of: find.byType(PillSelector<PartCategory?>), matching: find.byType(Scrollable)),
    );
    await tester.ensureVisible(tires);
    await tester.pumpAndSettle();
    await tester.tap(tires);
    await tester.pumpAndSettle();

    expect(find.text('Tubeless 90/90-14 Tire'), findsOneWidget);
    expect(find.text('Ceramic Brake Pad Set'), findsNothing);
  });

  testWidgets('manage restocks a low-stock item', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.text('Manage').last);
    await tester.pumpAndSettle();

    final restock = find.text('Restock +5');
    await tester.scrollUntilVisible(
      restock,
      300,
      scrollable: find.descendant(of: find.byType(ManageScreen), matching: find.byType(Scrollable)).first,
    );
    await tester.ensureVisible(restock);
    await tester.pumpAndSettle();
    await tester.tap(restock);
    await tester.pumpAndSettle();

    expect(find.textContaining('In Stock: 8 units'), findsOneWidget);
  });
}
