import 'package:flutter/foundation.dart';

class UserProvider with ChangeNotifier {
  String name, userId, email;
  List<String> dispensers, deviceTokens;
  String _thisDeviceToken, _userDocId;

  UserProvider(
      {this.name, this.userId, this.email, this.deviceTokens, this.dispensers});

  void setValues(String _name, String _userId, String _email,
      List<String> _deviceTokens, List<String> _dispensers,
      {String deviceToken, String userDocId}) {
    this.name = _name;
    this.userId = _userId;
    this.email = _email;
    this.deviceTokens = _deviceTokens;
    this.dispensers = _dispensers;
    this._thisDeviceToken = deviceToken;
    this._userDocId = userDocId;
  }

  String get deviceToken {
    return _thisDeviceToken;
  }

  String get userDocId => _userDocId;
}
