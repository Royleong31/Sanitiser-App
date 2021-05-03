import 'package:flutter/material.dart';
import 'package:sanitiser_app/models/const.dart';
import 'package:sanitiser_app/models/dialogs.dart';
import 'GeneralButton.dart';

// ignore: must_be_immutable
class DispenserContainer extends StatelessWidget {
  DispenserContainer({
    @required this.level,
    @required this.location,
    @required this.dispenserId,
  }) {
    refillLow = level <= 10 ? true : false;
    if (level > 50)
      barColor = kNormalColor;
    else if (level > 10)
      barColor = kWarningColor;
    else
      barColor = kLowColor;
  }

  final int level;
  final String location;
  final String dispenserId;
  bool refillLow;
  Color barColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 15, left: 10, right: 10),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: refillLow ? kLowColor : kLightGreyColor,
            blurRadius: refillLow ? 10 : 1,
            spreadRadius: refillLow ? 3 : 0.0,
            offset: Offset(2.0, 2.0),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Location',
              style: TextStyle(
                  fontSize: 14, color: Theme.of(context).secondaryHeaderColor),
            ),
            SizedBox(height: 5),
            Text(location,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
            SizedBox(height: 20),
            Text(
              'REFILL LEVEL',
              style: TextStyle(
                  fontSize: 14, color: Theme.of(context).secondaryHeaderColor),
            ),
            Stack(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: kLightGreyColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  height: 40,
                  width: double.infinity,
                ),
                FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: level / 100,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      color: barColor,
                      borderRadius: level == 100
                          ? BorderRadius.circular(5)
                          : BorderRadius.only(
                              topLeft: Radius.circular(5),
                              bottomLeft: Radius.circular(5),
                            ),
                    ),
                    height: 40,
                  ),
                ),
                Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    height: 40,
                    child: Center(
                      child: Text(
                        '$level%',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GeneralButton(
                    'RESET',
                    kLightGreyColor,
                    level == 100
                        ? () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: Duration(seconds: 2),
                                backgroundColor: Color(0xFFEDB95E),
                                content: Text(
                                  'Refill is already full',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          }
                        : () {
                            openResetDialog(context, dispenserId);
                          }),
                GeneralButton('MORE INFO', klightGreenColor, () {
                  openInfoDialog(context, dispenserId, location);
                })
              ],
            )
          ],
        ),
      ),
    );
  }
}
