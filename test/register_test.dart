import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:orbital/pages/register_page.dart';
import 'package:orbital/auth.dart';

class MockAuth extends Mock implements Auth {}

class MockUser extends Mock implements User {}

void main() {
  late MockAuth mockAuth;
  late MockUser mockUser;

  setUp(() {
    mockAuth = MockAuth();
    mockUser = MockUser();

    // Set up the mock user to be returned when creating a user
    when(mockAuth.currentUser).thenReturn(mockUser);
  });

  Future<void> pumpRegisterPage(WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: RegisterPage(showLoginPage: () {}),
    ));
  }

  testWidgets('RegisterPage displays correctly', (WidgetTester tester) async {
    // Arrange
    final registerPage = RegisterPage(
      showLoginPage: () {},
    );

    await tester.pumpWidget(
      MaterialApp(
        home: registerPage,
      ),
    );

    // Check for presence of key widgets and texts
    expect(find.text('HELLO THERE!'), findsOneWidget);
    expect(find.text('Register below with your details'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(4)); // 4 text fields
    expect(find.byType(DropdownButton<String>), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.byType(TextButton), findsOneWidget);
  });
  testWidgets('Show error when passwords do not match',
      (WidgetTester tester) async {
    await pumpRegisterPage(tester);

    await tester.enterText(find.byType(TextField).at(0), 'Test User');
    await tester.enterText(find.byType(TextField).at(1), 'test@example.com');
    await tester.enterText(find.byType(TextField).at(2), 'password');
    await tester.enterText(find.byType(TextField).at(3), 'differentpassword');
    await tester.tap(find.byType(DropdownButton<String>));
    await tester.pump();
    await tester.tap(find.text('2').last);
    await tester.pump();
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(find.text('Passwords do not match'), findsOneWidget);
  });

  testWidgets('Show error when name field is blank',
      (WidgetTester tester) async {
    await pumpRegisterPage(tester);

    await tester.enterText(find.byType(TextField).at(1), 'test@example.com');
    await tester.enterText(find.byType(TextField).at(2), 'password');
    await tester.enterText(find.byType(TextField).at(3), 'password');
    await tester.tap(find.byType(DropdownButton<String>));
    await tester.pump();
    await tester.tap(find.text('2').last);
    await tester.pump();
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(find.text('Please enter your name'), findsOneWidget);
  });

  testWidgets('Show error when block number is blank',
      (WidgetTester tester) async {
    await pumpRegisterPage(tester);

    await tester.enterText(find.byType(TextField).at(0), 'Test User');
    await tester.enterText(find.byType(TextField).at(1), 'test@example.com');
    await tester.enterText(find.byType(TextField).at(2), 'password');
    await tester.enterText(find.byType(TextField).at(3), 'password');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(find.text('Please enter your block number'), findsOneWidget);
  });

  testWidgets('Show error when email is empty', (WidgetTester tester) async {
    await pumpRegisterPage(tester);

    await tester.enterText(find.byType(TextField).at(0), 'Test User');
    await tester.enterText(find.byType(TextField).at(1), ''); // Empty email
    await tester.enterText(find.byType(TextField).at(2), 'password');
    await tester.enterText(find.byType(TextField).at(3), 'password');
    await tester.tap(find.byType(DropdownButton<String>));
    await tester.pump();
    await tester.tap(find.text('2').last);
    await tester.pump();
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(find.text('Please enter your email'), findsOneWidget);
  });
}
