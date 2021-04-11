import 'package:flutter/material.dart';

class GeneralButton extends StatefulWidget {
  GeneralButton(this.text, this.color, this.onPressed, {this.isAsync = false});
  final String text;
  final Color color;
  final Function onPressed;
  final bool isAsync;

  @override
  _GeneralButtonState createState() => _GeneralButtonState();
}

class _GeneralButtonState extends State<GeneralButton> {
  bool waiting = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 40,
      child: waiting
          ? Center(child: CircularProgressIndicator())
          : TextButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(widget.color),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.black)),
              onPressed: widget.isAsync
                  ? () async {
                      setState(() {
                        waiting = true;
                      });
                      await widget.onPressed();
                      setState(() {
                        waiting = false;
                      });
                    }
                  : widget.onPressed,
              child: Text(widget.text,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400))),
    );
  }
}
