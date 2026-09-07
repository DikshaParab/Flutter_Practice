import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget {
  const MyAppBar({required this.title, this.action, super.key});
  final Widget title;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 100),
      decoration: BoxDecoration(color: Colors.blue[900]),
      child: Row(
        children: [
          Image.asset(
            'assets/images/hdfc_logo.png',
            width: 150,
            height: 150,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 15),
          Expanded(child: title),
          if (action != null) action!,
        ],
      ),
    );
  }
}