import 'dart:math';
import 'package:flutter/material.dart';

class CaptchaField extends StatelessWidget {
  const CaptchaField({
    super.key,
    required this.code,
    required this.controller,
    required this.onRefresh,
  });

  final String code;
  final TextEditingController controller;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final random = Random();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: code.split('').map((char) {
                    // Slight random rotation/offset per character for a distorted look.
                    final angle = (random.nextDouble() - 0.5) * 0.4;
                    final dy = (random.nextDouble() - 0.5) * 6;
                    return Transform.translate(
                      offset: Offset(0, dy),
                      child: Transform.rotate(
                        angle: angle,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            char,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(
                                255,
                                random.nextInt(100),
                                random.nextInt(100),
                                random.nextInt(150) + 50,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: onRefresh,
              icon: const Icon(Icons.refresh),
              tooltip: 'Refresh captcha',
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Enter the code shown above',
            border: OutlineInputBorder(),
            isDense: true,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter the captcha code';
            }
            if (value.trim() != code) {
              return 'Captcha does not match';
            }
            return null;
          },
        ),
      ],
    );
  }
}