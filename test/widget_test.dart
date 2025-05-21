import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:can_i_ride_today/pages/home.dart';
import 'package:country_state_city/country_state_city.dart' as csc;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  testWidgets('HomePage displays UI', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: HomePage()));

    expect(find.text('Can I Ride Today?'), findsOneWidget);

    expect(find.byType(FutureBuilder<List<csc.City>>), findsOneWidget);

    expect(find.byType(ListView), findsOneWidget);

    expect(find.text('Temperatur'), findsOneWidget);
    expect(find.text('Regen'), findsOneWidget);
    expect(find.text('Windgeschwindigkeit'), findsOneWidget);
  });
}
