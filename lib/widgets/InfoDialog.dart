import 'dart:ui';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:align_positioned/align_positioned.dart';
import 'package:provider/provider.dart';
import 'package:sanitiser_app/models/const.dart';
import 'package:sanitiser_app/provider/userProvider.dart';
import 'package:sanitiser_app/widgets/CustomDialog.dart';
import 'package:sanitiser_app/widgets/GeneralOutlinedButton.dart';
import 'package:sanitiser_app/widgets/UsageRow.dart';
import 'package:intl/date_symbol_data_local.dart';

class InfoDialog extends StatelessWidget {
  InfoDialog({
    @required this.curvedValue,
    @required this.a1,
    @required this.dispenserId,
    @required this.location,
  });

  final double curvedValue;
  final Animation a1;
  final String dispenserId, location;

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    return Transform(
      transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
      child: Opacity(
        opacity: a1.value,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20.0),
          child: CustomDialog(
            insetPadding: EdgeInsets.symmetric(horizontal: 0),
            child: Container(
              color: Colors.white,
              height: 640,
              width: double.infinity,
              child: AlignPositioned.relative(
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top),
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.circle,
                              size: 30,
                              color: Theme.of(context).accentColor,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              Provider.of<UserProvider>(context, listen: false).setMenuOpened();
                            },
                          ),
                          SizedBox(width: 20),
                          Text(
                            location,
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 550,
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TableTitle('USAGE'),
                          TableTitle('DATE'),
                          TableTitle('TIME'),
                        ],
                      ),
                      decoration: BoxDecoration(color: kLightGreyColor),
                    ),
                    Container(
                      height: 480,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('usageData')
                              .where('dispenserId', isEqualTo: dispenserId)
                              .snapshots(),
                          builder: (ctx, usageSnapshot) {
                            if (usageSnapshot.connectionState ==
                                ConnectionState.waiting)
                              return Center(child: CircularProgressIndicator());
                            initializeDateFormatting('en_SG');

                            List<QueryDocumentSnapshot> usageData =
                                usageSnapshot.data.docs;

                            // SORT THE USAGE DATA BY DATETIME
                            usageData.sort((usage1, usage2) =>
                                DateTime.parse(usage1.data()['timeStamp'])
                                    .compareTo(DateTime.parse(
                                        usage2.data()['timeStamp'])));

                            int useCount = 0;
                            List<Widget> lastUsedData = [];

                            for (int i = 0; i < usageData.length; i++) {
                              final DateTime timeStamp =
                                  DateTime.parse(usageData[i]['timeStamp'])
                                      .toLocal();

                              final currentUsage = usageData[i].data();

                              final date =
                                  DateFormat.yMd('en_SG').format(timeStamp);
                              final time = DateFormat.Hm().format(timeStamp);

                              if (currentUsage['wasUsed']) {
                                // IF IT WAS USED
                                useCount++;

                                if (i == usageData.length - 1) {
                                  // IF LAST ELEMENT
                                  // print('adding last used');
                                  lastUsedData
                                      .add(UsageRow('$useCount', date, time));
                                } else if (!usageData[i + 1]
                                    ?.data()['wasUsed']) {
                                  // IF NEXT ELEMENT IS REFILL
                                  // print('adding use num');
                                  lastUsedData
                                      .add(UsageRow('$useCount', date, time));
                                }
                              } else {
                                // IF WAS REFILLED
                                useCount = 0;
                                // print('adding refilled ');
                                lastUsedData.add(
                                  UsageRow('REFILLED', date, time,
                                      refilled: true),
                                );
                              }
                            }

                            lastUsedData = lastUsedData.reversed.toList();

                            return MediaQuery.removePadding(
                              context: context,
                              removeTop: true,
                              child: Scrollbar(
                                radius: Radius.circular(20),
                                controller: scrollController,
                                child: ListView(
                                  reverse: true,
                                  padding: EdgeInsets.all(0),
                                  children: lastUsedData,
                                ),

                                // ListView.builder(
                                //   reverse: true,
                                //   padding: EdgeInsets.all(0),
                                //   itemCount: usageData.length,
                                //   itemBuilder: (ctx, i) {
                                //     initializeDateFormatting('en_SG');
                                //     final Map<String, dynamic> currentUsage =
                                //         usageData[i].data();

                                //     final DateTime timeStamp = DateTime.parse(
                                //             currentUsage['timeStamp'])
                                //         .toLocal();

                                //     final date =
                                //         DateFormat.yMd().format(timeStamp);
                                //     final time =
                                //         DateFormat.Hm().format(timeStamp);

                                //     if (!currentUsage['wasUsed']) {
                                //       useCount = 0;
                                //       return UsageRow('REFILLED', date, time,
                                //           refilled: true);
                                //     }

                                //     useCount++;
                                //     return UsageRow('$useCount', date, time);
                                //   },
                                // ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                GeneralOutlinedButton('CLOSE', () {
                  Navigator.of(context).pop();
                }),
                moveByContainerHeight: 0.5,
                moveByChildHeight: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TableTitle extends StatelessWidget {
  TableTitle(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 37,
      width: 100,
      child: Center(
        child: Text(title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
      ),
    );
  }
}
