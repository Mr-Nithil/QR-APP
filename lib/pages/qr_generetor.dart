import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:qr_app/pages/home_page.dart';

class QrGeneretor extends StatefulWidget {
  const QrGeneretor({super.key});

  @override
  State<QrGeneretor> createState() => _QrGeneretorState();
}

class _QrGeneretorState extends State<QrGeneretor> {

  String? qrData = "3VX7wOxjGb4aFqHl0ItA";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 248, 225, 21),
        appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
                  "EventSnap",
                  style: GoogleFonts.adventPro(
                    fontWeight: FontWeight.bold,
                    fontSize: 36,
                    color: Color.fromARGB(255, 41, 41, 41),
                  ),
                ),
        actions: [ 
          IconButton(
            onPressed: () {
                  Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: ((context) => HomePage()),
                ),
              );
            },
            icon: Icon(
              Icons.home,
              size: 38,
            )
          )
        ],
      ),
        body: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "- Event ID -",
                        style: TextStyle(
                          color: Colors.grey[900],
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        qrData!,
                        style: TextStyle(
                          color: Colors.grey[900],
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      if(qrData != null) PrettyQrView.data(data: qrData!),
                    ],
                  ),
                )

              ),
              Expanded(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                  "EventSnap",
                  style: GoogleFonts.adventPro(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Color.fromARGB(255, 41, 41, 41),
                  ),
                ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}