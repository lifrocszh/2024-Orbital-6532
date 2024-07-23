import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:orbital/pages/login_page.dart';
import 'package:mockito/mockito.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {
  @override
  Stream<User> authStateChanges() {
    return Stream.fromIterable([
      _mockUser,
    ]);
  }
}

class MockUser extends Mock implements User {}

final MockUser _mockUser = MockUser();

class MockUserCredential extends Mock implements Future<UserCredential> {}

void main() {
  testWidgets('Login Page displays correctly', (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(
      MaterialApp(
        home: LoginPage(
          showRegisterPage: () {},
        ),
      ),
    );

    // Act & Assert
    expect(find.byIcon(Icons.lock), findsOneWidget);
    expect(find.text('WELCOME BACK'), findsOneWidget);
    expect(find.text('You\'ve been missed'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.byType(TextButton), findsOneWidget);
  });

  testWidgets('Text fields accept input', (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(
      MaterialApp(
        home: LoginPage(
          showRegisterPage: () {},
        ),
      ),
    );

    // Act
    await tester.enterText(find.byType(TextField).at(0), 'test@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'password123');

    // Assert
    expect(
        find.byType(TextField).at(0).evaluate().single.widget,
        isA<TextField>().having(
            (p) => p.controller?.text, 'email field', 'test@example.com'));
    expect(
        find.byType(TextField).at(1).evaluate().single.widget,
        isA<TextField>().having(
            (p) => p.controller?.text, 'password field', 'password123'));
  });
}
