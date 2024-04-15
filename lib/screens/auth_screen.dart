import 'package:auth_buttons/auth_buttons.dart';
import 'package:event_hub/services/auth_servies.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:google_fonts/google_fonts.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
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
                height: 25,
              ),
              if (!_isLogin)
                Container(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/images/eh-logo.png',
                    scale: 2.4,
                  ),
                ),
              if (_isLogin)
                Container(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/images/eh-logo.png',
                    scale: 2.1,
                  ),
                ),
              // const SizedBox(
              //   height: 10,
              // ),
              if (!_isLogin)
                const Text(
                  'Let\'s create an Account!',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              if (_isLogin)
                const Text(
                  'Welcome back!',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              if (!_isLogin)
                const SizedBox(
                  height: 10,
                ),
              const SizedBox(
                height: 10,
              ),
              if (!_isLogin)
                SizedBox(
                  width: 300,
                  height: 50,
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
                height: 15,
              ),
              SizedBox(
                width: 300,
                height: 50,
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
                height: 15,
              ),
              SizedBox(
                width: 300,
                height: 50,
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
              // const SizedBox(
              //   height: 3,
              // ),
              Container(
                padding: const EdgeInsets.only(right: 25),
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              if (_isLogin)
                const SizedBox(
                  height: 5,
                ),
              if (!_isAuthenticating)
                OutlinedButton.icon(
                  onPressed: _submit,
                  style: OutlinedButton.styleFrom(
                    fixedSize: const Size.fromWidth(200),
                    maximumSize: const Size.fromHeight(40),
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  label: Text(
                    !_isLogin ? 'Sign Up' : 'Log In',
                    style: const TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                  ),
                ),
              if (_isAuthenticating) const CircularProgressIndicator(),
              const SizedBox(
                height: 30,
              ),
              if (_isLogin)
                const SizedBox(
                  height: 5,
                ),
              if (!_isAuthenticating)
                const Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.grey,
                        thickness: 0.7,
                        indent: 20,
                        // endIndent: 205,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'Or continue with',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.grey,
                        thickness: 0.7,
                        // indent: 255,
                        endIndent: 20,
                      ),
                    ),
                  ],
                ),
              if (_isLogin)
                const SizedBox(
                  height: 10,
                ),
              const SizedBox(
                height: 20,
              ),
              if (!_isAuthenticating)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: GoogleAuthButton(
                        onPressed: () => AuthServies().signInWithGoogle(),
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
                      width: 50,
                      height: 50,
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
              const SizedBox(
                height: 22,
              ),
              if (_isLogin)
                const SizedBox(
                  height: 2,
                ),
              if (!_isAuthenticating)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(!_isLogin
                        ? 'Already have an Account?'
                        : 'Not a member?'),
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
