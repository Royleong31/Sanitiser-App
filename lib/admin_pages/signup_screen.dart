import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanitiser_app/provider/authProvider.dart';
import 'package:sanitiser_app/widgets/ColoredWelcomeButton.dart';
import 'package:sanitiser_app/widgets/CustomInputField.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class SignupScreen extends StatefulWidget {
  static const routeName = 'sign-up';

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  String _name, _email, _password, _companyId;
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool showSpinner = false;
  List<Map<String, String>> listOfCompanies;

  bool _onSaved() {
    final isValid = _formKey.currentState.validate();
    if (!isValid) return false;
    _formKey.currentState.save();
    FocusScope.of(context).unfocus();
    return true;
  }

  void _registerUser() {
    setState(() {
      showSpinner = true;
    });

    Provider.of<AuthProvider>(context, listen: false)
        .signUp(
            email: _email,
            password: _password,
            context: context,
            name: _name,
            companyId: _companyId)
        .catchError(
      (err) {
        print('Error message: $err');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              err,
              textAlign: TextAlign.center,
            ),
            backgroundColor: Theme.of(context).errorColor,
          ),
        );
      },
    ).whenComplete(() => setState(() => showSpinner = false));
  }

  @override
  void initState() {
    super.initState();
    listOfCompanies = [];
    FirebaseFirestore.instance
        .collection('companies')
        .get()
        .then((QuerySnapshot snp) {
      snp.docs.forEach((element) {
        print('ELEMENT ID: ${element.id}');
        listOfCompanies.add({
          'id': element.id,
          'name': element.data()['companyName'],
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Theme.of(context).accentColor])),
      child: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Scaffold(
            appBar: AppBar(
              leading: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: const Icon(Icons.arrow_back, size: 30),
                    color: Colors.black,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  );
                },
              ),
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Center(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                          height: 130 -
                              AppBar().preferredSize.height -
                              MediaQuery.of(context).padding.top),
                      Text(
                        'SIGN UP',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w400),
                      ),
                      SizedBox(height: 40),
                      CustomInputField(
                        label: 'NAME',
                        saveHandler: (val) => _name = val.trim(),
                      ),
                      CustomInputField(
                          label: 'COMPANY NAME',
                          saveHandler: (val) {
                            var selectedCompany = val.trim();
                            selectedCompany = selectedCompany.toUpperCase();
                            print('Selected COmpany: $selectedCompany');
                            var companyDetails = listOfCompanies.firstWhere(
                                (element) =>
                                    element['name'] == selectedCompany);

                            _companyId = companyDetails['id'];
                            print('Company ID: $_companyId');
                          },
                          validatorHandler: (val) {
                            val = val.trim();
                            val = val.toUpperCase();
                            print("value is: $val");
                            final selectedCompany = listOfCompanies
                                .firstWhere((element) => element['name'] == val,
                                    orElse: () {
                              print('no element found');
                              return null;
                            });
                            print('Selected Company: $selectedCompany');
                            if (selectedCompany == null)
                              return 'Invalid Company Name';
                            return null;
                          }),
                      CustomInputField(
                        label: 'EMAIL',
                        saveHandler: (val) => _email = val.trim(),
                        keyboardType: TextInputType.emailAddress,
                        validatorHandler: (val) {
                          if (!val.contains('@') || !val.contains('.com'))
                            return 'Please enter a valid email address';
                          return null;
                        },
                      ),
                      CustomInputField(
                        label: 'PASSWORD',
                        obscureText: true,
                        saveHandler: (val) => _password = val,
                        controller: _passwordController,
                        validatorHandler: (val) {
                          if (val.length < 6)
                            return 'Password needs to be at least 6 characters long';
                          return null;
                        },
                      ),
                      CustomInputField(
                        label: 'COMFIRM PASSWORD',
                        obscureText: true,
                        validatorHandler: (val) {
                          if (val.isEmpty || val != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      ColoredWelcomeButton(() {
                        print('Company id: $_companyId');
                        print('list of companies: $listOfCompanies');
                        if (_onSaved()) _registerUser();
                      }, 'CREATE ACCOUNT'),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
