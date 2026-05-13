import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:calc_cientifica_cetis131/main.dart';

void main() {
  testWidgets('Pantalla calculadora muestra DEG y display', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: CalculatorScreen()),
    );
    expect(find.text('DEG'), findsOneWidget);
    expect(find.text('0'), findsWidgets);
  });
}
