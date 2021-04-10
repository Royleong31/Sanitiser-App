import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  MenuButton({this.onPressed, this.title});
  final Function onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: onPressed,
          child: Text(
            title,
            style: TextStyle(
                color: Colors.black, fontSize: 26, fontWeight: FontWeight.w400),
          ),
          style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  EdgeInsets.all(0))),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
