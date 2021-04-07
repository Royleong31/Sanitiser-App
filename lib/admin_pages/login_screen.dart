import 'package:flutter/material.dart';
import 'package:sanitiser_app/widgets/ColoredWelcomeButton.dart';
import 'package:sanitiser_app/widgets/CustomInputField.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = 'login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _emailVal, _passwordVal;
  final _formKey = GlobalKey<FormState>();

  bool _onSaved() {
    final isValid = _formKey.currentState.validate();
    if (!isValid) return false;
    _formKey.currentState.save();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Theme.of(context).accentColor])),
      child: Scaffold(
          appBar: AppBar(
            actions: [],
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
                        'LOG IN',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w400),
                      ),
                      SizedBox(height: 80),
                      CustomInputField(
                        label: 'EMAIL',
                        saveHandler: (val) => _emailVal = val,
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
                        saveHandler: (val) => _passwordVal,
                        validatorHandler: (val) {
                          if (val.length < 6)
                            return 'Password needs to be at least 6 characters long';
                          return null;
                        },
                      ),
                      SizedBox(height: 50),
                      ColoredWelcomeButton(() {
                        _onSaved();
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
          )),
    );
  }
}
