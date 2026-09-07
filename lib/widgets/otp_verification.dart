import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpVerificationDialog extends StatefulWidget {
  static const demoOtp = '123456';

  const OtpVerificationDialog({
    super.key,
    required this.mobileNumber,
    required this.onVerify,
    required this.onResend,
  });

  final String mobileNumber;
  final Future<bool> Function(String otp) onVerify;
  final VoidCallback onResend;

  @override
  State<OtpVerificationDialog> createState() => _OtpVerificationDialogState();
}

class _OtpVerificationDialogState extends State<OtpVerificationDialog> {
  final _formkey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  String? _error;
  bool _isVerifying = false;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _handleVerify() async {
    if (!_formkey.currentState!.validate()) return;

    setState(() {
      _isVerifying = true;
      _error = null;
    });

    final isValid = await widget.onVerify(_otpController.text.trim());

    if (!mounted) return;
    setState(() {
      _isVerifying = false;
    });

    if (isValid) {
      Navigator.of(context).pop(true);
    } else {
      setState(() {
        _error = 'Invalid OTP. Please try again!';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Verify your mobile number'),
      content: Form(
        key: _formkey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Enter the OTP sent to ${widget.mobileNumber}.'),
            const SizedBox(height: 16),
            TextFormField(
              controller: _otpController,
              obscureText: true,
              keyboardType: TextInputType.number,
              autofocus: true,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(6),
              ],
              decoration: InputDecoration(
                labelText: 'OTP',
                prefixIcon: const Icon(Icons.lock_outline),
                border: OutlineInputBorder(),
                errorText: _error,
              ),
              validator: (value) {
                if (value == null || !RegExp(r'^\d{6}$').hasMatch(value)) {
                  return 'Enter valid 6-digit OTP';
                }
                return null;
              },
            ),
          ],
        ),
      ),

      actions: [
        TextButton(
          onPressed: () {
            widget.onResend();
            setState(() {
              _error = null;
            });
          },
          child: const Text('Resend OTP'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isVerifying ? null : _handleVerify,
          child: _isVerifying
              ? const SizedBox(
                  width: 25,
                  height: 35,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('Verify'),
        ),
      ],
    );
  }
}
