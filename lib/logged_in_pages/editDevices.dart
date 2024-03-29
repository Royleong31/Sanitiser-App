import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import 'package:sanitiser_app/models/CustomException.dart';
import 'package:sanitiser_app/models/const.dart';
import 'package:sanitiser_app/models/dialogs.dart';
import 'package:sanitiser_app/models/firebaseDispenser.dart';
import 'package:sanitiser_app/provider/userProvider.dart';
import 'package:sanitiser_app/widgets/CustomInputField.dart';
import 'package:sanitiser_app/widgets/GeneralButton.dart';
import 'package:sanitiser_app/widgets/OverlayMenu.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../splash_screen.dart';

class EditDevices extends StatefulWidget {
  static const routeName = 'edit-devices';

  @override
  _EditDevicesState createState() => _EditDevicesState();
}

class _EditDevicesState extends State<EditDevices> {
  @override
  Widget build(BuildContext context) {
    final String _userId =
        Provider.of<UserProvider>(context, listen: false).userId;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('dispensers')
          .where('companyId',
              isEqualTo:
                  Provider.of<UserProvider>(context, listen: false).companyId)
          .snapshots(),
      builder: (ctx, dispenserSnapshot) {
        if (dispenserSnapshot.connectionState == ConnectionState.waiting)
          return SplashScreen();

        if (dispenserSnapshot.data == null) {
          print('Dispenser snapshot: ${dispenserSnapshot.data}');
          return SplashScreen();
        }

        final List<QueryDocumentSnapshot> dispenserData =
            dispenserSnapshot.data.docs;

        return EditDevicesWidget(dispenserData, _userId);
      },
    );
  }
}

class EditDevicesWidget extends StatefulWidget {
  EditDevicesWidget(this.dispenserData, this.userId);
  final List<QueryDocumentSnapshot> dispenserData;
  final String userId;

  @override
  _EditDevicesWidgetState createState() => _EditDevicesWidgetState();
}

class _EditDevicesWidgetState extends State<EditDevicesWidget> {
  final dispenserIdController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String deviceLocation, dispenserId;
  List<String> locationList = [];
  bool menuOpened = false;

  @override
  void initState() {
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

  bool _onSaved() {
    final isValid = _formKey.currentState.validate();
    if (!isValid) return false;
    _formKey.currentState.save();
    print('Device Location: $deviceLocation');
    print('Dispenser ID: $dispenserId');

    return true;
  }

  void addDeviceDialog() {
    showGeneralDialog(
      barrierColor: Colors.transparent,
      transitionBuilder: (context, a1, a2, _) {
        dispenserIdController.clear();
        return Transform.scale(
          scale: a1.value,
          child: Opacity(
            opacity: a1.value,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
              child: Dialog(
                backgroundColor: Colors.white,
                insetPadding: EdgeInsets.symmetric(horizontal: 0),
                child: Container(
                  height: 330,
                  width: 320,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Text('ADD NEW DEVICE', style: TextStyle(fontSize: 24)),
                        SizedBox(height: 20),
                        CustomInputField(
                          label: 'LOCATION',
                          saveHandler: (val) => deviceLocation = val.trim(),
                        ),
                        Stack(
                          // alignment: Alignment.centerRight,
                          children: [
                            CustomInputField(
                              label: 'DISPENSER ID',
                              controller: dispenserIdController,
                              padRight: true,
                              saveHandler: (val) => dispenserId = val.trim(),
                            ),
                            Positioned(
                              right: 8,
                              bottom: 36,
                              child: GestureDetector(
                                onTap: () async {
                                  print('opening qr code scanner');
                                  await scanQRCode(); // ?: the result of the QR scan will be filled into the dispneserId
                                  print('QR code result is: $dispenserId');
                                },
                                child: Icon(
                                  Icons.qr_code_scanner_sharp,
                                  color: Colors.black,
                                  size: 30,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GeneralButton('CLOSE', Color(0xFFE5E5E5),
                                () => Navigator.of(context).pop()),
                            GeneralButton(
                              'ADD',
                              klightGreenColor,
                              () async {
                                if (_onSaved()) {
                                  try {
                                    if (locationList
                                        .contains(deviceLocation.toUpperCase())) // ?: Reject devices with the same name
                                      throw CustomException(
                                          'Another device has the same name');
                                    await kAddNewDispenser(
                                        deviceLocation.toUpperCase(),
                                        dispenserId,
                                        widget.userId,
                                        context);
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: Colors.lightGreen,
                                        content: Text(
                                          'Successsfully added a new device',
                                          textAlign: TextAlign.center,
                                        ),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  } catch (err) {
                                    print(err.message);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor:
                                            Theme.of(context).errorColor,
                                        content: Text(
                                          err.message,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    );
                                  } finally {
                                    Navigator.of(context).pop();
                                  }
                                }
                              },
                              isAsync: true,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      transitionDuration: Duration(milliseconds: 200),
      barrierDismissible: true,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return;
      },
    );
  }

  Future<void> scanQRCode() async {
    try {
      dispenserId = await FlutterBarcodeScanner.scanBarcode(
        '#49DAE3',
        'Cancel',
        true,
        ScanMode.QR,
      );
      if (dispenserId == '-1' || !mounted) return;

      print('-----------------------------');
      print(dispenserId);
      print('Device ID: $dispenserId');
      dispenserIdController.text = dispenserId;
    } catch (err) {
      print('there was an error: $err');
    }
  }

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
        'EDIT DEVICES',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
      ),
    );
  }

  void removeLocationHandler(String deletedLocation) {
    locationList.remove(deletedLocation);
    print('Location List after deletion: $locationList');
  }

  bool editLocationHandler(String oldLocation, String newLocation) {
    final index = locationList.indexOf(oldLocation);
    print("Location List: $locationList");
    print('New location: $newLocation');
    if (locationList.contains(newLocation)) return false; // ?: Reject locations that have the same name
    locationList[index] = newLocation;
    print('Location List after editing: $locationList');
    return true;
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
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(height: 80),
                      Container(
                        width: 280,
                        height: 40,
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                            color: kNormalColor.withOpacity(0.7),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10))),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Current Devices',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 18, color: Colors.black87)),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: kOffWhiteColor,
                        ),
                        height: MediaQuery.of(context).size.height -
                            AppBar().preferredSize.height -
                            MediaQuery.of(context).padding.top -
                            250,
                        width: 280,
                        child: ListView.builder(
                          itemCount: widget.dispenserData.length,
                          itemBuilder: (ctx, i) {
                            final Map<String, dynamic> currentDoc =
                                widget.dispenserData[i].data();
                            final locationName = currentDoc['location'];
                            if (!locationList.contains(locationName))
                              locationList.add(locationName);
                            print('Location List: $locationList');
                            return DeviceListTile(
                              location: locationName,
                              dispenserId: currentDoc['dispenserId'],
                              removeLocationHandler: removeLocationHandler,
                              editLocationHandler: editLocationHandler,
                            );
                          },
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          print('adding new device');
                          addDeviceDialog();
                        },
                        child: Container(
                          height: 50,
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                              color: kNormalColor.withOpacity(0.9),
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10))),
                          width: 280,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FaIcon(FontAwesomeIcons.plus),
                              SizedBox(width: 20),
                              Text('Add New Device',
                                  style: TextStyle(fontSize: 18)),
                            ],
                          ),
                        ),
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
        ],
      ),
    );
  }
}

class DeviceListTile extends StatelessWidget {
  DeviceListTile(
      {this.location,
      this.dispenserId,
      this.removeLocationHandler,
      this.editLocationHandler});
  final String location, dispenserId;
  final Function removeLocationHandler, editLocationHandler;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 10),
      decoration: BoxDecoration(
        color: kLightGreyColor.withOpacity(0.55),
        border: Border(
          bottom: BorderSide(
            color: Colors.black87,
            width: 0.0,
          ),
        ),
      ),
      child: Column(
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Location',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                ),
              )),
          SizedBox(height: 5),
          Row(
            children: [
              Text(location, style: TextStyle(fontSize: 18)),
              Spacer(),
              Container(
                child: Row(
                  children: [
                    GestureDetector(
                        child: FaIcon(FontAwesomeIcons.solidEdit, size: 24),
                        onTap: () => openEditDialog(
                            context,
                            location,
                            dispenserId,
                            editLocationHandler)), // insert dispenser ID and location to autofill into textfield
                    SizedBox(width: 20),
                    GestureDetector(
                        child: FaIcon(
                          FontAwesomeIcons.solidTrashAlt,
                          size: 24,
                        ),
                        onTap: () => openDeleteDialog(
                            context,
                            dispenserId,
                            location,
                            removeLocationHandler)), // need dispenser ID to delete the device
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
