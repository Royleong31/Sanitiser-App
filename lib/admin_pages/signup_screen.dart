import 'package:flutter/material.dart';
import 'package:sanitiser_app/widgets/ColoredWelcomeButton.dart';
import 'package:sanitiser_app/widgets/CustomInputField.dart';

class SignupScreen extends StatefulWidget {
  static const routeName = 'sign-up';

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  String _name, _email, _password;
  final _passwordController = TextEditingController();
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
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: 80),
                    CustomInputField(
                      label: 'NAME',
                      saveHandler: (val) => _name = val,
                    ),
                    CustomInputField(
                      label: 'EMAIL',
                      saveHandler: (val) => _email = val,
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
                      saveHandler: (val) => _password = val,
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
                      _onSaved();
                    }, 'CREATE ACCOUNT')
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
