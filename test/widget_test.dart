import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:smart_bidonville/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // On construit l'app et on déclenche un frame.
    await tester.pumpWidget(const MyApp());

    // On vérifie que le compteur démarre à 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // On tape sur l'icône '+' puis on déclenche un frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // On vérifie que le compteur s'incrémente.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  }, skip: true, reason: 'Test par défaut du template Flutter, non pertinent pour cette app.');
}
