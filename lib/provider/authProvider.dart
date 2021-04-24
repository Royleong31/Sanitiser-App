import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sanitiser_app/admin_pages/welcome_screen.dart';
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

  Future<bool> changePassword(String oldPassword, String newpassword) async {
    //Create an instance of the current user.
    User user = firebaseAuth.currentUser;

    //Pass in the password to updatePassword.
    try {
      final authResult = await user.reauthenticateWithCredential(
        EmailAuthProvider.credential(
          email: user.email,
          password: oldPassword,
        ),
      );
      print('Auth Result: $authResult');

      await user.updatePassword(newpassword);
      return true;
    } catch (err) {
      print("Password can't be changed" + err.toString());
      return false;
    }
    // user.updatePassword(newpassword).then((_) {
    //   print("Successfully changed password");
    //   return true;
    // }).catchError((error) {
    //   print("Password can't be changed" + error.toString());
    //   //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
    // });
  }
}
