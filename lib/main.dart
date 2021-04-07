import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sanitiser_app/admin_pages/login_screen.dart';
import 'package:sanitiser_app/admin_pages/signup_screen.dart';
import './models/custom_route.dart';

import 'admin_pages/welcome_screen.dart';
import 'messaging_page.dart';
import 'splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Sanitiser Info',
          theme: ThemeData(
            primarySwatch: Colors.grey,
            backgroundColor: Colors.white,
            accentColor: Color(0xFF49DAE3),
            buttonColor: Color(0xFFE5E5E5),
            accentColorBrightness: Brightness.light,
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.android: CustomPageTransitionsBuilder(),
              TargetPlatform.iOS: CustomPageTransitionsBuilder(),
            }),
          ),
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (ctx, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting)
                return SplashScreen();

              if (userSnapshot.hasData) {
                return MessagingPage();
              }
              return WelcomeScreen();
            },
          ),
          routes: {
            LoginScreen.routeName: (ctx) => LoginScreen(),
            SignupScreen.routeName: (ctx) => SignupScreen(),
          }),
    );
  }
}
