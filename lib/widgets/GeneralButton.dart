import 'package:flutter/material.dart';

class GeneralButton extends StatelessWidget {
  GeneralButton(this.text, this.color, this.onPressed);
  final String text;
  final Color color;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 40,
      child: TextButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(color),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.black)),
          onPressed: onPressed,
          child: Text(text,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400))),
    );
  }
}
