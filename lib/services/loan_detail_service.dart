import 'dart:convert';
import 'package:flutter/services.dart';
import 'loan_edit_storage.dart';

class LoanDetailService {
  static List<Map<String, dynamic>>? _cache;

  static Future<List<Map<String, dynamic>>> loadLoanDetails() async {
    final jsonString = await rootBundle.loadString('assets/data/customers.json');
    final data = jsonDecode(jsonString) as Map<String, dynamic>;
    final list = data['customers'] as List<dynamic>;

    final customers = <Map<String, dynamic>>[];
    for (final item in list) {
      var customer = Map<String, dynamic>.from(item as Map<String, dynamic>);

      final edit = await LoanEditStorage.getEdit(customer['customer_id'] as String);
      if (edit != null) {
        customer = {...customer, ...edit};
      }

      customer['parsedDate'] = DateTime.parse(customer['date'] as String);
      customers.add(customer);
    }

    _cache = customers;
    return customers;
  }

  static void clearCache() {
    _cache = null;
  }
}