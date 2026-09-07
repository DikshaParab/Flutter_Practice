import 'package:flutter/material.dart';

class CustomerListItem extends StatelessWidget {
  const CustomerListItem({super.key, required this.customer});
  final Map<String, dynamic> customer;

  String _maskedAccount(String accountNumber) {
    if (accountNumber.length <= 4) return accountNumber;
    return '**** ${accountNumber.substring(accountNumber.length - 4)}';
  }

  String _formatDate(DateTime date) {
    return '${date.year}- ${date.month.toString().padLeft(2, '0')}- ${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final name = customer['name'] as String;
    final customerID = customer['customer_id'] as String;
    final accNumber = customer['account_number'] as String;
    final loan_status = customer['loan_status'] as String;
    final date = customer['parsedDate'] as DateTime;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: ListTile(
        title: Text('$name ($customerID)'),
        subtitle: Text('${_maskedAccount(accNumber)} # ${_formatDate(date)}'),
        trailing: Text(loan_status),
      ),
    );
  }
}
