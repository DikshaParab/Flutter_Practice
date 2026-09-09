import 'package:flutter/material.dart';

class LoanStatusDropdown extends StatelessWidget {
  const LoanStatusDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Loan Status :', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          initialValue: value,
          isExpanded: true,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
          items: items.map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}