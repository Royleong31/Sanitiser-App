import 'package:flutter/foundation.dart';

class UserData with ChangeNotifier {
  String name, userId, email;
  List<String> dispensers, deviceTokens;

  UserData(
      {this.name, this.userId, this.email, this.deviceTokens, this.dispensers});

  void setValues(String _name, String _userId, String _email,
      List<String> _deviceTokens, List<String> _dispensers) {
    this.name = _name;
    this.userId = _userId;
    this.email = _email;
    this.deviceTokens = _deviceTokens;
    this.dispensers = _dispensers;
  }
}
