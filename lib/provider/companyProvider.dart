import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CompanyProvider with ChangeNotifier {
  String _companyName, _companyId;
  List<String> _dispensers, _users;

  void setValues({
    @required String companyName,
    @required List<String> dispensers,
    @required List<String> users,
    @required String companyId,
  }) {
    this._companyName = companyName;
    this._dispensers = dispensers;
    this._users = users;
    this._companyId = companyId;

    print('---------------------');
    print('Company Name: $_companyName');
    print('Dispensers: $_dispensers');
    print('Company ID: $companyId');
    print('Users: $_users');
  }

  String get companyName => _companyName;
  String get companyId => _companyId;
  List<String> get users => users;
  List<String> get dispensers => dispensers;

  Future<void> addNewDispenser(String dispenserId) async {
    _dispensers.add(dispenserId);
    final firebaseDocData =
        FirebaseFirestore.instance.collection('companies').doc(_companyId);

    await firebaseDocData.update({'dispensers': _dispensers});

    print('Added Dispenser List: $_dispensers');
  }

  Future<void> deleteDispenser(String dispenserId) async {
    _dispensers.remove(dispenserId);
    final firebaseDocData =
        FirebaseFirestore.instance.collection('companies').doc(_companyId);

    await firebaseDocData.update({'dispensers': _dispensers});

    print('Deleted Dispenser List: $_dispensers');
  }
}
