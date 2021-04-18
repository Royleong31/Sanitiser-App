import 'package:flutter/material.dart';
import 'package:sanitiser_app/models/const.dart';
import 'package:sanitiser_app/widgets/CustomInputField.dart';
import 'package:sanitiser_app/widgets/GeneralButton.dart';
import 'package:sanitiser_app/widgets/OverlayMenu.dart';

class EditDevices extends StatefulWidget {
  static const routeName = 'edit-devices';

  @override
  _EditDevicesState createState() => _EditDevicesState();
}

class _EditDevicesState extends State<EditDevices> {
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
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(height: 80),
                      Text(
                        'ADD NEW DEVICE',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      SizedBox(height: 20),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                        decoration: BoxDecoration(
                          color: Color(0xFFD0F6F9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(children: [
                          CustomInputField(
                            label: 'LOCATION',
                          ),
                          CustomInputField(
                            label: 'DISPENSER ID',
                          ),
                          GeneralButton('ADD', klightGreenColor, () {})
                        ]),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'EDIT DEVICES',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
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
