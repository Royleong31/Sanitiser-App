import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';

class MessagingPage extends StatefulWidget {
  @override
  _MessagingPageState createState() => _MessagingPageState();
}

class _MessagingPageState extends State<MessagingPage> {
  List<Message> _messages = [];

  // _setMessage(Map<String, dynamic> message) {
  //   final notification = message['notification'];
  //   final data = message['data'];
  //   final String title = data['title'];
  //   final String body = data['body'];
  //   final String mMessage = data['message'];
  //   print(data);

  //   print('$title, $body, $mMessage');

  //   setState(() {
  //     Message m = Message(title, body, mMessage);
  //     _messages.add(m);
  //   });
  // }

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase messaging test'),
      ),
      body: _messages == []
          ? Text('No Messages yet')
          : ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (ctx, i) {
                return Card(
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      children: [
                        // Text('hello'),
                        Text(_messages[i].title),
                        Text(_messages[i].body),
                        Text(_messages[i].message),
                      ],
                    ),
                  ),
                );
              }),
    );
  }
}

class Message {
  String title;
  String body;
  String message;
  Message(this.title, this.body, this.message);
}
