import 'package:demo/pages/customer_home_page.dart';
import 'package:demo/pages/bank_home_page.dart';
import 'package:demo/pages/forgot_password_page.dart';
import 'package:demo/utils/captcha_generator.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import '../widgets/my_app_bar.dart';
import '../widgets/acc_type_dd.dart' as acc_type_dd;
import '../widgets/username_field.dart';
import '../widgets/password_field.dart';
import '../services/auth_service.dart';
import '../widgets/login_button.dart';
import '../widgets/captcha_field.dart';

class LoginPageApp extends StatefulWidget {
  const LoginPageApp({super.key});

  @override
  State<LoginPageApp> createState() => _LoginPageAppState();
}

class _LoginPageAppState extends State<LoginPageApp> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _captchaController = TextEditingController();

  String? _selectedRole;
  String _captchaCode = generateCaptcha();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _captchaController.dispose();
    super.dispose();
  }

  void _refreshCaptcha(){
    setState(() {
      _captchaCode = generateCaptcha();
      _captchaController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isBank = _selectedRole == 'Bank';

    return Material(
      child: Center(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MyAppBar(title: const Text('')),
              const SizedBox(height: 30),
              const Text(
                'Log In',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              acc_type_dd.DropdownMenu(
                items: const ['Bank', 'Customer'],
                onChanged: (value) {
                  setState(() {
                    _selectedRole = value;
                    if (value == 'Bank'){
                      _captchaCode = generateCaptcha();
                      _captchaController.clear();
                    }
                  });
                },
              ),
              const SizedBox(height: 20),

              UsernameField(controller: _usernameController),
              const SizedBox(height: 20),

              PasswordField(controller: _passwordController),
              const SizedBox(height: 20),

              if (isBank) ...[
                SizedBox(
                  width: 500,
                  child: CaptchaField(
                    code: _captchaCode, 
                    controller: _captchaController, 
                    onRefresh: _refreshCaptcha),
                ),
                const SizedBox(height: 15),
              ],
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgotPasswordPage(),
                      ),
                    );
                  },
                  child: const Text('Forgot password?'),
                ),
              ),
              const SizedBox(height: 15),

              LoginButton(onPressed: _login),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedRole == null) {
      toastification.show(
        context: context,
        type: ToastificationType.warning,
        title: const Text('Please select an account type.'),
        autoCloseDuration: const Duration(seconds: 5),
      );
      return;
    }

    final user = await DemoDataService.authenticateUser(
      username: _usernameController.text.trim(),
      password: _passwordController.text,
      accountType: _selectedRole!,
    );

    if (!mounted) {
      return;
    }

    if (user == null) {
      _usernameController.clear();
      _passwordController.clear();
      if(_selectedRole == 'Bank'){
        _refreshCaptcha();
      }
      toastification.show(
        context: context,
        type: ToastificationType.error,
        title: const Text('Invalid username or password.'),
        autoCloseDuration: const Duration(seconds: 5),
      );
      return;
    }

    toastification.show(
      context: context,
      type: ToastificationType.success,
      title: const Text('Login successful.'),
      autoCloseDuration: const Duration(seconds: 5),
    );

    final username = user['username'] as String;
    _usernameController.clear();
    _passwordController.clear();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => _selectedRole == 'Bank'
        ? HomePage(username: username)
        : CustomerHomePage(username: username)),
    );
  }
}