import 'package:orbital/auth.dart';
import 'package:orbital/pages/Auth/auth_page.dart';
import 'package:orbital/pages/home_page.dart';
// import 'package:orbital/pages/login_page.dart';
import 'package:flutter/material.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print('going homepage');
          return HomePage();
        } else {
          print('gg login page'); // remember change back to LoginPage()

          return AuthPage();
        }
      },
    );
  }
}
