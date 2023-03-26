import 'package:clean_flutter_app/ui/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'Should load with correct initial state',
    (WidgetTester tester) async {
      final loginPage = MaterialApp(home: LoginPage());
      await tester.pumpWidget(loginPage);

      final emailTextChildren = find.descendant(
        of: find.bySemanticsLabel('Email'),
        matching: find.byType(Text),
      );

      final passwordTextChildren = find.descendant(
        of: find.bySemanticsLabel('Senha'),
        matching: find.byType(Text),
      );

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));

      expect(emailTextChildren, findsOneWidget);
      expect(passwordTextChildren, findsOneWidget);
      expect(button.onPressed, null);
    },
  );
}
