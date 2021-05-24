import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
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
  bool showSpinner = false;
  bool showPasswordInfo = false;
  List<String> changeMenuText = ['RESET PASSWORD', 'CHANGE NAME'];
  String _name, _newPassword, _oldPassword;
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _oldPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  AnimationController _controller;
  Animation<double> _opacityAnimation;
  Animation<double> _alwaysVisibleOpacityAnimation;
  var _slideAnimation;

  @override
  void initState() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("${message.notification.title}!"),
          content: message.notification.body.isEmpty
              ? null
              : Text("${message.notification.body}"),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      );

      if (message.notification != null) {
        print(
            'Message also contained a notification: title: ${message.notification.title} body: ${message.notification.body}');
      }
    });

// ?: This helps o create the animation
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
    _controller.dispose(); // ?: Dispose of controller to prevent memory leaks
    super.dispose();
  }

  bool _onSaved() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (!isValid) return false;
    _formKey.currentState.save();
    print('Name Value: $_name');
    print('Old Password Value: $_oldPassword');
    print('New Password Value: $_newPassword');

    return true;
  }

  void _clearPasswordControllers() {
    _confirmPasswordController.clear();
    _passwordController.clear();
    _oldPasswordController.clear();
  }

  Future<void> _editName() async {
    print('editing name');
    try {
      setState(() {
        showSpinner = true;
      });
      // ?: If there is an error, it will go to catch block
      await Provider.of<UserProvider>(context, listen: false)
          .setName(context, _name);
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 2),
          backgroundColor: Colors.lightGreen,
          content: Text(
            'Successsfully changed name',
            textAlign: TextAlign.center,
          ),
        ),
      );
    } catch (err) {
      print(err.message);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 2),
          backgroundColor: Theme.of(context).errorColor,
          content: Text(
            err.message,
            textAlign: TextAlign.center,
          ),
        ),
      );
    } finally {
      setState(() {
        showSpinner = false;
      });
    }
  }

  Future<void> _editPassword() async {
    print('editing password');
    try {
      setState(() {
        showSpinner = true;
      });
      await Provider.of<AuthProvider>(context, listen: false)
          .changePassword(_oldPassword, _newPassword);
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 2),
          backgroundColor: Colors.lightGreen,
          content: Text(
            'Successsfully changed password',
            textAlign: TextAlign.center,
          ),
        ),
      );
      _clearPasswordControllers();
    } catch (err) {
      print(err.message);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 2),
          backgroundColor: Theme.of(context).errorColor,
          content: Text(
            err.message,
            textAlign: TextAlign.center,
          ),
        ),
      );
    } finally {
      setState(() {
        showSpinner = false;
      });
    }
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
              FocusScope.of(context).unfocus();
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

    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
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
                                  validatorHandler: (val) {
                                    if (val.isEmpty)
                                      return 'Name cannot be empty';
                                    if (val.length > 15)
                                      return 'Name needs to be shorter than 15 characters';
                                    return null;
                                  },
                                ),
                              if (showPasswordInfo) // IF EDITING PASSWORD
                                Column(children: [
                                  FadeTransition(
                                    opacity: _alwaysVisibleOpacityAnimation,
                                    child: CustomInputField(
                                      label: 'CURRENT PASSWORD',
                                      controller: _oldPasswordController,
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
                                        saveHandler: (val) =>
                                            _newPassword = val,
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
                                        controller: _confirmPasswordController,
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
                        Container(
                          width: 120,
                          child: TextButton(
                            onPressed: () {
                              _clearPasswordControllers();
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
                            style: TextButton.styleFrom(
                                backgroundColor: kOffWhiteColor),
                            child: Text(
                              changeMenuText[isEditName ? 0 : 1],
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12),
                            ),
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
      ),
    );
  }
}
