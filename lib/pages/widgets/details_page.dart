import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_app/pages/widgets/user_info.dart';

class DetailsPage extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser!;
  final userID = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: SingleChildScrollView(
          child: Column(children: [
            Text(
                        "USER DETAILS",
                        style: TextStyle(
                    color: Colors.grey[800],
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                        ),
            SizedBox(height: 10.0), 
            UserInformation(
              userID: userID,
            ),
          ]),
        ),
      ),
    );
  }
}