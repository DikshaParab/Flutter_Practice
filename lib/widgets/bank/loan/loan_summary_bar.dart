import 'package:flutter/material.dart';

class LoanSummaryBar extends StatelessWidget {
  const LoanSummaryBar({super.key, required this.customer});
  final Map<String, dynamic> customer;

  @override
  Widget build(BuildContext context) {
    final loan = customer['loan'] as Map<String, dynamic>;
    final name = customer['name'] as String;
    final phone = customer['phone_number'] as String;
    final account = customer['account_number'] as String;
    final status = loan['loan_status'] as String;
    final custId = customer['customer_id'] as String;

    const headers = [
      'Customer Name',
      'Mobile Number',
      'Account Number',
      'Customer ID',
      'Loan Status',
    ];
    final values = [name, phone, account, custId, status];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Table(
        border: TableBorder.all(color: Colors.grey[400]!),
        columnWidths: const {
          0: FlexColumnWidth(1.4),
          1: FlexColumnWidth(1.2),
          2: FlexColumnWidth(1.6),
          3: FlexColumnWidth(1),
          4: FlexColumnWidth(1),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          TableRow(
            decoration: BoxDecoration(color: Colors.blue[800]),
            children: headers
                .map(
                  (h) => Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 8,
                    ),
                    child: Text(
                      h,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          TableRow(
            children: values.map(
              (v) => Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 8,
                ),
                child: Text(
                  v,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: v == status
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            ).toList(),
          ),
        ],
      ),
    );
  }
}