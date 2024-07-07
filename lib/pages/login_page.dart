import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_app/components/custom_button.dart';
import 'package:qr_app/components/custom_text_field.dart';



class LoginPage extends StatefulWidget {

  final Function()? onTap;

  LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}
 
class _LoginPageState extends State<LoginPage> {
  
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  Future signIn() async {

    showDialog(
      context: context, 
      builder: (context){
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    );

    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(), 
        password: passwordController.text.trim()
      );

      Navigator.pop(context);

    } on FirebaseAuthException catch (e) {

      Navigator.pop(context);

      showErrorMessage(e.code);

    }

  }

  @override
  void dispose() {
    emailController.dispose(); 
    passwordController.dispose();
    super.dispose();
  }

  void showErrorMessage(String message){
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
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 248, 225, 21),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 50,),

                Icon(
                  Icons.photo,
                  color: Color.fromARGB(255, 41, 41, 41),
                  size: 100,
                ),
                Text(
                  "EventSnap",
                  style: GoogleFonts.adventPro(
                    fontWeight: FontWeight.bold,
                    fontSize: 52,
                    color: Color.fromARGB(255, 41, 41, 41),
                  ),
                ),
            
                SizedBox(height: 10,),

                Text(
                  'Welcome back!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
            
                SizedBox(height: 20,),

                CustomTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obsecureText: false,
                ),
                SizedBox(height: 20,),

                CustomTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obsecureText: true,
                ),
            
                SizedBox(height: 20,),
            
                CustomButton(
                  onTap: signIn,
                  text: 'Sign In',
                ),
            
                SizedBox(height: 20,),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                    "Don't have an account? ",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                      " Register now",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                      ),
                    ],
                  ),
                ),
            
                SizedBox(height: 50,),
            
              ],
            ),
          ),
        ),
      )
    );
  }
}