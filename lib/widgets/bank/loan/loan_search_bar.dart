import 'package:flutter/material.dart';

class LoanSearchBar extends StatelessWidget{
  const LoanSearchBar({
    super.key,
    required this.controller,
    required this.onSearch,
    required this.onClear,
  });

  final TextEditingController controller;
  final VoidCallback onSearch;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.fromLTRB(50, 8, 16, 16),
      child: Row(
        children: [
          const Text(
            'Customer ID/ Account No. : ',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(width: 12,),
          SizedBox(
            width: 260,
            height: 42,
            child: TextField(
              controller: controller,
              onSubmitted: (_) => onSearch(),
              textCapitalization: TextCapitalization.characters,
              decoration: const InputDecoration(
                isDense: true,
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10)
              ),
            ),
          ),
          const SizedBox(width: 10,),
          SizedBox(
            height: 42,
            width: 80,
            child: ElevatedButton(
              onPressed: onSearch, 
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: const Text('Go')
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            height: 42,
            width: 120,
            child: OutlinedButton(
              onPressed: onClear, 
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('Clear', style: TextStyle(fontSize: 13)),
                  SizedBox(width: 6),
                  Icon(Icons.clear, size: 16),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}