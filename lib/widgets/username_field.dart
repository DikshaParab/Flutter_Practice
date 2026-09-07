import 'package:flutter/material.dart';

class UsernameField extends StatelessWidget {
  const UsernameField({super.key, required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      child: TextFormField(
        controller: controller,
        decoration: const InputDecoration(
          labelText: 'Username',
          border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueAccent, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16)
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter username';
          }
          if (value.trim().length < 3) {
            return 'Username must be at least 3 characters';
          }
          return null;
        },
      )
    );
  }
}
