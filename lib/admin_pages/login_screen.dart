import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanitiser_app/admin_pages/welcome_screen.dart';
import 'package:sanitiser_app/logged_in_pages/homeScreen.dart';
import 'package:sanitiser_app/main.dart';
import 'package:sanitiser_app/provider/authProvider.dart';
import 'package:sanitiser_app/splash_screen.dart';
import 'package:sanitiser_app/widgets/ColoredWelcomeButton.dart';
import 'package:sanitiser_app/widgets/CustomInputField.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = 'login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email, _password;
  bool showSpinner = false;
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  bool _onSaved() {
    final isValid = _formKey.currentState.validate();
    if (!isValid) return false;
    _formKey.currentState.save();
    print('Email Value: $_email, Password Value: $_password');
    FocusScope.of(context).unfocus();
    return true;
  }

  void _loginUser() async {
    setState(() {
      showSpinner = true;
    });
    await Provider.of<AuthProvider>(context, listen: false)
        .signIn(_email, _password, context)
        .catchError((err) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(err),
        backgroundColor: Theme.of(context).errorColor,
      ));
    });

    setState(() {
      showSpinner = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Theme.of(context).accentColor],
        ),
      ),
      child: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Scaffold(
          appBar: AppBar(
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(Icons.arrow_back, size: 30),
                  color: Colors.black,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                );
              },
            ),
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
          ),
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Container(
              child: Center(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                          height: 143 -
                              AppBar().preferredSize.height -
                              MediaQuery.of(context).padding.top),
                      Text(
                        'LOGIN',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w400),
                      ),
                      SizedBox(height: 80),
                      CustomInputField(
                        label: 'EMAIL',
                        saveHandler: (val) => _email = val.trim(),
                        keyboardType: TextInputType.emailAddress,
                        validatorHandler: (val) {
                          if (!val.contains('@') || !val.contains('.com'))
                            return 'Please enter a valid email address';
                          return null;
                        },
                      ),
                      CustomInputField(
                        label: 'PASSWORD',
                        obscureText: true,
                        saveHandler: (val) => _password = val.trim(),
                        validatorHandler: (val) {
                          if (val.length < 6)
                            return 'Password needs to be at least 6 characters long';
                          return null;
                        },
                      ),
                      SizedBox(height: 50),
                      ColoredWelcomeButton(() {
                        if (_onSaved()) _loginUser();
                      }, 'LOG IN'),
                      SizedBox(height: 10),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'FORGOT PASSWORD?',
                          style: TextStyle(color: Colors.black, fontSize: 12),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
