import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sanitiser_app/splash_screen.dart';
import 'package:sanitiser_app/widgets/DispenserContainer.dart';
import 'package:sanitiser_app/widgets/OverlayMenu.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = 'home';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    print('Firebase auth instance: ${FirebaseAuth.instance.currentUser.uid}');
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('dispensers').snapshots(),
      builder: (ctx, dispenserSnapshot) {
        if (dispenserSnapshot.connectionState == ConnectionState.waiting)
          return SplashScreen();

        final List<QueryDocumentSnapshot> dispenserData =
            dispenserSnapshot.data.docs;
        return HomeWidget(dispenserData);
      },
    );
  }
}

class HomeWidget extends StatefulWidget {
  HomeWidget(this.dispenserData);
  final List<QueryDocumentSnapshot> dispenserData;

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
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
              itemCount: widget.dispenserData.length,
              itemBuilder: (ctx, i) {
                final Map<String, dynamic> currentDoc =
                    widget.dispenserData[i].data();

                return DispenserContainer(
                  level: currentDoc['level'].toInt(),
                  dispenserId: currentDoc['dispenserId'],
                  location: currentDoc['location'],
                );
              },
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
