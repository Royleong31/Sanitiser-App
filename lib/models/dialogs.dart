import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sanitiser_app/models/const.dart';
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
                                content: Text(
                                    'Successfully reset counter!',
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
    barrierColor: Colors.transparent,
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
