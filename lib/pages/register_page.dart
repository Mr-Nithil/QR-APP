import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_app/components/custom_button.dart';
import 'package:qr_app/components/custom_text_field.dart';


class RegisterPage extends StatefulWidget {

  final Function()? onTap;

  RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final firstNameController = TextEditingController();

  final lastNameController = TextEditingController();

  final emailController = TextEditingController();

  final confirmEmailController = TextEditingController();

  final mobileNoController = TextEditingController();

  final confirmMobileNoController = TextEditingController();  

  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();

  void signUp() async {

    showDialog(
      context: context, 
      builder: (context){
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    );

    if (emailController.text.trim() != confirmEmailController.text.trim()) {
      Navigator.pop(context); 
      showErrorMessage("Emails do not match");
      return;
    }

    if (mobileNoController.text.trim() != confirmMobileNoController.text.trim()) {
      Navigator.pop(context);
      showErrorMessage("Mobile numbers do not match");
      return;
    }

    if (passwordController.text.trim() != confirmPasswordController.text.trim()) {
      Navigator.pop(context);
      showErrorMessage("Passwords do not match");
      return;
    }

    try{
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(), 
        password: passwordController.text.trim()
      );

      String uid = userCredential.user!.uid;

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'First Name' : firstNameController.text.trim(),
      'Last Name' : lastNameController.text.trim(),
      'Email' : emailController.text.trim(),
      'Mobile No' : mobileNoController.text.trim(),
      });
      
      Navigator.pop(context);

    } on FirebaseAuthException catch (e) {

      Navigator.pop(context);

      showErrorMessage(e.code);

    } catch (e) {

      Navigator.pop(context);

      showErrorMessage("An error occurred");
    }

  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose(); 
    confirmEmailController.dispose();
    mobileNoController.dispose();
    confirmMobileNoController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void showErrorMessage(String message){
    showDialog(
      context: context, 
      builder: (context){
        return AlertDialog(
          backgroundColor: Color.fromARGB(230, 252, 52, 52),
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
                SizedBox(height: 20,),
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
                  'Register with your details!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
            
                SizedBox(height: 20,),

                CustomTextField(
                  controller: firstNameController,
                  hintText: 'First Name',
                  obsecureText: false,
                ),
                SizedBox(height: 20,),

                CustomTextField(
                  controller: lastNameController,
                  hintText: 'Last Name',
                  obsecureText: false,
                ),
                SizedBox(height: 20,),

                CustomTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obsecureText: false,
                ),
                SizedBox(height: 20,),

                CustomTextField(
                  controller: confirmEmailController,
                  hintText: 'Confirm your Email',
                  obsecureText: false,
                ),
                SizedBox(height: 20,),

                CustomTextField(
                  controller: mobileNoController,
                  hintText: 'Mobile No',
                  obsecureText: false,
                ),
                SizedBox(height: 20,),

                CustomTextField(
                  controller: confirmMobileNoController,
                  hintText: 'Confirm your Mobile No',
                  obsecureText: false,
                ),
                SizedBox(height: 20,),

                CustomTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obsecureText: true,
                ),
                SizedBox(height: 20,),

                CustomTextField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm the Password',
                  obsecureText: true,
                ),
            
                SizedBox(height: 20,),
             
                CustomButton(
                  onTap: signUp,
                  text: 'Sign Up'
                ),
            
                SizedBox(height: 20,),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account! ",
                        style: TextStyle(
                          fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                      ),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          "Login now",
                          style: TextStyle(
                        color: Colors.blue,
                        fontSize: 15,
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