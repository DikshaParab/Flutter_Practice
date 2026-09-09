import 'dart:convert';
import 'package:flutter/services.dart';

class LoanTypeOption {
  const LoanTypeOption({required this.id, required this.name, required this.subtypes});
  final String id;
  final String name;
  final List<LoanSubtypeOption> subtypes;
}

class LoanSubtypeOption {
  const LoanSubtypeOption({required this.id, required this.name});
  final String id;
  final String name;
}

class LoanTypeService {
  static List<LoanTypeOption>? _cache;

  static Future<List<LoanTypeOption>> loadLoanTypes() async {
    if (_cache != null) return _cache!;

    final jsonString = await rootBundle.loadString('assets/data/loan_data.json');
    final data = jsonDecode(jsonString) as Map<String, dynamic>;
    final typeMap = data['loan_type_options'] as Map<String, dynamic>;

    _cache = typeMap.entries.map((entry) {
      final typeName = entry.key;
      final typeData = entry.value as Map<String, dynamic>;
      final subtypesList = typeData['subtypes'] as List<dynamic>;

      final subtypes = subtypesList.map((s) {
        final sub = s as Map<String, dynamic>;
        return LoanSubtypeOption(
          id: sub['subtype_id'] as String,
          name: sub['name'] as String,
        );
      }).toList();

      return LoanTypeOption(
        id: typeData['type_id'] as String,
        name: typeName,
        subtypes: subtypes,
      );
    }).toList();

    return _cache!;
  }
}