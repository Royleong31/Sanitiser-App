import 'package:flutter/material.dart';
import 'package:sanitiser_app/widgets/ColoredWelcomeButton.dart';
import 'package:sanitiser_app/widgets/CustomInputField.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = 'login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                    'LOG IN',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: 80),
                  CustomInputField(label: 'EMAIL'),
                  SizedBox(height: 25),
                  CustomInputField(label: 'PASSWORD'),
                  SizedBox(height: 50),
                  ColoredWelcomeButton(() {}, 'LOG IN'),
                  SizedBox(height: 20),
                  TextButton(
                      onPressed: () {},
                      child: Text('FORGOT PASSWORD?',
                          style: TextStyle(color: Colors.black, fontSize: 10)))
                ],
              ),
            ),
          )),
    );
  }
}
