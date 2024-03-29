import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:sanitiser_app/provider/companyProvider.dart';
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
  String userId = FirebaseAuth.instance.currentUser.uid; // ?: firebase auth id of the logged in user
  String userDocId;
  final usersCollection = FirebaseFirestore.instance.collection('users');

  String companyId;

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

    messaging.getToken().then((deviceToken) { // ?: Get the device token
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
        ),
      );

      if (message.notification != null) {
        print(
            'Message also contained a notification: title: ${message.notification.title} body: ${message.notification.body}');
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: usersCollection
            .where('userId', isEqualTo: userId)
            .get()
            .then((QuerySnapshot snp) {
          Map<String, dynamic> userInfo = snp.docs[0].data();
          userDocId = snp.docs[0].id; // ?: Get the id of the user document

          final deviceTokens = List<String>.from(userInfo['deviceTokens']);
          companyId = userInfo['companyId'];

          if (!deviceTokens.contains(thisDeviceToken)) {
            deviceTokens.add(thisDeviceToken); // ?: add the device token of the current device if it is not alr in the user's list of device tokens
            print('adding new device token');
          } else {
            print('Device tokens already contains thisDeviceToken');
          }

          usersCollection.doc(userDocId).update({'deviceTokens': deviceTokens});

          Provider.of<UserProvider>(context, listen: false).setValues(
            name: userInfo['name'],
            userId: userInfo['userId'],
            email: userInfo['email'],
            notificationLevel: userInfo['notificationLevel'],
            notifyWhenRefilled: userInfo['notifyWhenRefilled'],
            deviceTokens: deviceTokens,
            deviceToken: thisDeviceToken,
            userDocId: userDocId,
            companyId: companyId,
          );

          return companyId;
        }).then((companyId) { // ?: Don't actually need this .then as companyId is not a Future
          print('Company ID HOME PAGE: $companyId');
          final companyDoc =
              FirebaseFirestore.instance.collection('companies').doc(companyId);
          return companyDoc.get();
        }).then((companyDocDetails) {
          final companyData = companyDocDetails.data();
          final companyId = companyDocDetails.id;
          final dispensers = List<String>.from(companyData['dispensers']);
          final users = List<String>.from(companyData['users']);
          final companyName = companyData['companyName'];

          Provider.of<CompanyProvider>(context, listen: false).setValues(
              companyName: companyName, dispensers: dispensers, users: users, companyId: companyId);
        }),
        builder: (ctx, futureSnapshot) {
          if (futureSnapshot.connectionState == ConnectionState.waiting) // ?: If data has not been received yet, show a loading screen
            return SplashScreen();

          return StreamBuilder( // ?: Stream builders continuously listen for new data and update the UI
            stream: FirebaseFirestore.instance
                .collection('dispensers')
                .where('companyId',
                    isEqualTo: Provider.of<UserProvider>(context, listen: false)
                        .companyId)
                .snapshots(),
            builder: (ctx, dispenserSnapshot) {
              if (dispenserSnapshot.connectionState == ConnectionState.waiting) // ?: If data has not been received yet, show a loading screen
                return SplashScreen();

              if (dispenserSnapshot.data == null) {
                print('Dispenser snapshot: ${dispenserSnapshot.data}');
                return SplashScreen();
              }

              final List<QueryDocumentSnapshot> dispenserData =
                  dispenserSnapshot.data.docs;
              return HomeWidget(dispenserData);
            },
          );
        });
  }
}
