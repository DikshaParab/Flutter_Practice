import 'package:flutter/material.dart';

class RemarksField extends StatelessWidget{
  const RemarksField({super.key, required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Remarks', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: 3,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Add remarks about this loan application',
            contentPadding: EdgeInsets.all(12),
          ),
        )
      ],
    );
  }
}
