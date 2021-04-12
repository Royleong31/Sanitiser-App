import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sanitiser_app/models/userData.dart';
import 'package:sanitiser_app/splash_screen.dart';
import 'package:sanitiser_app/widgets/DispenserContainer.dart';
import 'package:sanitiser_app/widgets/OverlayMenu.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = 'home';

  @override
  Widget build(BuildContext context) {
    String userId = FirebaseAuth.instance.currentUser.uid;
    print('Firebase auth instance: $userId');

    FirebaseFirestore.instance
        .collection('users')
        .where('userId', isEqualTo: '12345678')
        .get()
        .then((QuerySnapshot snp) {
      Map<String, dynamic> userInfo = snp.docs[0].data();

      Provider.of<UserData>(context, listen: false).setValues(
        userInfo['name'],
        userInfo['userId'],
        userInfo['email'],
        List<String>.from(snp.docs[0].data()['deviceTokens']),
        List<String>.from(snp.docs[0].data()['dispensers']),
      );
      print('--------------------');
      final providerObject = Provider.of<UserData>(context, listen: false);
      print('Device Tokens: ${providerObject.deviceTokens}');
      print('Name: ${providerObject.name}');
      print('Email: ${providerObject.email}');
      print('Dispensers: ${providerObject.dispensers}');
      print('User Id: ${providerObject.userId}');
    });

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
