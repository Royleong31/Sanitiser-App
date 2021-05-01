import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanitiser_app/logged_in_pages/editDevices.dart';
import 'package:sanitiser_app/logged_in_pages/editProfile.dart';
import 'package:sanitiser_app/logged_in_pages/homeScreen.dart';
import 'package:sanitiser_app/logged_in_pages/notifications.dart';
import 'package:sanitiser_app/provider/authProvider.dart';
import 'package:sanitiser_app/provider/userProvider.dart';

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
                                  Consumer<UserProvider>(
                                    builder: (BuildContext ctx, userData, _) =>
                                        Text(
                                      'WELCOME \n${userData.name}'
                                          .toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w400,
                                        color: Theme.of(context)
                                            .secondaryHeaderColor,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 50),
                                  MenuButton(
                                      title: 'OVERVIEW',
                                      onPressed: () {
                                        Provider.of<UserProvider>(context,
                                                listen: false)
                                            .setMenuOpened();
                                        Navigator.pushReplacementNamed(
                                            context, HomeScreen.routeName);
                                      }),
                                  MenuButton(
                                      title: 'EDIT PROFILE',
                                      onPressed: () {
                                        Navigator.pushReplacementNamed(
                                            context, EditProfile.routeName);
                                      }),
                                  MenuButton(
                                    title: 'NOTIFICATIONS',
                                    onPressed: () {
                                      Navigator.pushReplacementNamed(
                                          context, Notifications.routeName);
                                    },
                                  ),
                                  MenuButton(
                                    title: 'EDIT DEVICES',
                                    onPressed: () {
                                      Navigator.pushReplacementNamed(
                                          context, EditDevices.routeName);
                                    },
                                  ),
                                  SizedBox(height: 70),
                                  Align(
                                    alignment: Alignment.center,
                                    child: GeneralOutlinedButton('LOG OUT',
                                        () async {
                                      print('logging out');
                                      try {
                                        await Provider.of<AuthProvider>(context,
                                                listen: false)
                                            .signOut(context);
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .hideCurrentSnackBar();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          duration: Duration(seconds: 2),
                                          backgroundColor:
                                              Theme.of(context).errorColor,
                                          content: Text(
                                            'Error signing out',
                                            textAlign: TextAlign.center,
                                          ),
                                        ));
                                      }
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
