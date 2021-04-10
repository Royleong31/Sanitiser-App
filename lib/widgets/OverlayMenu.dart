import 'dart:ui';

import 'package:flutter/material.dart';

import 'GeneralOutlinedButton.dart';
import 'MenuButton.dart';

class OverlayMenu extends StatelessWidget {
  OverlayMenu(this.pressHandler, this.menuOpened);
  final Function pressHandler;
  final bool menuOpened;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: menuOpened,
      child: Container(
        child: Center(
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
              child: GestureDetector(
                onTap: pressHandler,
                child: !menuOpened
                    ? Container()
                    : Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200.withOpacity(0.5)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // SizedBox(height: appBar.preferredSize.height),
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
                                      onPressed: pressHandler),
                                  SizedBox(width: 20),
                                  Text(
                                    'MENU',
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('WELCOME \nALAN CHOO',
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w400,
                                        color: Theme.of(context)
                                            .secondaryHeaderColor,
                                      )),
                                  SizedBox(height: 70),
                                  MenuButton(
                                      title: 'EDIT PROFILE',
                                      onPressed: () {
                                        print('editing profile');
                                      }),
                                  MenuButton(
                                    title: 'NOTIFICATIONS',
                                    onPressed: () {
                                      print('notifications');
                                    },
                                  ),
                                  MenuButton(
                                      title: 'RESET PASSWORD',
                                      onPressed: () {
                                        print('resetting password');
                                      }),
                                  MenuButton(
                                    title: 'ADD NEW DEVICE',
                                    onPressed: () {
                                      print('adding new device');
                                    },
                                  ),
                                  SizedBox(height: 50),
                                  Align(
                                    alignment: Alignment.center,
                                    child: GeneralOutlinedButton('LOG OUT', () {
                                      print('logging out');
                                    }),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
