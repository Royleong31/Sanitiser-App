import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sanitiser_app/widgets/GeneralButton.dart';
import 'package:sanitiser_app/widgets/InfoDialog.dart';

void openResetDialog(BuildContext context) {
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
                        GeneralButton('RESET', Theme.of(context).accentColor,
                            () => Navigator.of(context).pop()),
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
          curvedValue: curvedValue, a1: a1, dispenserId: dispenserId, location: location);
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
