import 'dart:async';

import 'package:clean_flutter_app/ui/pages/pages.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class LoginPreseterSpy extends Mock implements LoginPresenter {}

void main() {
  late LoginPresenter presenter;
  late StreamController<String> emailErrorController;
  late StreamController<String> passwordErrorController;
  late StreamController<bool> isFormValidController;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = LoginPreseterSpy();
    emailErrorController = StreamController<String>();
    passwordErrorController = StreamController<String>();
    isFormValidController = StreamController<bool>();

    when(() => presenter.emailErrorStream)
        .thenAnswer((_) => emailErrorController.stream);
    when(() => presenter.passwordErrorStream)
        .thenAnswer((_) => passwordErrorController.stream);
    when(() => presenter.isFormValidStream)
        .thenAnswer((_) => isFormValidController.stream);

    final loginPage = MaterialApp(home: LoginPage(presenter: presenter));
    await tester.pumpWidget(loginPage);
  }

  tearDown(() {
    emailErrorController.close();
    passwordErrorController.close();
    isFormValidController.close();
  });

  testWidgets(
    'Should load with correct initial state',
    (WidgetTester tester) async {
      await loadPage(tester);

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

  testWidgets(
    'Should call validate with correct values',
    (WidgetTester tester) async {
      await loadPage(tester);

      final email = faker.internet.email();
      await tester.enterText(find.bySemanticsLabel('Email'), email);
      verify(() => presenter.validateEmail(email));

      final password = faker.internet.password();
      await tester.enterText(find.bySemanticsLabel('Senha'), password);
      verify(() => presenter.validatePassword(password));
    },
  );

  testWidgets(
    'Should present error message if email is invalid',
    (WidgetTester tester) async {
      await loadPage(tester);

      emailErrorController.add('any error');
      await tester.pump();

      expect(find.text('any error'), findsOneWidget);
    },
  );

  testWidgets(
    'Should present no error message if email error message is empty',
    (WidgetTester tester) async {
      await loadPage(tester);

      emailErrorController.add('');
      await tester.pump();

      final emailTextChildren = find.descendant(
        of: find.bySemanticsLabel('Email'),
        matching: find.byType(Text),
      );

      expect(emailTextChildren, findsOneWidget);
    },
  );

  testWidgets(
    'Should present no error message if email is valid',
    (WidgetTester tester) async {
      await loadPage(tester);
      await tester.pump();

      final emailTextChildren = find.descendant(
        of: find.bySemanticsLabel('Email'),
        matching: find.byType(Text),
      );

      expect(emailTextChildren, findsOneWidget);
    },
  );

  testWidgets(
    'Should present error message if password is invalid',
    (WidgetTester tester) async {
      await loadPage(tester);

      passwordErrorController.add('any error');
      await tester.pump();

      expect(find.text('any error'), findsOneWidget);
    },
  );

  testWidgets(
    'Should present no error message if password error message is empty',
    (WidgetTester tester) async {
      await loadPage(tester);

      passwordErrorController.add('');
      await tester.pump();

      final passwordTextChildren = find.descendant(
        of: find.bySemanticsLabel('Senha'),
        matching: find.byType(Text),
      );

      expect(passwordTextChildren, findsOneWidget);
    },
  );

  testWidgets(
    'Should present no error message if password is valid',
    (WidgetTester tester) async {
      await loadPage(tester);
      await tester.pump();

      final passwordTextChildren = find.descendant(
        of: find.bySemanticsLabel('Senha'),
        matching: find.byType(Text),
      );

      expect(passwordTextChildren, findsOneWidget);
    },
  );

  testWidgets(
    'Should enable button if form is valid',
    (WidgetTester tester) async {
      await loadPage(tester);

      isFormValidController.add(true);
      await tester.pump();

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));

      expect(button.onPressed, isNotNull);
    },
  );

  testWidgets(
    'Should disable button if form is invalid',
    (WidgetTester tester) async {
      await loadPage(tester);

      isFormValidController.add(false);
      await tester.pump();

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));

      expect(button.onPressed, null);
    },
  );
}
