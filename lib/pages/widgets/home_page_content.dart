import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:qr_app/components/custom_button.dart';
import 'package:qr_app/pages/qr_scanner.dart';

class HomePageContent extends StatefulWidget {
  const HomePageContent({super.key, required this.user});

  final user;

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 10), 
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Logged In as " + widget.user.email!,
            style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
          ),
          SizedBox(height: 30,),
          LottieBuilder.network(
                'https://lottie.host/cf40fd7b-f542-4192-9716-b4a5407b39ef/DTqEKIH6Py.json',
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
          SizedBox(height: 50,),
          ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: ((context) => const QrScanner()),
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
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    "Join Event",
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