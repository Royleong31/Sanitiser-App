import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanitiser_app/provider/userProvider.dart';

import 'DispenserContainer.dart';
import 'OverlayMenu.dart';

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
              Provider.of<UserProvider>(context, listen: false).setMenuOpened();
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
    menuOpened = Provider.of<UserProvider>(context, listen: true).menuOpened;
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
            Provider.of<UserProvider>(context, listen: false).setMenuOpened();
            // setState(() {
            //   menuOpened = !menuOpened;
            // });
          }, menuOpened)
        ],
      ),
    );
  }
}
