import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/app_textstyles.dart';
import 'package:flutter_application_1/view/signin_screen.dart';
import 'package:flutter_application_1/view/widgets/custom_textfield.dart';
import 'package:get/get.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  String? _errorMessage;
  String? _sentOtp;
  bool _isSendingOtp = false;
  int _secondsRemaining = 0;
  Timer? _timer;
  bool _isOtpValid = false;

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _sendOtp() async {
    if (_emailController.text.isEmpty || !GetUtils.isEmail(_emailController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email before requesting OTP.')),
      );
      return;
    }

    setState(() {
      _isSendingOtp = true;
      _secondsRemaining = 120;
      _sentOtp = (100000 + (DateTime.now().millisecondsSinceEpoch % 900000)).toString();
      _isOtpValid = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('OTP sent to ${_emailController.text} (demo: $_sentOtp)')),
    );

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        timer.cancel();
        setState(() {
          _isSendingOtp = false;
        });
      }
    });
  }

  void _validateOtp(String value) {
    setState(() {
      _isOtpValid = value == _sentOtp;
    });
  }

  bool _confirmpassword() {
    return _emailController.text.isNotEmpty &&
        _otpController.text.isNotEmpty &&
        _isOtpValid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(
                'Forget your password',
                style: AppTextstyles.withColor(
                  AppTextstyles.h1,
                  Theme.of(context).textTheme.bodyLarge!.color!,
                )
              ),
              const SizedBox(height: 16),
              Text(
                'Please enter your email',
                style: AppTextstyles.withColor(
                  AppTextstyles.h2,
                  Theme.of(context).textTheme.bodyLarge!.color!,
                ),
              ),
              const SizedBox(height: 40),
              //Email input text
              CustomTextfield(
                label: 'Email',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!GetUtils.isEmail(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
              ),
              const SizedBox(height: 16),
              // OTP
              Row(
                children: [
                  Expanded(
                    child: CustomTextfield(
                      label: 'Enter OTP',
                      prefixIcon: Icons.verified_user,
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      onChanged: _validateOtp,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the OTP';
                        }
                        if (!_isOtpValid) {
                          return 'OTP is incorrect';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _isSendingOtp ? null : _sendOtp,
                    child: _isSendingOtp
                        ? Text('Resend (${_secondsRemaining}s)')
                        : const Text('Send OTP'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              //Error message
              if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
              const SizedBox(height: 24),
              // Đăng ký button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _confirmpassword()
                      ? () => Get.to(() => const SigninScreen())
                      : null,
                  child: const Text('Forget your password'),
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}
