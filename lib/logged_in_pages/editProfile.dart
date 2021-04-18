import 'package:flutter/material.dart';
import 'package:sanitiser_app/models/const.dart';
import 'package:sanitiser_app/widgets/CustomInputField.dart';
import 'package:sanitiser_app/widgets/GeneralButton.dart';
import 'package:sanitiser_app/widgets/OverlayMenu.dart';

class EditProfile extends StatefulWidget {
  static const routeName = 'edit-profile';

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
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
        'EDIT PROFILE',
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
                child: Column(
                  children: [
                    Container(
                      child: Column(
                        children: [
                          SizedBox(height: 80),
                          CustomInputField(
                            label: 'NAME',
                            saveHandler: (_) {},
                          ),
                          CustomInputField(
                            label: 'EMAIL',
                            saveHandler: (_) {},
                          ),
                        ],
                      ),
                    ),
                    Expanded(child: Container()),
                    GeneralButton('SAVE', kNormalColor, () {}),
                    SizedBox(height: 15),
                    GeneralButton('BACK', kLightGreyColor, () {}),
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
