import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_app/components/custom_button.dart';
import 'package:qr_app/pages/auth_page.dart';
import 'package:qr_app/pages/login_page.dart';
import 'package:qr_app/pages/widgets/details_page.dart';
import 'package:qr_app/pages/widgets/home_page_content.dart';
import 'package:qr_app/pages/widgets/settings_page.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;

  final user = FirebaseAuth.instance.currentUser!;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget getSelectedWidget(int index) {
    switch (index) {
      case 0:
        return DetailsPage();
      case 1:
        return HomePageContent(user: user);
      case 2:
        return SettingsPage();
      default:
        return HomePageContent(user: user);
    }
  }



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
                FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: ((context) => AuthPage()),
                  ),
                );
              },
              icon: Icon(
                Icons.logout,
                size: 38,
                )
            ),
          ],
        ),
        body: getSelectedWidget(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.info),
              label: 'Details',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Color.fromARGB(255, 214, 8, 70),
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
