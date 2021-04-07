import 'package:flutter/material.dart';

class ColoredWelcomeButton extends StatelessWidget {
  final Function pressHandler;
  final String label;
  ColoredWelcomeButton(this.pressHandler, this.label);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 45,
      child: ElevatedButton(
        child: Text(label, style: TextStyle(fontSize: 18, color: Colors.black)),
        onPressed: pressHandler,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
        ),
      ),
    );
  }
}
