import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'dart:typed_data';

import 'package:qr_app/pages/home_page.dart';
import 'package:qr_app/pages/upload_page.dart';
import 'package:qr_app/pages/widgets/settings_page.dart'; 


class QrScanner extends StatefulWidget {
  const QrScanner({super.key});

  @override
  State<QrScanner> createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {


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
                      Icon(
                      Icons.qr_code,
                      color: Color.fromARGB(255, 41, 41, 41),
                      size: 80,
                    ),
                      Text(
                        "Place the QR Code",
                        style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 18,
                  ),
                        )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: MobileScanner(
                  controller: MobileScannerController(
                    detectionSpeed: DetectionSpeed.noDuplicates,
                    returnImage: true,
                    ),
                  onDetect: (capture) {
                    final List<Barcode> barcodes = capture.barcodes;
                    final Uint8List? image = capture.image;
                    // for(final barcode in barcodes){
                    //   print('Barcode found! ${barcode.rawValue}');
                    // }
                    if (barcodes.first.rawValue != null){
                        Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: ((context) => UploadPage(eventId: barcodes.first.rawValue)),
                        ),
                      );
                    }
                  },
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