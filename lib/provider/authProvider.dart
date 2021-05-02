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
    @required String companyId,
  }) async {
    print('Trying to sign up');
    print('Email: $email, password: $password');
    try {
      final newUser = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      final newUserId = newUser.user.uid;

      await FirebaseFirestore.instance.collection('users').add({
        'name': name,
        'email': email,
        'deviceTokens': [],
        'userId': newUserId,
        'notificationLevel': 10, // DEFAULT NOTIFICATION LEVEL IS 10%
        'notifyWhenRefilled': true,
        'companyId': companyId,
      });

      final companyDoc =
          FirebaseFirestore.instance.collection('companies').doc(companyId);
      final companyDocDetails = await companyDoc.get();
      // final companyDispensersList = List<String>.from(companyDocDetails.data()['dispensers']);
      final companyUsersList =
          List<String>.from(companyDocDetails.data()['users']);
      companyUsersList.add(newUserId);
      await companyDoc.update({'users': companyUsersList});

      Navigator.pop(context);
      print('signed up!');
      return "Signed up!";
    } on FirebaseAuthException catch (e) {
      print('Error: $e');
      throw e.message;
    }
  }

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

  Future<void> signOut(BuildContext context) async {
    final deviceToken =
        Provider.of<UserProvider>(context, listen: false).deviceToken;
    final userDocId =
        Provider.of<UserProvider>(context, listen: false).userDocId;
    final firebaseDocData =
        FirebaseFirestore.instance.collection('users').doc(userDocId);

    final userDoc = await firebaseDocData.get();
    final deviceTokensList = List<String>.from(userDoc.data()['deviceTokens']);

    deviceTokensList.remove(deviceToken);

    await firebaseDocData.update({'deviceTokens': deviceTokensList});
    await firebaseAuth.signOut();
    await Navigator.of(context).pushNamedAndRemoveUntil(
        '/', ModalRoute.withName(WelcomeScreen.routeName));

    print('User document id: $userDocId');
    print('device Token List: $deviceTokensList');
    notifyListeners();
  }

  Future<void> changePassword(String oldPassword, String newpassword) async {
    //Create an instance of the current user.
    User user = firebaseAuth.currentUser;

    //Pass in the password to updatePassword.
    final authResult = await user.reauthenticateWithCredential(
      EmailAuthProvider.credential(
        email: user.email,
        password: oldPassword,
      ),
    );

    print('Auth Result: $authResult');
    await user.updatePassword(newpassword);
    // May throw an error which is then caught in the editProfile page
  }
}
