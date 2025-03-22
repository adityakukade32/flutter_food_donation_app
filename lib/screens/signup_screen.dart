import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterapk/reusable_widget/reusable_widget.dart';
import 'package:flutterapk/screens/signin_screen.dart'; // Import SignInScreen
import 'package:flutterapk/screens/utils/color_utils.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _userNameTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              hexStringToColor("CB2B93"),
              hexStringToColor("9546C4"),
              hexStringToColor("5E61F4"),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      reusableTextField(
                        "Enter Username",
                        Icons.person_outline,
                        false,
                        _userNameTextController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter a username";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      reusableTextField(
                        "Enter Email Id",
                        Icons.email_outlined,
                        false,
                        _emailTextController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your email";
                          } else if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                              .hasMatch(value)) {
                            return "Enter a valid email address";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      reusableTextField(
                        "Enter Password",
                        Icons.lock_outline,
                        true,
                        _passwordTextController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter a password";
                          } else if (value.length < 6) {
                            return "Password must be at least 6 characters";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      firebaseButton(context, "Sign Up", _signUp),
                    ],
                  ),
                ),
              ),
            ),
            if (_isLoading)
              Center(
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(
                    strokeWidth: 4,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        await _auth.createUserWithEmailAndPassword(
          email: _emailTextController.text.trim(),
          password: _passwordTextController.text.trim(),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignInScreen()), // Redirect to SignInScreen
        );
      } on FirebaseAuthException catch (e) {
        String errorMessage = "An error occurred. Please try again.";
        if (e.code == 'email-already-in-use') {
          errorMessage = "This email address is already in use.";
        } else if (e.code == 'weak-password') {
          errorMessage = "Please use a stronger password (at least 6 characters).";
        } else if (e.code == 'invalid-email'){
            errorMessage = "Please enter valid email address.";
        }
        else if(e.code == 'operation-not-allowed'){
            errorMessage = "Signup is currently disabled.";
        }
        _showMessage(errorMessage);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}