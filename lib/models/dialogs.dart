import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sanitiser_app/models/const.dart';
import 'package:sanitiser_app/widgets/CustomInputField.dart';
import 'package:sanitiser_app/widgets/GeneralButton.dart';
import 'package:sanitiser_app/widgets/InfoDialog.dart';
import 'package:http/http.dart' as http;

void openResetDialog(BuildContext context, String userId, String dispenserId) {
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

                            try {
                              response = await http.patch(url);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text('Successfully reset counter!',
                                    textAlign: TextAlign.center),
                                backgroundColor: Colors.lightGreen,
                              ));
                            } catch (e) {
                              print(e);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
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
                            initialValue: location.toUpperCase(),
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
                          'RESET',
                          Theme.of(context).accentColor,
                          () {
                            if (_onSaved()) {
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

void openDeleteDialog(BuildContext context, String dispenserId) {
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
                      child: Text(
                        'Are you sure you want to delete GARDEN dispenser?',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF9B9B9B),
                        ),
                        textAlign: TextAlign.left,
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
                          () {
                            print('dispenser Id: $dispenserId');
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
