import 'package:flutter/material.dart';

class LoanDetailPanel extends StatelessWidget {
  const LoanDetailPanel({super.key, required this.customer});
  final Map<String, dynamic> customer;

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final loan = customer['loan'] as Map<String, dynamic>;
    final date = customer['parsedDate'] as DateTime;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Loan Details',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _field('Loan Type', loan['loan_type'] as String)),
              const SizedBox(width: 40),
              Expanded(
                child: _field('Loan Subtype', loan['loan_subtype'] as String),
              ),
            ],
          ),
          const SizedBox(height: 28),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _field('Loan Status', loan['loan_status'] as String),
              ),
              const SizedBox(width: 40),
              Expanded(
                child: _field('Application Date', _formatDate(date)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _field(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140,
          child: Text(
            '$label :',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ),
        Expanded(
          child: Text(value, style: const TextStyle(fontSize: 14)),
        ),
      ],
    );
  }
}