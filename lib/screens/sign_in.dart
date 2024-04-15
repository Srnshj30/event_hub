import 'package:auth_buttons/auth_buttons.dart';
import 'package:event_hub/screens/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firebase1 = FirebaseAuth.instance;

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _form1 = GlobalKey<FormState>();

  var _enteredEmail = '';
  var _enteredPassword = '';
  var _isAuthenticating = false;

  void _submit() async {
    final isValid = _form1.currentState!.validate();

    if (!isValid) {
      return;
    }

    _form1.currentState!.save();

    try {
      setState(() {
        _isAuthenticating = true;
      });

      // ignore: unused_local_variable
      final userCredentials = await _firebase1.signInWithEmailAndPassword(
          email: _enteredEmail, password: _enteredPassword);
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
          key: _form1,
          child: Column(
            children: [
              const SizedBox(
                height: 45,
              ),
              Container(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/images/eh-logo.png',
                  scale: 2.2,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
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
              SizedBox(
                width: 300,
                height: 40,
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
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
                height: 30,
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
                height: 30,
              ),
              if (!_isAuthenticating)
                OutlinedButton(
                  onPressed: _submit,
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Sign In',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              if (_isAuthenticating) const CircularProgressIndicator(),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GoogleAuthButton(
                    onPressed: () {},
                    style: const AuthButtonStyle(
                      buttonType: AuthButtonType.icon,
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  AppleAuthButton(
                    onPressed: () {},
                    style: const AuthButtonStyle(
                      buttonType: AuthButtonType.icon,
                    ),
                  ),
                ],
              ),
              const Padding(
                padding:
                    EdgeInsets.only(top: 25, left: 25, right: 25, bottom: 10),
                child: Divider(
                  color: Colors.black,
                  thickness: 0.7,
                ),
              ),
              const SizedBox(
                height: 1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Do you have an Account?'),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SignUp(),
                        ),
                      );
                    },
                    child: const Text('Sign Up'),
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
