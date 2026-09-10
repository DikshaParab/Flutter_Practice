import 'package:demo/pages/bank_loan_page.dart';
import 'package:flutter/material.dart';
import 'package:demo/widgets/my_app_bar.dart';
import 'package:demo/widgets/logout_button.dart';
import 'package:demo/widgets/bank/dashboard_card.dart';
import 'package:demo/pages/login_page.dart';
import 'package:demo/pages/bank_home_page.dart';

class BankDashboardPage extends StatelessWidget {
  const BankDashboardPage({super.key, required this.username});
  final String username;

  String _capitalizeFirstLetter(String value) {
    if (value.isEmpty) return value;
    return '${value[0].toUpperCase()}${value.substring(1)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: MyAppBar(
          title: const Text(''),
          action: LogoutButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPageApp()),
              );
            },
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, ${_capitalizeFirstLetter(username)}!',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Center(
                child: Wrap(
                  spacing: 30,
                  runSpacing: 24,
                  alignment: WrapAlignment.center,
                  children: [
                    SizedBox( 
                      height: 230, width: 300,
                      child:DashboardCard(
                        title: 'Customer Records',
                        subtitle: 'View and filter loan applications',
                        icon: Icons.people_outline,
                        color: Colors.blue[700]!,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(username: username),
                            ),
                          );
                        },
                      ),
                    ),

                    SizedBox(
                      width: 300, height: 230,
                      child: DashboardCard(
                        title: 'Loan Details',
                        subtitle: 'Full customer & loan info with contact number',
                        icon: Icons.folder_shared_outlined,
                        color: Colors.purple[700]!,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => BankLoanPage(username: username)),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}