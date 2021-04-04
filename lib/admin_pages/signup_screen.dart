import 'package:flutter/material.dart';
import 'package:sanitiser_app/widgets/ColoredWelcomeButton.dart';
import 'package:sanitiser_app/widgets/CustomInputField.dart';

class SignupScreen extends StatefulWidget {
  static const routeName = 'sign-up';

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
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
              child: Column(
                children: [
                  SizedBox(
                      height: 143 -
                          AppBar().preferredSize.height -
                          MediaQuery.of(context).padding.top),
                  Text(
                    'SIGN UP',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: 80),
                  CustomInputField(label: 'NAME'),
                  SizedBox(height: 25),
                  CustomInputField(label: 'EMAIL'),
                  SizedBox(height: 25),
                  CustomInputField(label: 'PASSWORD'),
                  SizedBox(height: 25),
                  CustomInputField(label: 'VERIFY PASSWORD'),
                  SizedBox(height: 50),
                  ColoredWelcomeButton(() {}, 'CREATE ACCOUNT')
                ],
              ),
            ),
          )),
    );
  }
}
