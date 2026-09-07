import 'package:flutter/material.dart';

class PasswordField extends StatelessWidget {
  const PasswordField({super.key, required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      child: TextFormField(
        controller: controller,
        obscureText: true,
        decoration: const InputDecoration(
          labelText: 'Password',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter password';
          }
          if (!RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$')
              .hasMatch(value)) {
            return 'Password must contain at least: \n-one uppercase letter, one lowercase letter, \n-one number, one special character';
          }
          if (value.trim().length < 6) {
            return 'Password must be at least 6 characters';
          }
          return null;
        },
      )
    );
  }
}
