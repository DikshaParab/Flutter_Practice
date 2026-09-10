import 'package:flutter/material.dart';

class LoanUpdatedSummaryTable extends StatelessWidget{
  const LoanUpdatedSummaryTable({
    super.key, required this.customer
  });
  final Map<String, dynamic> customer;

  @override
  Widget build(BuildContext context){
    const headers = [
        'Customer ID',
        'Name',
        'Mobile Number',
        'Account Number',
        'Loan Type',
        'Loan Sub-Type',
        'Loan Status',
        'Remarks',
    ];

    final values = [
      (customer['customer_id'] ?? '').toString(),
      (customer['name'] ?? '').toString(),
      (customer['phone_number'] ?? '').toString(),
      (customer['account_number'] ?? '').toString(),
      (customer['loan_type'] ?? '').toString(),
      (customer['loan_subtype'] ?? '').toString(),
      (customer['loan_status'] ?? '').toString(),
      (customer['remarks'] ?? '').toString().isEmpty ? '-' : (customer['remarks'] ?? '').toString(),
    ];

    

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Updated Loan Record',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Table(
          border: TableBorder.all(color: Colors.grey[400]!),
          columnWidths: const {
            0: FlexColumnWidth(1),   
            1: FlexColumnWidth(1.4), 
            2: FlexColumnWidth(1.2), 
            3: FlexColumnWidth(1.6), 
            4: FlexColumnWidth(1.2), 
            5: FlexColumnWidth(1.6), 
            6: FlexColumnWidth(1),   
            7: FlexColumnWidth(2),   
          },          
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(
              decoration: BoxDecoration(color: Colors.blue[800]),
              children: headers.map(
                (h) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  child: Text(
                    h,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                )
              ).toList(),
            ),

            TableRow(
              children: values.map(
                (v) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                  child: Text(
                    v, 
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 13)
                  ),
                )
              ).toList(),
            )
          ],
        ),
      ]
    );
  }
}