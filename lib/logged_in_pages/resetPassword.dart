import 'package:flutter/material.dart';
import 'package:sanitiser_app/models/const.dart';
import 'package:sanitiser_app/widgets/CustomInputField.dart';
import 'package:sanitiser_app/widgets/GeneralButton.dart';
import 'package:sanitiser_app/widgets/OverlayMenu.dart';

class ResetPassword extends StatefulWidget {
  static const routeName = 'reset-password';

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool menuOpened = false;
  String _oldPassword, _newPassword;
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();

  bool _onSaved() {
    final isValid = _formKey.currentState.validate();
    if (!isValid) return false;
    _formKey.currentState.save();
    print(
        'Old Password Value: $_oldPassword, New Password Value: $_newPassword');

    return true;
  }

  void _changePassword() {
    // ADD CHANGE THE PROVIDER AND THE AUTH DETAILS FOR THIS USER
  }

  get appBar {
    return AppBar(
      backgroundColor: Colors.white,
      shadowColor: Colors.white,
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: Icon(
              Icons.circle,
              size: 30,
              color: Theme.of(context).accentColor,
            ),
            onPressed: () {
              setState(() {
                menuOpened = !menuOpened;
              });
            },
          );
        },
      ),
      title: Text(
        'RESET PASSWORD',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: menuOpened ? null : appBar,
      body: Stack(
        children: <Widget>[
          Container(
            margin: menuOpened
                ? EdgeInsets.only(
                    top: appBar.preferredSize.height +
                        MediaQuery.of(context).padding.top)
                : null,
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Container(
                  height: MediaQuery.of(context).size.height -
                      AppBar().preferredSize.height -
                      MediaQuery.of(context).padding.top,
                  child: Column(
                    children: [
                      Container(
                        child: Column(
                          children: [
                            SizedBox(height: 80),
                            CustomInputField(
                                label: 'OLD PASSWORD',
                                obscureText: true,
                                saveHandler: (val) => _oldPassword = val,
                                validatorHandler: (val) {
                                  if (val.length < 6)
                                    return 'Password needs to be at least 6 characters long';
                                  return null;
                                }),
                            CustomInputField(
                              label: 'NEW PASSWORD',
                              obscureText: true,
                              controller: _passwordController,
                              saveHandler: (val) => _newPassword = val,
                              validatorHandler: (val) {
                                if (val.length < 6)
                                  return 'Password needs to be at least 6 characters long';
                                return null;
                              },
                            ),
                            CustomInputField(
                              label: 'CONFIRM NEW PASSWORD',
                              obscureText: true,
                              validatorHandler: (val) {
                                if (val.isEmpty ||
                                    val != _passwordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(child: Container()),
                      GeneralButton('SAVE', kNormalColor, () {
                        if (_onSaved()) _changePassword();
                      }),
                      SizedBox(height: 15),
                      GeneralButton('BACK', kLightGreyColor, () {}),
                      SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ),
          ),
          OverlayMenu(() {
            setState(() {
              menuOpened = !menuOpened;
            });
          }, menuOpened)
        ],
      ),
    );
  }
}
