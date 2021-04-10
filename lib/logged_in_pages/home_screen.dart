import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:align_positioned/align_positioned.dart';
import 'package:sanitiser_app/models/const.dart';
import 'package:sanitiser_app/widgets/CustomDialog.dart';
import 'package:sanitiser_app/widgets/GeneralButton.dart';
import 'package:sanitiser_app/widgets/GeneralOutlinedButton.dart';
import 'package:sanitiser_app/widgets/MenuButton.dart';
import 'package:sanitiser_app/widgets/OverlayMenu.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = 'home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool menuOpened = false;

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
              // Navigator.pop(context);
            },
          );
        },
      ),
      title: Text(
        'HOME',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    void _openInfoDialog() {
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
                            padding: EdgeInsets.symmetric(
                                horizontal: 4, vertical: 4),
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
                                    setState(() {
                                      menuOpened = !menuOpened;
                                    });
                                  },
                                ),
                                SizedBox(width: 20),
                                Text(
                                  'GARDEN',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w400),
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
                            decoration: BoxDecoration(color: Color(0xFFE5E5E5)),
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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: menuOpened ? null : appBar,
      body: Stack(
        children: <Widget>[
          Container(
            margin: menuOpened
                ? EdgeInsets.only(top: appBar.preferredSize.height)
                : null,
            child: ListView.builder(
              itemCount: 3,
              itemBuilder: (ctx, i) => Container(
                margin:
                    EdgeInsets.only(top: 10, bottom: 15, left: 10, right: 10),
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      // spreadRadius: 2,
                      // color: Colors.red.withOpacity(1),
                      // blurRadius: 10.0,
                      color: Theme.of(context).buttonColor,
                      blurRadius: 1,
                      spreadRadius: 0.0,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Location',
                        style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).secondaryHeaderColor),
                      ),
                      SizedBox(height: 5),
                      Text('GARDEN',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 18)),
                      SizedBox(height: 20),
                      Text(
                        'REFILL LEVEL',
                        style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).secondaryHeaderColor),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                            color: Theme.of(context).accentColor,
                            borderRadius: BorderRadius.circular(5)),
                        height: 40,
                        child: Center(
                          child: Text('100%'),
                        ),
                        width: double.infinity,
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GeneralButton('RESET COUNT', Color(0xFFE5E5E5), () {
                            setState(() {});
                            openResetDialog(context);
                          }),
                          GeneralButton('MORE INFO', Color(0xFF89F2AD), () {
                            _openInfoDialog();
                          })
                        ],
                      )
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
          // overlayMenu(context, () {
          //   setState(() {
          //     menuOpened = !menuOpened;
          //   });
          // }),
        ],
      ),
    );
  }
}
