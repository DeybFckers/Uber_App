import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {

  final String labelText;
  final TextEditingController controller;
  final IconData? icon;
  final Widget? suffixIcon;
  final bool isPasswordText;
  final String? Function(String?)? validator;

  const AuthField({super.key, required this.labelText, required this.controller,
    this.icon, this.suffixIcon, this.isPasswordText = false, this.validator
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPasswordText,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        labelText: labelText,
        labelStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        prefixIcon: icon != null ? Icon(icon, color: Colors.grey[700]): null,
        suffixIcon: suffixIcon,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.black, width: 2.5)
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.black, width: 2.5)
        )
      ),
    );
  }
}
