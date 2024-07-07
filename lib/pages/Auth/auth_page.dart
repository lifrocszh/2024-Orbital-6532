import 'package:flutter/material.dart';
import 'package:orbital/pages/login_page.dart';
import 'package:orbital/pages/register_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  // initially it will show login page
  bool showLoginpage = true;

  @override
  Widget build(BuildContext context) {
    if (showLoginpage) {
      return const LoginPage();
    } else {
      return const RegisterPage();
    }
  }
}
