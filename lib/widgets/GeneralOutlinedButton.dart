import 'package:flutter/material.dart';

class GeneralOutlinedButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  GeneralOutlinedButton(this.text, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      child: OutlinedButton(
          onPressed: onPressed,
          style: ButtonStyle(
              side: MaterialStateProperty.all<BorderSide>(
                  BorderSide(color: Colors.black))),
          child: Text(
            text,
            style: TextStyle(color: Colors.black),
          )),
    );
  }
}
