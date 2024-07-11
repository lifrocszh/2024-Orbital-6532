import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../auth.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const RegisterPage({super.key, required this.showLoginPage});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? errorMessage = '';
  bool isLogin = true;

  // final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  static List<String> list = ['2', '3', '4', '5', '6', '7', '8'];
  String? _blockNumber;

  Future addUserDetails() async {
    await FirebaseFirestore.instance
        .collection('Users')
        // .add({
        //   'Name': _nameController.text,
        //   'Block': _blockNumber,
        //   'Email': _emailController.text,
        .doc(_emailController.text)
        .set({
      'Name': _nameController.text,
      'Block': _blockNumber,
      'Bio': '',
    });
  }

  Future<void> createUserWithEmailAndPassword() async {
    // print('submit button clicked');
    if (!passwordsMatch()) {
      setState(() {
        errorMessage = 'Passwords do not match';
      });
    } else if (_nameController.text.isEmpty) {
      setState(() {
        errorMessage = 'Please enter your name';
      });
    } else if (_blockNumber == null) {
      setState(() {
        errorMessage = 'Please enter your block number';
      });
    } else {
      try {
        await Auth().createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        addUserDetails();
      } on FirebaseAuthException catch (e) {
        setState(() {
          errorMessage = e.message;
        });
      }
    }
  }

  bool passwordsMatch() {
    return _passwordController.text == _confirmPasswordController.text;
  }

  Widget _errorMessage() {
    return Text(
      errorMessage == '' ? '' : '$errorMessage',
      style: const TextStyle(color: Colors.red),
    );
  }

  Widget _submitButton() {
    return ElevatedButton(
      onPressed: createUserWithEmailAndPassword,
      child: const Text('Register'),
    );
  }

  Widget _registerButton() {
    return TextButton(
        onPressed: widget.showLoginPage, child: const Text('Login instead'));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Register',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
          backgroundColor: Colors.greenAccent,
        ),
        backgroundColor: Colors.grey[300],
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 20),

                      // Logo text
                      Text(
                        'HELLO THERE!',
                        style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 40,
                            fontWeight: FontWeight.w900),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        'Register below with your details',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 17,
                        ),
                      ),

                      const SizedBox(height: 15),

                      // textfields
                      Container(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            hintText: 'Name',
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

                      DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey[100],
                        ),
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 10, left: 10, right: 10),
                          child: DropdownButton<String>(
                            value:
                                _blockNumber, // Initially set to null for empty selection
                            isExpanded: true,
                            hint: const Text('Block Number'),

                            icon: const Icon(Icons.arrow_downward),
                            elevation: 10,
                            dropdownColor: Colors.grey[100],
                            onChanged: (String? value) {
                              setState(() {
                                _blockNumber = value!;
                              });
                            },
                            items: list
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),

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

                      Container(
                        padding: const EdgeInsets.only(top: 10),
                        child: TextField(
                          controller: _confirmPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Confirm Password',
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
                        padding: const EdgeInsetsDirectional.only(
                            top: 10, bottom: 10),
                        child: _errorMessage(),
                      ),

                      _submitButton(),
                      _registerButton(),
                    ],
                  )),
            ),
          ),
        ));
  }
}
