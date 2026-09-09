import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoanEditStorage {
  static Future<void> saveEdit(String customerId, Map<String, dynamic> edit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('edited_loan_$customerId', jsonEncode(edit));
  }

  static Future<Map<String, dynamic>?> getEdit(String customerId) async{
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('edited_loan_$customerId');
    if (saved == null) return null;
    return jsonDecode(saved) as Map<String, dynamic>;
  }
}