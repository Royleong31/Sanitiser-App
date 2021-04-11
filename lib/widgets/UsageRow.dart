import 'package:flutter/material.dart';
import 'package:sanitiser_app/models/const.dart';

class UsageRow extends StatelessWidget {
  UsageRow(this.usage, this.date, this.time, {this.refilled: false});
  final String usage, date, time;
  final bool refilled;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: refilled == true ? kNormalColor : Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[TableCell(usage), TableCell(date), TableCell(time)],
      ),
    );
  }
}

class TableCell extends StatelessWidget {
  TableCell(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 100,
      child: Center(
        child: Text(text, style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
