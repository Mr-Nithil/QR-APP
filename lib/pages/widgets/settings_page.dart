import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:qr_app/components/custom_button.dart';
import 'package:qr_app/pages/qr_generetor.dart';
import 'package:qr_flutter/qr_flutter.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> with SingleTickerProviderStateMixin {

  late final AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 10),  
      vsync: this,
    );
  }

  void createDummyEvent() async {
    showDialog(
      context: context, 
      builder: (context){
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    );
    CollectionReference events = FirebaseFirestore.instance.collection('Events');
    await events.add({
      'name': 'Sample Event',
      'description': 'This is a sample event',
      'date': DateTime.now(),
    });
    Navigator.pop(context);
    showMessage('Event created successfully');
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LottieBuilder.network(
                'https://lottie.host/3e707a8f-091e-4e10-8e74-f68b69f515f9/zvFPq3k1Ym.json',
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
          SizedBox(height: 20,),
          CustomButton(onTap: createDummyEvent, text: "Create Event"),
          SizedBox(height: 30,),
          ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: ((context) => const QrGeneretor()),
      ),
    );
                },
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
                    "Generate QR",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, 
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}