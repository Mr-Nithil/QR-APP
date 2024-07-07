import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {

  final controller;
  final String hintText;
  final bool obsecureText;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obsecureText
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextField(
                  controller: controller,
                  obscureText: obsecureText,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color:Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    hintText: hintText,
                    hintStyle: TextStyle(
                      color: Colors.grey[600],
                    )
                  ),
                ),
              );
  }
}