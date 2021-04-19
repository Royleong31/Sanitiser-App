import 'package:flutter/foundation.dart';

class UserProvider with ChangeNotifier {
  String _name, _userId, _email, _thisDeviceToken, _userDocId;
  List<String> _dispensers, _deviceTokens;
  int _notificationLevel;
  bool _notifyWhenRefilled;

  void setValues({
    @required String name,
    @required String userId,
    @required String email,
    @required List<String> deviceTokens,
    @required List<String> dispensers,
    @required String deviceToken,
    @required String userDocId,
    @required int notificationLevel,
    @required bool notifyWhenRefilled,
  }) {
    this._name = name;
    this._userId = userId;
    this._email = email;
    this._deviceTokens = deviceTokens;
    this._dispensers = dispensers;
    this._thisDeviceToken = deviceToken;
    this._userDocId = userDocId;
    this._notificationLevel = notificationLevel;
    this._notifyWhenRefilled = notifyWhenRefilled;
  }

  String get deviceToken => _thisDeviceToken;
  String get userDocId => _userDocId;
  String get name => _name;
  String get userId => _userId;
  String get email => _email;
  int get notificationLevel => _notificationLevel;
  bool get notifyWhenRefilled => _notifyWhenRefilled;

  set setName(String newName) {
    _name = newName;
  }

  set setEmail(String newEmail) {
    _email = newEmail;
  }

  set setNotificationLevel(int newLevel) {
    _notificationLevel = newLevel;
  }

  set setNotifyWhenRefilled(bool newNotify) {
    _notifyWhenRefilled = newNotify;
  }
}
