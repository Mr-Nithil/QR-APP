import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:qr_app/pages/home_page.dart';
import 'package:qr_flutter/qr_flutter.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key, required this.eventId});

  final eventId ;

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> with SingleTickerProviderStateMixin {

  final ImagePicker picker = ImagePicker();
  List<XFile>? imageFiles = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 10), 
      vsync: this,
    );
  }

  Future<void> pickImages() async {
    final List<XFile>? selectedImages = await picker.pickMultiImage();
    if (selectedImages != null && selectedImages.length <= 5) {
      setState(() {
        imageFiles = selectedImages;
      });
    } else {
      showMessage('Only select up to 5 images');
    }
  }

  Future<void> uploadImages() async {
    showDialog(
      context: context, 
      builder: (context){
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    );
    
    if (imageFiles != null && imageFiles!.isNotEmpty) {
      final User? user = _auth.currentUser;
      if (user == null) {
        Navigator.pop(context);
        showMessage('User not logged in');
        return;
      }

      final userId = user.uid;

      final userUploadsRef = _firestore
          .collection('events')
          .doc(widget.eventId)
          .collection('uploads')
          .doc(userId);

      final userUploadsDoc = await userUploadsRef.get();
      int uploadedCount = 0;
      if (userUploadsDoc.exists) {
        uploadedCount = userUploadsDoc.data()?['count'] ?? 0;
      }

      if (uploadedCount + imageFiles!.length > 5) {
        Navigator.pop(context);
        showMessage('You can only upload a total of 5 images');
        return;
      }

      List<String> imageUrls = [];

      for (XFile image in imageFiles!) {
        File file = File(image.path);
        final ref = FirebaseStorage.instance
            .ref('events/${widget.eventId}/${userId}/${image.name}');
        await ref.putFile(file);
        final downloadUrl = await ref.getDownloadURL();
        imageUrls.add(downloadUrl);
      }

      await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(userUploadsRef);

      if (!snapshot.exists) {
        transaction.set(userUploadsRef, {
          'count': imageFiles!.length,
          'imageUrls': imageUrls,
        });
      } else {
        int uploadedCount = snapshot['count'];
        transaction.update(userUploadsRef, {
          'count': uploadedCount + imageFiles!.length,
          'imageUrls': FieldValue.arrayUnion(imageUrls),
        });
      }
    });

      Navigator.pop(context);
      showMessage('Uploaded successfully');
    }
  }

  void showMessage(String message){
    showDialog(
      context: context, 
      builder: (context){
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 196, 21, 56),
          title: Center(
            child: Text(
              message,
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      }
    );
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20,),
                Text(
                      "- Event ID -",
                      style: TextStyle(
                        color: Colors.grey[900],
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      widget.eventId,
                      style: TextStyle(
                        color: Colors.grey[900],
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                LottieBuilder.network(
                  'https://lottie.host/74d4dc0f-e70f-4ea9-917a-c95cebe2559f/apvcGAwWKf.json',
                  controller: _controller,
                  width: 300,
                  height: 300,
                  onLoaded: (composition) {
                    _controller
                      ..duration = composition.duration
                      ..forward(from: 0.0)
                      ..addListener(() {
                        if (_controller.isCompleted) {
                          _controller.stop(); 
                        }
                      });
                  },
                ),
                
                    SizedBox(height: 10,),
                ElevatedButton(
              onPressed: pickImages,
              style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 41, 41, 41), 
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), 
                    ),
                    
                  ),
              child: Padding(
                    padding: const EdgeInsets.fromLTRB(100, 25, 100, 25),
                    child: Text(
                      "Select Photos",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, 
                      ),
                    ),
                  ),
            ),
            SizedBox(height: 30,),
            Container(
              width: 340,
              height: 200,
              color: Colors.white54,
              child: imageFiles != null
                ? Wrap(   
                  spacing: 10,
                    children: imageFiles!.map((image) {
                      return Image.file(File(image.path), width: 100, height: 100);
                    }).toList(),
                  )
                : Container(),
            ),
            SizedBox(height: 30,),
            ElevatedButton(
              onPressed: uploadImages,
              style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(
                        255, 196, 21, 56), 
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), 
                    ),
                    
                  ),
              child: Padding(
                    padding: const EdgeInsets.fromLTRB(100, 25, 100, 25),
                    child: Text(
                      "Upload Photos",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromRGBO(255, 255, 255, 1), 
                      ),
                    ),
                  ),
            ),
            SizedBox(height: 20,),
              ],
            ),
          ),
        ),
    );
  }
}