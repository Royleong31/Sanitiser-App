import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sanitiser_app/admin_pages/login_screen.dart';
import 'package:sanitiser_app/admin_pages/signup_screen.dart';
import 'package:sanitiser_app/logged_in_pages/editProfile.dart';
import 'package:sanitiser_app/logged_in_pages/homeScreen.dart';
import 'package:sanitiser_app/provider/authProvider.dart';
import './models/custom_route.dart';

import 'admin_pages/welcome_screen.dart';
import 'logged_in_pages/editDevices.dart';
import 'logged_in_pages/notifications.dart';
import 'provider/companyProvider.dart';
import 'splash_screen.dart';
import 'provider/userProvider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // ?: This ensures that firebase is initisalised before the app runs
  await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();

// ?: This makes the app portrait mode only
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ?: Read docs on the provider package. It is a state management system
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => CompanyProvider()),
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(FirebaseAuth.instance),
        ),
        StreamProvider(
          initialData: null,
          create: (context) => context.read<AuthProvider>().authState,
        )
      ],
      builder: (ctx, _) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          // ?: This allows the user to unfocus when they tap out, such as for textfields
          FocusScope.of(context).requestFocus(FocusNode());
          FocusManager.instance.primaryFocus.unfocus();
        },
        child: MaterialApp(
            debugShowCheckedModeBanner:
                false, // ?: Get rid of debug banner on top right screen
            title: 'Sanitiser Info',
            theme: ThemeData(
              primarySwatch: Colors.grey,
              backgroundColor: Colors.white,
              accentColor: Color(0xFF49DAE3),
              secondaryHeaderColor: Colors.black54,
              buttonColor: Color(0xFFE5E5E5),
              accentColorBrightness: Brightness.light,
              pageTransitionsTheme: PageTransitionsTheme(builders: {
                TargetPlatform.android: CustomPageTransitionsBuilder(),
                TargetPlatform.iOS: CustomPageTransitionsBuilder(),
              }),
            ),
            home: Authenticate(),
            routes: {
              // ADMIN PAGES
              WelcomeScreen.routeName: (ctx) => WelcomeScreen(),
              SplashScreen.routeName: (ctx) => SplashScreen(),
              LoginScreen.routeName: (ctx) => LoginScreen(),
              SignupScreen.routeName: (ctx) => SignupScreen(),
              // LOGGED IN PAGES
              HomeScreen.routeName: (ctx) => HomeScreen(),
              EditProfile.routeName: (ctx) => EditProfile(),
              Notifications.routeName: (ctx) => Notifications(),
              EditDevices.routeName: (ctx) => EditDevices(),
            }),
      ),
    );
  }
}

class Authenticate extends StatelessWidget {
  // ?: Check if user is logged in.
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    print("Firebase User: $firebaseUser");

// ?: If user is not logged in, return to welcome screen to log in. Otherwise, bring them to logged in home screen
    if (firebaseUser != null) {
      print('home is homescreen');
      Provider.of<UserProvider>(context, listen: false).menuOpened = false;
      return HomeScreen();
    }

    return WelcomeScreen();
  }
}
