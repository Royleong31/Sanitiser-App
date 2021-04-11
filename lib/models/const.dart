import 'dart:ui';
import 'package:align_positioned/align_positioned.dart';
import 'package:sanitiser_app/widgets/CustomDialog.dart';
import 'package:sanitiser_app/widgets/GeneralOutlinedButton.dart';

import '../widgets/GeneralButton.dart';
import 'package:flutter/material.dart';

// COLORS
const kLowColor = Color(0xFFFF8888);
const kWarningColor = Color(0xFFE9C186);
const kNormalColor = Color(0xFF49DAE3);
const kLightGreyColor = Color(0xFFE5E5E5);

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
    pageBuilder: (context, animation1, animation2) {},
  );
}


void openInfoDialog(BuildContext context) {
  showGeneralDialog(
    barrierColor: Colors.transparent,
    transitionBuilder: (context, a1, a2, widget) {
      final curvedValue = Curves.easeIn.transform(a1.value) - 1.0;
      return Transform(
        transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
        child: Opacity(
          opacity: a1.value,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
            child: CustomDialog(
              insetPadding: EdgeInsets.symmetric(horizontal: 0),
              child: Container(
                color: Colors.white,
                height: 640,
                width: double.infinity,
                child: AlignPositioned.relative(
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).padding.top),
                        padding:
                            EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.circle,
                                size: 30,
                                color: Theme.of(context).accentColor,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                // setState(() {
                                //   menuOpened = !menuOpened;
                                // });
                              },
                            ),
                            SizedBox(width: 20),
                            Text(
                              'GARDEN',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 50,
                        width: 550,
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                                height: 37,
                                width: 100,
                                child: Center(
                                    child: Text(
                                  'USAGE',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ))),
                            Container(
                                height: 37,
                                width: 100,
                                child: Center(
                                    child: Text(
                                  'DATE',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ))),
                            Container(
                                height: 37,
                                width: 100,
                                child: Center(
                                    child: Text(
                                  'TIME',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ))),
                          ],
                        ),
                        decoration: BoxDecoration(color: kLightGreyColor),
                      ),
                      Container(
                        height: 480,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: ListView(
                            padding: EdgeInsets.all(0),
                            children: [
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Container(
                                      height: 50,
                                      width: 100,
                                      child: Center(
                                        child: Text('2',
                                            style: TextStyle(fontSize: 16)),
                                      ),
                                    ),
                                    Container(
                                      height: 50,
                                      width: 100,
                                      child: Center(
                                        child: Text('01/04/2021',
                                            style: TextStyle(fontSize: 16)),
                                      ),
                                    ),
                                    Container(
                                      height: 50,
                                      width: 100,
                                      child: Center(
                                        child: Text('21:53:06',
                                            style: TextStyle(fontSize: 16)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Container(
                                      height: 50,
                                      width: 100,
                                      child: Center(
                                        child: Text('2',
                                            style: TextStyle(fontSize: 16)),
                                      ),
                                    ),
                                    Container(
                                      height: 50,
                                      width: 100,
                                      child: Center(
                                        child: Text('01/04/2021',
                                            style: TextStyle(fontSize: 16)),
                                      ),
                                    ),
                                    Container(
                                      height: 50,
                                      width: 100,
                                      child: Center(
                                        child: Text('21:53:06',
                                            style: TextStyle(fontSize: 16)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Container(
                                      height: 50,
                                      width: 100,
                                      child: Center(
                                        child: Text('2',
                                            style: TextStyle(fontSize: 16)),
                                      ),
                                    ),
                                    Container(
                                      height: 50,
                                      width: 100,
                                      child: Center(
                                        child: Text('01/04/2021',
                                            style: TextStyle(fontSize: 16)),
                                      ),
                                    ),
                                    Container(
                                      height: 50,
                                      width: 100,
                                      child: Center(
                                        child: Text('21:53:06',
                                            style: TextStyle(fontSize: 16)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Container(
                                      height: 50,
                                      width: 100,
                                      child: Center(
                                        child: Text('2',
                                            style: TextStyle(fontSize: 16)),
                                      ),
                                    ),
                                    Container(
                                      height: 50,
                                      width: 100,
                                      child: Center(
                                        child: Text('01/04/2021',
                                            style: TextStyle(fontSize: 16)),
                                      ),
                                    ),
                                    Container(
                                      height: 50,
                                      width: 100,
                                      child: Center(
                                        child: Text('21:53:06',
                                            style: TextStyle(fontSize: 16)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Container(
                                      height: 50,
                                      width: 100,
                                      child: Center(
                                        child: Text('2',
                                            style: TextStyle(fontSize: 16)),
                                      ),
                                    ),
                                    Container(
                                      height: 50,
                                      width: 100,
                                      child: Center(
                                        child: Text('01/04/2021',
                                            style: TextStyle(fontSize: 16)),
                                      ),
                                    ),
                                    Container(
                                      height: 50,
                                      width: 100,
                                      child: Center(
                                        child: Text('21:53:06',
                                            style: TextStyle(fontSize: 16)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  GeneralOutlinedButton(
                    'CLOSE',
                    () {
                      print('closing');
                      Navigator.of(context).pop();
                    },
                  ),
                  moveByContainerHeight: 0.5,
                  moveByChildHeight: 1,
                ),
              ),
            ),
          ),
        ),
      );
    },
    transitionDuration: Duration(milliseconds: 350),
    barrierDismissible: true,
    barrierLabel: '',
    context: context,
    pageBuilder: (context, animation1, animation2) {},
  );
}
