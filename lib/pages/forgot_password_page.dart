import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/my_app_bar.dart';
import '../widgets/forgot_password_button.dart';
import '../widgets/otp_verification.dart';
import '../services/auth_service.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  int _step = 0; // 0 = mobile entry, 1 = reset password

  @override
  void dispose() {
    _mobileController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final mobileNumber = _mobileController.text.trim();
    final user = await DemoDataService.findUserByPhone(mobileNumber);
    if (!mounted) return;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No account found for this mobile number.')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Demo OTP sent. Use 123456 to continue.')),
    );

    final verified = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => OtpVerificationDialog(
        mobileNumber: mobileNumber,
        onVerify: (otp) async {
          return otp == OtpVerificationDialog.demoOtp;
        },
        onResend: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('OTP resent. Use 123456 to continue.')),
          );
        },
      ),
    );

    if (!mounted) return;

    if (verified == true) {
      setState(() => _step = 1);
    }
  }

  void _resetPassword() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Password reset successfully.')),
    );
    Navigator.pop(context);
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (!RegExp(
      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$',
    ).hasMatch(value)) {
      return 'Use 6+ characters with uppercase, lowercase, number and symbol';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            MyAppBar(
              title: const Text(''),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child:  IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.arrow_back, color: Colors.black),
                              tooltip: 'Back',
                            ),
                          ), _buildStep(),
                        ],
                      ), 
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep() {
    if (_step == 1) {
      return _buildResetStep();
    }
    return _buildMobileStep();
  }

  Widget _buildMobileStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 48),
        const Text(
          'Reset your password',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        const Text('Enter the mobile number registered to your account.'),
        const SizedBox(height: 32),
        TextFormField(
          controller: _mobileController,
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          decoration: const InputDecoration(
            labelText: 'Mobile number',
            hintText: '10-digit mobile number',
            prefixIcon: Icon(Icons.phone),
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your mobile number';
            }
            if (!RegExp(r'^\d{10}$').hasMatch(value.trim())) {
              return 'Enter a valid 10-digit mobile number';
            }
            return null;
          },
        ),
        const SizedBox(height: 24),
        ForgotPassButton(onPressed: _sendOtp, label: 'Send OTP'),
      ],
    );
  }

  Widget _buildResetStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 48),
        const Text(
          'Create a new password',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 32),
        TextFormField(
          controller: _newPasswordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'New password',
            prefixIcon: Icon(Icons.lock_outline),
            border: OutlineInputBorder(),
          ),
          validator: _validatePassword,
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _confirmPasswordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Confirm password',
            prefixIcon: Icon(Icons.lock_outline),
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value != _newPasswordController.text) {
              return 'Passwords do not match';
            }
            return null;
          },
        ),
        const SizedBox(height: 24),
        ForgotPassButton(onPressed: _resetPassword, label: 'Reset password'),
      ],
    );
  }
}