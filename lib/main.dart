import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import '../pages/login_page.dart';

void main() {
  runApp(
    ToastificationWrapper(
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'HDFC Login Page',
        home: SafeArea(child: LoginPageApp()),
      ),
    ),
  );
}









