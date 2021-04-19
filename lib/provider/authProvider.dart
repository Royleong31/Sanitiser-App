import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sanitiser_app/admin_pages/welcome_screen.dart';
import 'package:sanitiser_app/logged_in_pages/homeScreen.dart';
import 'package:sanitiser_app/provider/userProvider.dart';
import 'package:provider/provider.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth firebaseAuth;
  AuthProvider(this.firebaseAuth);

  Stream<User> get authState => firebaseAuth.idTokenChanges();

  //SIGN UP METHOD
  Future<String> signUp({
    @required String email,
    @required String password,
    @required BuildContext context,
    @required String name,
  }) async {
    print('Trying to sign up');
    print('Email: $email, password: $password');
    try {
      final newUser = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      await FirebaseFirestore.instance.collection('users').add({
        'name': name,
        'email': email,
        'deviceTokens': [],
        'dispensers': [],
        'userId': newUser.user.uid,
        'notificationLevel': 10, // DEFAULT NOTIFICATION LEVEL IS 10%
        'notifyWhenRefilled': true,
      });

      Navigator.pop(context);
      print('signed up!');
      return "Signed up!";
    } on FirebaseAuthException catch (e) {
      print('Error: $e');
      throw e.message;
    }
  }

  //SIGN IN METHOD
  Future<String> signIn(String email, String password, context) async {
    print('Trying to sign in');
    print('Email: $email, password: $password');
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      Navigator.pop(context);
      return "Signed in!";
    } on FirebaseAuthException catch (e) {
      print(e);
      throw e.message;
    }
  }

  //SIGN OUT METHOD
  Future<void> signOut(BuildContext context) async {
    final deviceToken =
        Provider.of<UserProvider>(context, listen: false).deviceToken;
    final userDocId =
        Provider.of<UserProvider>(context, listen: false).userDocId;
    final firebaseDocData =
        FirebaseFirestore.instance.collection('users').doc(userDocId);

    await firebaseAuth.signOut();

    final userDoc = await firebaseDocData.get();
    final deviceTokensList = List<String>.from(userDoc.data()['deviceTokens']);

    deviceTokensList.remove(deviceToken);

    firebaseDocData.update({'deviceTokens': deviceTokensList});
    notifyListeners();

    print('User document id: $userDocId');
    print('device Token List: $deviceTokensList');

    await Navigator.of(context).pushNamedAndRemoveUntil(
        '/', ModalRoute.withName(WelcomeScreen.routeName));
  }
}
