import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:sanitiser_app/provider/userProvider.dart';
import 'package:sanitiser_app/splash_screen.dart';
import 'package:sanitiser_app/widgets/HomeWidget.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = 'home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String thisDeviceToken;

  @override
  void initState() {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print(
            'Message also contained a notification: ${message.notification.body}');
      }
    });

    messaging.getToken().then((deviceToken) {
      thisDeviceToken = deviceToken;
      print('Device Token: $deviceToken');
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: Text("${message.notification.title}!"),
                content: message.notification.body.isEmpty
                    ? null
                    : Text("${message.notification.body}"),
                actions: <Widget>[
                  TextButton(
                    child: Text('Close'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ));

      if (message.notification != null) {
        print(
            'Message also contained a notification: title: ${message.notification.title} body: ${message.notification.body}');
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String userId = FirebaseAuth.instance.currentUser.uid;
    String userDocId;
    final usersCollection = FirebaseFirestore.instance.collection('users');

    usersCollection
        .where('userId', isEqualTo: userId)
        .get()
        .then((QuerySnapshot snp) {
      Map<String, dynamic> userInfo = snp.docs[0].data();
      userDocId = snp.docs[0].id;
      final deviceTokens =
          List<String>.from(snp.docs[0].data()['deviceTokens']);
      final dispensers = List<String>.from(snp.docs[0].data()['dispensers']);

      if (!deviceTokens.contains(thisDeviceToken)) {
        deviceTokens.add(thisDeviceToken);
        print('adding new device token');
      } else {
        print('Device tokens already contains thisDeviceToken');
      }

      usersCollection.doc(userDocId).update({'deviceTokens': deviceTokens});

      Provider.of<UserProvider>(context, listen: false).setValues(
        userInfo['name'],
        userInfo['userId'],
        userInfo['email'],
        deviceTokens,
        dispensers,
        deviceToken: thisDeviceToken,
        userDocId: userDocId,
      );
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
