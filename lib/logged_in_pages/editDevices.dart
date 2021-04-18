import 'package:flutter/material.dart';
import 'package:sanitiser_app/models/const.dart';
import 'package:sanitiser_app/models/dialogs.dart';
import 'package:sanitiser_app/widgets/CustomInputField.dart';
import 'package:sanitiser_app/widgets/GeneralButton.dart';
import 'package:sanitiser_app/widgets/OverlayMenu.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
                        child: ListView(
                          children: [
                            DeviceListTile('Garden', () {}, () {}),
                            DeviceListTile('Garden', () {}, () {}),
                            DeviceListTile('Garden', () {}, () {}),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          print('adding new device');
                          addDeviceDialog(context);
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
                              Text(
                                'Add New Device',
                                style: TextStyle(fontSize: 18),
                              ),
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
  DeviceListTile(this.location, this.onEdit, this.onDelete);
  final String location;
  final Function onEdit, onDelete;

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
              Text(location.toUpperCase(), style: TextStyle(fontSize: 18)),
              Spacer(),
              Container(
                child: Row(
                  children: [
                    GestureDetector(
                        child: FaIcon(FontAwesomeIcons.solidEdit, size: 22),
                        onTap: () => openEditDialog(context)),
                    SizedBox(width: 20),
                    GestureDetector(
                        child: FaIcon(
                          FontAwesomeIcons.solidTrashAlt,
                          size: 22,
                        ),
                        onTap: () => openDeleteDialog(context)),
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
