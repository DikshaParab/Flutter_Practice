import 'package:flutter/material.dart';

class CustomerTable extends StatelessWidget {
  const CustomerTable({super.key, required this.customers});
  final List<Map<String, dynamic>> customers;

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (customers.isEmpty) {
      return const Center(
        child: Text('No customers found!', style: TextStyle(fontSize: 30)),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(1.2), // Customer ID
          1: FlexColumnWidth(1.6), // Name
          2: FlexColumnWidth(2), // Account Number
          3: FlexColumnWidth(1.2), // Loan Status
          4: FlexColumnWidth(1.2), // Date
        },
        border: TableBorder(
          horizontalInside: BorderSide(color: Colors.grey[300]!),
          verticalInside: BorderSide(color: Colors.grey[300]!),
        ),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          const TableRow(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey, width: 1.5),
              ),
            ),
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'Customer ID',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'Name',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'Account Number',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'Loan Status',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'Date',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          ...customers.map((customer) {
            final status = customer['loan_status'] as String;
            return TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Text(
                    customer['customer_id'] as String,
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Text(
                    customer['name'] as String,
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Text(
                    customer['account_number'] as String,
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      status,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Text(
                    _formatDate(customer['parsedDate'] as DateTime),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
