import 'dart:convert';
import 'package:flutter/services.dart';

class LoanDetailService {
  static List<Map<String, dynamic>>? _cache;

  static Future<List<Map<String, dynamic>>> loadLoanDetails() async {
    if (_cache != null) return _cache!;

    final jsonString = await rootBundle.loadString(
      'assets/data/loan_data.json',
    );

    final data = jsonDecode(jsonString) as Map<String, dynamic>;
    final list = data['customers'] as List<dynamic>;

    _cache = list.map((item) {
      final customer = Map<String, dynamic>.from(item as Map<String, dynamic>);
      final loan = customer['loan'] as Map<String, dynamic>;
      customer['parsedDate'] = DateTime.parse(loan['date'] as String);
      return customer;
    }).toList();

    return _cache!;
  }
}