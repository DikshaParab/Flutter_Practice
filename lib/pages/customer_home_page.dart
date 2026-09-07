import 'package:demo/pages/login_page.dart';
import 'package:flutter/material.dart';
import '../widgets/my_app_bar.dart';
import '../widgets/logout_button.dart';

class CustomerHomePage extends StatelessWidget{
  const CustomerHomePage ({super.key,required this.username});
  final String username;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56), 
        child: MyAppBar(
          title: const Text(''),
          action: LogoutButton(
            onPressed: (){
              Navigator.pushReplacement(
                context, 
                MaterialPageRoute(builder: (context) => const LoginPageApp())
              );
            }
          ),
        )
      ),
      body: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.account_circle, size: 32, color: Colors.blue),
            const SizedBox(width: 12),
            Text(
              'Welcome, $username!',
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}