import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final Icon myIcon;
  final TextEditingController myController;
  final String? Function(String?)? myValidator;
  final bool isObscure;

  const MyTextField({
    super.key,
    required this.hintText,
    required this.myController,
    this.myValidator,
    required this.myIcon,
    required this.isObscure,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: true,
      enableInteractiveSelection: true,
      validator: myValidator,
      controller: myController,
      obscureText: isObscure,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        filled: true,
        prefixIcon: myIcon,
      ),
    );
  }
}
