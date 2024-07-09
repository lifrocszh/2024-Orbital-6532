import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback showRegisterPage;
  const LoginPage({super.key, required this.showRegisterPage});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';
  bool isLogin = true;

  // final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _errorMessage() {
    return Text(errorMessage == '' ? '' : 'hmmm ? $errorMessage');
  }

  Widget _submitButton() {
    return ElevatedButton(
      onPressed: signInWithEmailAndPassword,
      child: const Text('Login'),
    );
  }

  Widget _loginButton() {
    return TextButton(
        onPressed: widget.showRegisterPage,
        child: const Text('Register instead'));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Sign in',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
          backgroundColor: Colors.greenAccent,
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Center(
              child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 50),

                      // logo
                      const Icon(
                        Icons.lock,
                        size: 100,
                      ),

                      const SizedBox(height: 50),

                      // welcome back, you've been missed!
                      Text(
                        'WELCOME BACK',
                        style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 40,
                            fontWeight: FontWeight.w900),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        'You\'ve been missed',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 17,
                        ),
                      ),

                      const SizedBox(height: 25),

                      Container(
                        padding: const EdgeInsets.only(top: 10),
                        child: TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            fillColor: Colors.grey[100],
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.deepPurple),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.only(top: 10),
                        child: TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            fillColor: Colors.grey[100],
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.deepPurple),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),

                      _errorMessage(),
                      _submitButton(),
                      _loginButton(),

                      const SizedBox(height: 50),
                    ],
                  )),
            ),
          ),
        ));
  }
}
