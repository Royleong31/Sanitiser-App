import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanitiser_app/models/const.dart';
import 'package:sanitiser_app/models/firebaseDispenser.dart';
import 'package:sanitiser_app/provider/userProvider.dart';
import 'package:sanitiser_app/widgets/CustomInputField.dart';
import 'package:sanitiser_app/widgets/GeneralButton.dart';
import 'package:sanitiser_app/widgets/InfoDialog.dart';
import 'package:http/http.dart' as http;

void openResetDialog(BuildContext context, String dispenserId) {
  final String userId =
      Provider.of<UserProvider>(context, listen: false).userId;

  showGeneralDialog(
    barrierColor: Colors.transparent,
    transitionBuilder: (context, a1, a2, widget) {
      return Transform.scale(
        scale: a1.value,
        child: Opacity(
          opacity: a1.value,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
            child: Dialog(
              backgroundColor: Colors.white,
              insetPadding: EdgeInsets.symmetric(horizontal: 0),
              child: Container(
                height: 244,
                width: 320,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Column(
                  children: [
                    Text(
                      'RESET CONFIRMATION',
                      style: TextStyle(fontSize: 24),
                    ),
                    SizedBox(height: 50),
                    Text(
                      'Refilled the unit? Click reset to confirm.',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF9B9B9B),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GeneralButton('CLOSE', Color(0xFFE5E5E5),
                            () => Navigator.of(context).pop()),
                        GeneralButton(
                          'RESET',
                          Theme.of(context).accentColor,
                          () async {
                            final url = Uri.https(
                              'us-central1-hand-sanitiser-c33d1.cloudfunctions.net',
                              '/usage/$userId/$dispenserId/reset',
                            );

                            http.Response response;
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();

                            try {
                              response = await http.patch(url);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text('Successfully reset counter!',
                                    textAlign: TextAlign.center),
                                backgroundColor: Colors.lightGreen,
                                duration: Duration(seconds: 2),
                              ));
                              Navigator.of(context).pop();
                            } catch (e) {
                              print(e);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                duration: Duration(seconds: 2),
                                content: Text(
                                    'There was an error in resetting counter',
                                    textAlign: TextAlign.center),
                                backgroundColor: kLowColor,
                              ));
                            } finally {
                              print(response.body);
                              Navigator.of(context).pop();
                            }
                          },
                          isAsync: true,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
    transitionDuration: Duration(milliseconds: 200),
    barrierDismissible: true,
    barrierLabel: '',
    context: context,
    pageBuilder: (context, animation1, animation2) {
      return;
    },
  );
}

void openInfoDialog(BuildContext context, String dispenserId, String location) {
  showGeneralDialog(
    barrierColor: null,
    transitionBuilder: (context, a1, a2, widget) {
      final curvedValue = Curves.easeIn.transform(a1.value) - 1.0;
      return InfoDialog(
          curvedValue: curvedValue,
          a1: a1,
          dispenserId: dispenserId,
          location: location);
    },
    transitionDuration: Duration(milliseconds: 350),
    barrierDismissible: true,
    barrierLabel: '',
    context: context,
    pageBuilder: (context, animation1, animation2) {
      return null;
    },
  );
}

void openEditDialog(BuildContext context, String location, String dispenserId) {
  final _formKey = GlobalKey<FormState>();

  bool _onSaved() {
    final isValid = _formKey.currentState.validate();
    if (!isValid) return false;
    _formKey.currentState.save();
    print('Location: $location');
    return true;
  }

  showGeneralDialog(
    barrierColor: Colors.transparent,
    transitionBuilder: (context, a1, a2, widget) {
      return Transform.scale(
        scale: a1.value,
        child: Opacity(
          opacity: a1.value,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
            child: Dialog(
              backgroundColor: Colors.white,
              insetPadding: EdgeInsets.symmetric(horizontal: 0),
              child: Container(
                height: 280,
                width: 320,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'EDIT DEVICE',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text('Dispenser ID',
                        style:
                            TextStyle(color: Color(0xFF9B9B9B), fontSize: 14),
                        textAlign: TextAlign.center),
                    SizedBox(height: 6),
                    Text(dispenserId, style: TextStyle(fontSize: 18)),
                    SizedBox(height: 20),
                    Text('Location',
                        style:
                            TextStyle(color: Color(0xFF9B9B9B), fontSize: 14),
                        textAlign: TextAlign.center),
                    SizedBox(height: 6),
                    Form(
                      key: _formKey,
                      child: Container(
                          width: double.infinity,
                          height: 60,
                          child: TextFormField(
                            initialValue: location,
                            cursorColor: Colors.black,
                            onSaved: (val) => location = val.trim(),
                            validator: (val) {
                              if (val.length == 0)
                                return 'Location name cannot be empty';
                              return null;
                            },
                            decoration: InputDecoration(
                              helperText: ' ',
                              filled: true,
                              fillColor: Colors.transparent,
                              contentPadding: EdgeInsets.only(left: 10),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(color: Colors.black)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 2)),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                    color: Theme.of(context).errorColor,
                                    width: 1),
                              ),
                              hintStyle: TextStyle(
                                  fontSize: 1.0, color: Colors.black38),
                            ),
                          )),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GeneralButton('CLOSE', Color(0xFFE5E5E5),
                            () => Navigator.of(context).pop()),
                        GeneralButton(
                          'CONFIRM',
                          Theme.of(context).accentColor,
                          () async {
                            if (_onSaved()) {
                              try {
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();
                                await kEditDispenserLocation(
                                    location.toUpperCase(), dispenserId);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    duration: Duration(seconds: 2),
                                    backgroundColor: Colors.lightGreen,
                                    content: Text(
                                      'Successsfully edited device',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                              } catch (err) {
                                print(err.message);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    duration: Duration(seconds: 2),
                                    backgroundColor:
                                        Theme.of(context).errorColor,
                                    content: Text(
                                      err.message,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                              } finally {
                                Navigator.of(context).pop();
                              }
                            }
                          },
                          isAsync: true,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
    transitionDuration: Duration(milliseconds: 200),
    barrierDismissible: true,
    barrierLabel: '',
    context: context,
    pageBuilder: (context, animation1, animation2) {
      return;
    },
  );
}

void addDeviceDialog(BuildContext context, Function qrHandler) {
  showGeneralDialog(
    barrierColor: Colors.transparent,
    transitionBuilder: (context, a1, a2, widget) {
      return Transform.scale(
        scale: a1.value,
        child: Opacity(
          opacity: a1.value,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
            child: Dialog(
              backgroundColor: Colors.white,
              insetPadding: EdgeInsets.symmetric(horizontal: 0),
              child: Container(
                height: 330,
                width: 320,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Column(
                  children: [
                    Text(
                      'ADD NEW DEVICE',
                      style: TextStyle(fontSize: 24),
                    ),
                    SizedBox(height: 20),
                    CustomInputField(label: 'LOCATION'),
                    Stack(
                      // alignment: Alignment.centerRight,
                      children: [
                        CustomInputField(
                          label: 'DISPENSER ID',
                        ),
                        Positioned(
                          right: 8,
                          bottom: 36,
                          child: GestureDetector(
                            onTap: () async {
                              print('opening qr code scanner');
                              final result = await qrHandler();
                              print('QR code result is: $result');
                            },
                            child: Icon(
                              Icons.qr_code_scanner_sharp,
                              color: Colors.black,
                              size: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GeneralButton('CLOSE', Color(0xFFE5E5E5),
                            () => Navigator.of(context).pop()),
                        GeneralButton(
                          'ADD',
                          klightGreenColor,
                          () {},
                          isAsync: true,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
    transitionDuration: Duration(milliseconds: 200),
    barrierDismissible: true,
    barrierLabel: '',
    context: context,
    pageBuilder: (context, animation1, animation2) {
      return;
    },
  );
}

void openDeleteDialog(
    BuildContext context, String dispenserId, String location) {
  showGeneralDialog(
    barrierColor: Colors.transparent,
    transitionBuilder: (context, a1, a2, widget) {
      return Transform.scale(
        scale: a1.value,
        child: Opacity(
          opacity: a1.value,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
            child: Dialog(
              backgroundColor: Colors.white,
              insetPadding: EdgeInsets.symmetric(horizontal: 0),
              child: Container(
                height: 200,
                width: 320,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Column(
                  children: [
                    Text(
                      'DELETE CONFIRMATION',
                      style: TextStyle(fontSize: 24),
                    ),
                    SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Are you sure you want to delete ',
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xFF9B9B9B),
                              ),
                            ),
                            TextSpan(
                                text: location,
                                style: new TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                )),
                            TextSpan(
                              text: ' dispenser?',
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xFF9B9B9B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GeneralButton('CLOSE', Color(0xFFE5E5E5),
                            () => Navigator.of(context).pop()),
                        GeneralButton(
                          'DELETE',
                          Colors.red,
                          () async {
                            try {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              await kDeleteDispenser(dispenserId, context);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: Duration(seconds: 2),
                                  backgroundColor: Colors.lightGreen,
                                  content: Text(
                                    'Successsfully deleted device',
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
                              Navigator.of(context).pop();
                            }
                          },
                          isAsync: true,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
    transitionDuration: Duration(milliseconds: 200),
    barrierDismissible: true,
    barrierLabel: '',
    context: context,
    pageBuilder: (context, animation1, animation2) {
      return;
    },
  );
}

void openForgotPasswordDialog(BuildContext context) {
  String _email;
  final _formKey = GlobalKey<FormState>();

  bool _onSaved() {
    final isValid = _formKey.currentState.validate();
    if (!isValid) return false;
    _formKey.currentState.save();
    print('Email: $_email');
    return true;
  }

  showGeneralDialog(
    barrierColor: Colors.transparent,
    transitionBuilder: (context, a1, a2, widget) {
      return Transform.scale(
        scale: a1.value,
        child: Opacity(
          opacity: a1.value,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
            child: Dialog(
              backgroundColor: Colors.white,
              insetPadding: EdgeInsets.symmetric(horizontal: 0),
              child: Container(
                height: 228,
                width: 320,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text(
                        'FORGOT PASSWORD',
                        style: TextStyle(fontSize: 24),
                      ),
                      SizedBox(height: 40),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GeneralButton('CLOSE', Color(0xFFE5E5E5),
                              () => Navigator.of(context).pop()),
                          GeneralButton(
                            'ENTER',
                            kNormalColor,
                            () async {
                              if (_onSaved()) {
                                try {
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                  await FirebaseAuth.instance
                                      .sendPasswordResetEmail(email: _email);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.lightGreen,
                                      content: Text(
                                        'An email was sent to your email address to reset your password',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  );
                                } catch (err) {
                                  print(err.message);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor:
                                          Theme.of(context).errorColor,
                                      content: Text(
                                        err.message,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  );
                                } finally {
                                  Navigator.of(context).pop();
                                }
                              }
                            },
                            isAsync: true,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
    transitionDuration: Duration(milliseconds: 200),
    barrierDismissible: true,
    barrierLabel: '',
    context: context,
    pageBuilder: (context, animation1, animation2) {
      return;
    },
  );
}
