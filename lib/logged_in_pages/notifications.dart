import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanitiser_app/models/const.dart';
import 'package:sanitiser_app/provider/userProvider.dart';
import 'package:sanitiser_app/widgets/CircleThumbShape.dart';
import 'package:sanitiser_app/widgets/GeneralButton.dart';
import 'package:sanitiser_app/widgets/OverlayMenu.dart';

class Notifications extends StatefulWidget {
  static const routeName = 'notifications';

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  bool menuOpened = false;
  bool notifyWhenRefilled;
  String refillDisabled = 'ENABLED';
  int notificationLevel;
  UserProvider userProviderInfo;

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
            },
          );
        },
      ),
      title: Text(
        'NOTIFICATIONS',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
      ),
    );
  }

  void saveHandler() async {
    try {
      await userProviderInfo.changeNotificationSettings(
          notificationLevel, notifyWhenRefilled);
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.lightGreen,
          content: Text(
            'Successsfully updated notification settings',
            textAlign: TextAlign.center,
          ),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (err) {
      print(err.message);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).errorColor,
          content: Text(
            err.message,
            textAlign: TextAlign.center,
          ),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void initState() {
    userProviderInfo = Provider.of<UserProvider>(context, listen: false);

    notificationLevel = userProviderInfo.notificationLevel;
    notifyWhenRefilled = userProviderInfo.notifyWhenRefilled;
    super.initState();
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
                ? EdgeInsets.only(
                    top: appBar.preferredSize.height +
                        MediaQuery.of(context).padding.top)
                : null,
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height -
                    AppBar().preferredSize.height -
                    MediaQuery.of(context).padding.top,
                child: Column(
                  children: [
                    SizedBox(height: 80),
                    Container(
                      width: 280,
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                      decoration: BoxDecoration(
                          color: Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Notify me when liquid level is at',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 13.5),
                            ),
                          ),
                          SizedBox(height: 16),
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(5)),
                            width: 58,
                            height: 40,
                            child: Center(
                                child: Text('$notificationLevel%',
                                    style: klabelTextStyle)),
                          ),
                          SizedBox(height: 16),
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                                trackHeight: 3,
                                thumbShape: CircleThumbShape(),
                                overlayColor: kNormalColor.withOpacity(0.1),
                                overlayShape:
                                    RoundSliderOverlayShape(overlayRadius: 22),
                                activeTrackColor: kNormalColor,
                                inactiveTrackColor: kLightGreyColor,
                                thumbColor: Colors.white),
                            child: Slider(
                              value: notificationLevel.toDouble(),
                              min: 5,
                              max: 50,
                              onChanged: (double newVal) {
                                setState(() {
                                  notificationLevel = (newVal / 5).round() * 5;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40),
                    Container(
                        width: 280,
                        padding: EdgeInsets.only(left: 15, top: 10, bottom: 10),
                        decoration: BoxDecoration(
                            color: Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: [
                            Text('Notify me when bottle is refilled',
                                style: TextStyle(fontSize: 13.5)),
                            Spacer(),
                            Column(children: [
                              Container(
                                height: 30,
                                child: Switch(
                                  value: notifyWhenRefilled,
                                  onChanged: (newVal) {
                                    setState(() {
                                      notifyWhenRefilled = newVal;
                                      if (notifyWhenRefilled)
                                        refillDisabled = 'ENABLED';
                                      else
                                        refillDisabled = 'DISABLED';
                                    });
                                  },
                                  thumbColor: MaterialStateProperty.all<Color>(
                                      Color(0xFFEEECF1)),
                                ),
                              ),
                              Text(
                                refillDisabled,
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.black54,
                                    fontSize: 10),
                              ),
                            ]),
                            SizedBox(width: 5),
                          ],
                        )),
                    Expanded(child: Container()),
                    GeneralButton('SAVE', kNormalColor, saveHandler),
                    SizedBox(height: 80),
                  ],
                ),
              ),
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
