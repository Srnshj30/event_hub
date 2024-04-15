import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firebase = FirebaseAuth.instance;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _form = GlobalKey<FormState>();

  var _enteredEmail = '';
  var _enteredUsername = '';
  var _enteredPassword = '';
  var _isAuthenticating = false;
  var _isLogin = true;

  void _submit() async {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }

    _form.currentState!.save();

    try {
      setState(() {
        _isAuthenticating = true;
      });
      if (_isLogin) {
        // ignore: unused_local_variable
        final userCredentials = await _firebase.signInWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
      } else {
        // ignore: unused_local_variable
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);

        FirebaseFirestore.instance
            .collection('users')
            .doc(userCredentials.user!.uid)
            .set({
          'username': _enteredUsername,
          'Email': _enteredEmail,
        });
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {
        // .....
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Authentication Failed'),
        ),
      );
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: _form,
          child: Column(
            children: [
              const SizedBox(
                height: 45,
              ),
              Container(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/images/eh-logo.png',
                  scale: 2.4,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              if (!_isLogin)
                const Text(
                  'Creat an Account',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              if (_isLogin)
                const Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              const SizedBox(
                height: 30,
              ),
              if (!_isLogin)
                SizedBox(
                  width: 300,
                  height: 40,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    keyboardType: TextInputType.name,
                    autocorrect: false,
                    textCapitalization: TextCapitalization.words,
                    validator: (value) {
                      if (value == null || value.trim().length < 4) {
                        return 'Username must be atleast 4 characters';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _enteredUsername = newValue!;
                    },
                  ),
                ),
              const SizedBox(
                height: 25,
              ),
              SizedBox(
                width: 300,
                height: 40,
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty ||
                        !value.trim().contains('@')) {
                      return 'Please enter a valid Email Address';
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    _enteredEmail = newValue!;
                  },
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              SizedBox(
                width: 300,
                height: 40,
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.trim().length < 6) {
                      return 'Password must be atleast 6 character long';
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    _enteredPassword = newValue!;
                  },
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              if (!_isAuthenticating)
                OutlinedButton(
                  onPressed: _submit,
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    !_isLogin ? 'Sign Up' : 'Log In',
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              if (_isAuthenticating) const CircularProgressIndicator(),
              const SizedBox(
                height: 10,
              ),
              if (!_isAuthenticating)
                const Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.black,
                        thickness: 0.7,
                        indent: 15,
                        // endIndent: 205,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text('OR'),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.black,
                        thickness: 0.7,
                        // indent: 255,
                        endIndent: 15,
                      ),
                    ),
                  ],
                ),
              const SizedBox(
                height: 25,
              ),
              if (!_isAuthenticating)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 40,
                      width: 40,
                      child: GoogleAuthButton(
                        onPressed: () {},
                        style: const AuthButtonStyle(
                          buttonType: AuthButtonType.icon,
                          iconSize: 32,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 35,
                    ),
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: AppleAuthButton(
                        onPressed: () {},
                        style: const AuthButtonStyle(
                          buttonType: AuthButtonType.icon,
                          iconSize: 32,
                        ),
                      ),
                    ),
                  ],
                ),
              // const Padding(
              //   padding:
              //       EdgeInsets.only(top: 15, left: 25, right: 25, bottom: 10),
              //   child: Divider(
              //     color: Colors.black,
              //     thickness: 0.7,
              //   ),
              // ),
              const SizedBox(
                height: 30,
              ),
              if (!_isAuthenticating)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Do you have an Account?'),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(_isLogin ? 'Sign Up' : 'Log In'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
