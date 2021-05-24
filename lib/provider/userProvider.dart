import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String _name, _userId, _email, _thisDeviceToken, _userDocId, _companyId;
  List<String> _deviceTokens;
  List<String> _dispensers = [];
  int _notificationLevel;
  bool _notifyWhenRefilled;
  bool menuOpened = false;

  void setValues({
    @required String name,
    @required String userId,
    @required String email,
    @required List<String> deviceTokens,
    @required String deviceToken,
    @required String userDocId,
    @required int notificationLevel,
    @required bool notifyWhenRefilled,
    @required String companyId,
  }) {
    this._name = name;
    this._userId = userId;
    this._email = email;
    this._deviceTokens = deviceTokens;
    this._thisDeviceToken = deviceToken;
    this._userDocId = userDocId;
    this._notificationLevel = notificationLevel;
    this._notifyWhenRefilled = notifyWhenRefilled;
    this._companyId = companyId;
    print('Company ID: $_companyId');
  }

  void setMenuOpened() {
    menuOpened = !menuOpened;
    notifyListeners();
  }

  String get deviceToken => _thisDeviceToken;
  String get userDocId => _userDocId;
  String get name => _name;
  String get userId => _userId;
  String get email => _email;
  String get companyId => _companyId;
  int get notificationLevel => _notificationLevel;
  bool get notifyWhenRefilled => _notifyWhenRefilled;

  set setEmail(String newEmail) {
    _email = newEmail;
  }

  Future<void> changeNotificationSettings(int newLevel, bool newNotify) async {
    _notificationLevel = newLevel;
    _notifyWhenRefilled = newNotify;

    final firebaseDocData =
        FirebaseFirestore.instance.collection('users').doc(userDocId);

    await firebaseDocData.update(
        {'notificationLevel': newLevel, 'notifyWhenRefilled': newNotify}); // ?: Update the user doc with the new notification settings
    print('updating notification settings in firebase');
  }

  Future<void> setName(BuildContext context, String name) async {
    final firebaseDocData =
        FirebaseFirestore.instance.collection('users').doc(userDocId);

    _name = name;
    print(firebaseDocData);
    print("New name: $name");
    await firebaseDocData.update({'name': name});
  }

  Future<void> addNewDispenser(String dispenserId) async {
    _dispensers.add(dispenserId);
    final firebaseDocData =
        FirebaseFirestore.instance.collection('users').doc(userDocId);

    await firebaseDocData.update({'dispensers': _dispensers});

    print('Dispenser List: $_dispensers');
  }

  Future<void> deleteDispenser(String dispenserId) async {
    _dispensers.remove(dispenserId);
    final firebaseDocData =
        FirebaseFirestore.instance.collection('users').doc(userDocId);

    await firebaseDocData.update({'dispensers': _dispensers});

    print('Dispenser List: $_dispensers');
  }
}
