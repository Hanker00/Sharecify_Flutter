import 'package:flutter/material.dart';
import 'package:school_project/screens/authentication/login.dart';
import 'package:school_project/screens/home/signUpSelection.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool showSignUp = true;
  void toggleView() {
    setState(() => showSignUp = !showSignUp);
  }
  
  @override
  Widget build(BuildContext context) {
    if (showSignUp) {
      return Login(toggleView: toggleView);
    } else {
      return SignUpSelection(toggleView: toggleView);
    }
  }
}