// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokemon/main.dart';

void main() {
  testWidgets('Carga la pantalla principal', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    expect(find.text('Buscar Pokémon...'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('Realiza una búsqueda de Pokémon', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    await tester.enterText(find.byType(TextField), 'Pikachu');
    await tester.pump();

    expect(find.text('Resultados para: "Pikachu"'), findsOneWidget);
  });
}
