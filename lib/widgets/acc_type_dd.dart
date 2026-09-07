import 'package:flutter/material.dart';

class DropdownMenu extends StatelessWidget {
  const DropdownMenu({super.key, required this.items, required this.onChanged});
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          labelText: 'Role',
          hintText: 'Select an option',
          border: OutlineInputBorder(),
        ),
        items: items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: onChanged,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select an option';
          }
          return null;
        },
      ),
    );
  }
}
