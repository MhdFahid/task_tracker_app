import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../consts/app_color_constants.dart';
import '../consts/constants.dart';

class CardItem extends StatelessWidget {
  const CardItem({
    super.key,
    required this.document,
  });
  final DocumentSnapshot document;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: const Color.fromARGB(255, 0, 12, 99),
      color: const Color.fromARGB(255, 255, 255, 255),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Name : ${document['name']}".toUpperCase(),
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColorsConstants.primaryColor),
            ),
            gapH(10),
            Text(
              "Adress : ${document['address']}",
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            gapH(10),
            Text(
              "Age : ${document['age']}",
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            gapH(10),
            Text(
              "Email Id : ${document['email']}",
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
