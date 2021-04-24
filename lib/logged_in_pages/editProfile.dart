import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanitiser_app/models/const.dart';
import 'package:sanitiser_app/provider/authProvider.dart';
import 'package:sanitiser_app/provider/userProvider.dart';
import 'package:sanitiser_app/widgets/CustomInputField.dart';
import 'package:sanitiser_app/widgets/GeneralButton.dart';
import 'package:sanitiser_app/widgets/OverlayMenu.dart';

class EditProfile extends StatefulWidget {
  static const routeName = 'edit-profile';

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile>
    with SingleTickerProviderStateMixin {
  bool menuOpened = false;
  bool isEditName = true;
  bool showPasswordInfo = false;
  List<String> changeMenuText = [
    'RESET PASSWORD INSTEAD',
    'CHANGE NAME INSTEAD'
  ];
  String _name, _newPassword, _oldPassword;
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  AnimationController _controller;
  Animation<double> _opacityAnimation;
  Animation<double> _alwaysVisibleOpacityAnimation;
  var _slideAnimation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(begin: Offset(0, -1.5), end: Offset(0, 0))
        .animate(
            CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));

    _opacityAnimation = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _alwaysVisibleOpacityAnimation = Tween(begin: 1.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _onSaved() {
    final isValid = _formKey.currentState.validate();
    if (!isValid) return false;
    _formKey.currentState.save();
    print('Name Value: $_name');
    print('Old Password Value: $_oldPassword');
    print('New Password Value: $_newPassword');

    return true;
  }

  Future<void> _editName() async {
    print('editing name');
    if (await Provider.of<UserProvider>(context, listen: false)
        .setFirebaseName(context, _name)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.lightGreen,
          content: Text(
            'Successsfully updated the database',
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).errorColor,
          content: Text(
            'A problem occured, please try again',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  Future<void> _editPassword() {
    print('editing password');
    Provider.of<AuthProvider>(context, listen: false)
        .changePassword(_oldPassword, _newPassword);
    return null;
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
        'EDIT PROFILE',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProviderDetails = Provider.of<UserProvider>(context);

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
                      SizedBox(height: 80),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        curve: Curves.ease,
                        height: isEditName ? 95 : 300,
                        child: Column(
                          children: [
                            if (!showPasswordInfo) // IF EDITING NAME
                              CustomInputField(
                                label: 'NAME',
                                initialValue: userProviderDetails.name,
                                saveHandler: (val) => _name = val.trim(),
                              ),
                            if (showPasswordInfo) // IF EDITING PASSWORD
                              Column(children: [
                                FadeTransition(
                                  opacity: _alwaysVisibleOpacityAnimation,
                                  child: CustomInputField(
                                    label: 'OLD PASSWORD',
                                    obscureText: true,
                                    saveHandler: (val) => _oldPassword = val,
                                    validatorHandler: (val) {
                                      if (val.length < 6)
                                        return 'Password needs to be at least 6 characters long';
                                      return null;
                                    },
                                  ),
                                ),
                                SlideTransition(
                                  position: _slideAnimation,
                                  child: FadeTransition(
                                    opacity: _opacityAnimation,
                                    child: CustomInputField(
                                      label: 'NEW PASSWORD',
                                      obscureText: true,
                                      saveHandler: (val) => _newPassword = val,
                                      controller: _passwordController,
                                      validatorHandler: (val) {
                                        if (val.length < 6)
                                          return 'Password needs to be at least 6 characters long';
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                                SlideTransition(
                                  position: _slideAnimation,
                                  child: FadeTransition(
                                    opacity: _opacityAnimation,
                                    child: CustomInputField(
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
                                  ),
                                ),
                              ]),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          _passwordController.clear();
                          if (isEditName) {
                            setState(() {
                              isEditName = false;
                              Timer(Duration(milliseconds: 150), () {
                                setState(() {
                                  showPasswordInfo = true;
                                  _controller.forward();
                                });
                              });
                            });
                          } else {
                            setState(() {
                              isEditName = true;
                              showPasswordInfo = false;
                              _controller.reverse();
                            });
                          }
                        },
                        child: Text(
                          changeMenuText[isEditName ? 0 : 1],
                          style: TextStyle(color: Colors.black, fontSize: 14),
                        ),
                      ),
                      Expanded(child: Container()),
                      GeneralButton('SAVE', kNormalColor, () {
                        if (_onSaved() && isEditName)
                          _editName();
                        else if (_onSaved() && !isEditName) _editPassword();
                      }),
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
