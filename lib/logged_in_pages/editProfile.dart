import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanitiser_app/models/const.dart';
import 'package:sanitiser_app/provider/authProvider.dart';
import 'package:sanitiser_app/provider/userProvider.dart';
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
  String _name, _email;
  final _formKey = GlobalKey<FormState>();

  bool _onSaved() {
    final isValid = _formKey.currentState.validate();
    if (!isValid) return false;
    _formKey.currentState.save();
    print('Name Value: $_name, Email Value: $_email');

    return true;
  }

  Future<void> _editProfileDetails() async {
    final userProviderDetails =
        Provider.of<UserProvider>(context, listen: false);
    userProviderDetails.setEmail = _email;
    userProviderDetails.setName = _name;

    if (await setNameAndEmail(context, name: _name, email: _email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.lightGreen,
          content: Text(
            'Successsfully updated the database',
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).errorColor,
          content: Text(
            'A problem occured, please try again',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  Future<bool> setNameAndEmail(BuildContext context,
      {@required String name, @required String email}) async {
    try {
      final userDocId =
          Provider.of<UserProvider>(context, listen: false).userDocId;
      final firebaseDocData =
          FirebaseFirestore.instance.collection('users').doc(userDocId);

      print(firebaseDocData);

      print("New name: $name");
      print("New email: $email");
      // IMPT NEED TO UPDATE EMAIL IN AUTH AS CURRENTLY ONLY UPDATE FIRESTORE

      await firebaseDocData.update({'name': name, 'email': email});

      return true;
    } catch (err) {
      print(err);
      return false;
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
        'EDIT PROFILE',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProviderDetails = Provider.of<UserProvider>(context);

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
              child: Form(
                key: _formKey,
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
                              initialValue: userProviderDetails.name,
                              saveHandler: (val) => _name = val.trim(),
                            ),
                            CustomInputField(
                              label: 'EMAIL',
                              keyboardType: TextInputType.emailAddress,
                              initialValue: userProviderDetails.email,
                              saveHandler: (val) => _email = val.trim(),
                              validatorHandler: (val) {
                                if (!val.contains('@') || !val.contains('.com'))
                                  return 'Please enter a valid email address';
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(child: Container()),
                      GeneralButton('SAVE', kNormalColor, () {
                        if (_onSaved()) _editProfileDetails();
                      }),
                      SizedBox(height: 15),
                      GeneralButton('BACK', kLightGreyColor, () {}),
                      SizedBox(height: 80),
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
