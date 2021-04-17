import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanitiser_app/provider/authProvider.dart';
import 'package:sanitiser_app/widgets/ColoredWelcomeButton.dart';
import 'package:sanitiser_app/widgets/CustomInputField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class SignupScreen extends StatefulWidget {
  static const routeName = 'sign-up';

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  String _name, _email, _password;
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  bool _onSaved() {
    final isValid = _formKey.currentState.validate();
    if (!isValid) return false;
    _formKey.currentState.save();
    print('Name: $_name, Email: $_email, Password: $_password');
    FocusScope.of(context).unfocus();
    return true;
  }

  void _registerUser() async {
    setState(() {
      showSpinner = true;
    });

    try {
      // final newUser = await _auth.createUserWithEmailAndPassword(
      //   email: _email,
      //   password: _password,
      // );

      // if (newUser != null) {
      //   Navigator.of(context).pushNamed(HomeScreen.routeName);
      //   print(newUser.user);
      //   print(newUser.additionalUserInfo);
      //   print(newUser.credential);
      // }

      // var userInfo = await firestore.collection('users').add({
      //   '_name': _name,
      //   'email': _email,
      // });

      // print('User Info: $userInfo');
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            err.toString().replaceRange(err.toString().indexOf('['),
                err.toString().indexOf(']') + 2, ''),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } finally {
      setState(() {
        showSpinner = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Theme.of(context).accentColor])),
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
                        'SIGN UP',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w400),
                      ),
                      SizedBox(height: 80),
                      CustomInputField(
                        label: 'NAME',
                        saveHandler: (val) => _name = val.trim(),
                      ),
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
                        controller: _passwordController,
                        validatorHandler: (val) {
                          if (val.length < 6)
                            return 'Password needs to be at least 6 characters long';
                          return null;
                        },
                      ),
                      CustomInputField(
                        label: 'VERIFY PASSWORD',
                        obscureText: true,
                        validatorHandler: (val) {
                          if (val.isEmpty || val != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 50),
                      ColoredWelcomeButton(() {
                        // if (_onSaved()) _registerUser();
                        if (_onSaved()) {
                          setState(() {
                            showSpinner = true;
                          });
                          Provider.of<AuthProvider>(context, listen: false)
                              .signUp(_email, _password, context);
                        }
                      }, 'CREATE ACCOUNT')
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
