import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanitiser_app/provider/userProvider.dart';

Future<void> kAddNewDispenser(String deviceLocation, String dispenserId,
    String userId, BuildContext context) async {
  await FirebaseFirestore.instance.collection('dispensers').add(
    {
      'alert': false,
      'dispenserId': dispenserId,
      'level': 100,
      'limit':
          10, // change this based on the maximum number of times that the dispenser can be used
      'location': deviceLocation,
      'useCount': 0,
      'userId': userId,
    },
  );

  Provider.of<UserProvider>(context, listen: false).addNewDispenser(
      dispenserId); // not async as it is not as impt as updating cloud database so this prevents time wastage.
}

Future<void> kEditDispenserLocation(
    String deviceLocation, String dispenserId) async {
  final dispenserSnapshot = await FirebaseFirestore.instance
      .collection('dispensers')
      .where('dispenserId', isEqualTo: dispenserId)
      .get();

  final dispenserDocId = dispenserSnapshot.docs[0].id;

  await FirebaseFirestore.instance
      .collection('dispensers')
      .doc(dispenserDocId)
      .update({'location': deviceLocation});
}

Future<void> kDeleteDispenser(String dispenserId, BuildContext context) async {
  final dispenserSnapshot = await FirebaseFirestore.instance
      .collection('dispensers')
      .where('dispenserId', isEqualTo: dispenserId)
      .get();

  final dispenserDocId = dispenserSnapshot.docs[0].id;
  await FirebaseFirestore.instance
      .collection('dispensers')
      .doc(dispenserDocId)
      .delete();

  Provider.of<UserProvider>(context, listen: false).deleteDispenser(dispenserId);
  // insert provider delete
}