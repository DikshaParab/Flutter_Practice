import 'dart:convert';
import 'package:flutter/services.dart';

class DemoDataService {
  static Future<List<dynamic>> loadUsers() async {
    final jsonString = await rootBundle.loadString(
      'assets/data/demo_data.json',
    );

    final data = jsonDecode(jsonString) as Map<String, dynamic>;
    return data['users'] as List<dynamic>;
  }

  static Future<Map<String, dynamic>?> findUserByPhone(
    String phoneNumber,
  ) async {
    final users = await loadUsers();
    for (final user in users) {
      if (user is Map<String, dynamic> &&
          user['ph_no'].toString() == phoneNumber) {
        return user;
      }
    }
    return null;
  }

  static Future<Map<String, dynamic>?> authenticateUser({
    required String username,
    required String password,
    required String accountType,
  }) async {
    final users = await loadUsers();
    for (final user in users) {
      final map = user as Map<String, dynamic>;

      final usernameMatches = map['username'] as String == username;
      final passwordMatches = map['password'] as String == password;
      final accountTypeMatches = map['accountType'] as String == accountType;

      if (usernameMatches && passwordMatches && accountTypeMatches) {
        return map;
      }
    }
    return null;
  }
}
