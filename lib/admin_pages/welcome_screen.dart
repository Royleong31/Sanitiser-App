import 'package:flutter/material.dart';
import 'package:sanitiser_app/widgets/ColoredWelcomeButton.dart';

import 'login_screen.dart';
import 'signup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  static const routeName = 'welcome';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Theme.of(context).accentColor])),
      child: Scaffold(
        // By defaut, Scaffold background is white
        // Set its value to transparent
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 130),
                Text(
                  'WELCOME',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 360),
                ColoredWelcomeButton(() {
                  Navigator.pushNamed(context, LoginScreen.routeName);
                }, 'LOG IN'),
                SizedBox(height: 20),
                SizedBox(
                  width: 280,
                  height: 45,
                  child: OutlinedButton(
                    child: Text('SIGN UP',
                        style: TextStyle(fontSize: 18, color: Colors.black)),
                    onPressed: () {
                      Navigator.pushNamed(context, SignupScreen.routeName);
                    },
                    style: ButtonStyle(
                        side: MaterialStateProperty.all<BorderSide>(
                            BorderSide(color: Colors.black))),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
