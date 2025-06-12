import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/auth_controller.dart';
import 'package:flutter_application_1/utils/app_textstyles.dart';
import 'package:flutter_application_1/view/Auth/signin_screen.dart';
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
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String? _errorMessage;
  bool _isSendingOtp = false;
  int _secondsRemaining = 0;
  Timer? _timer;
  bool _isOtpValid = false;

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _sendOtp() async {
    if (_emailController.text.isEmpty || !GetUtils.isEmail(_emailController.text)) {
      setState(() {
        _errorMessage = 'Please enter a valid email before requesting OTP.';
      });
      return;
    }

    setState(() {
      _isSendingOtp = true;
      _errorMessage = null;
    });

    final authController = Get.find<AuthController>();
    final result = await authController.sendOtpApi(_emailController.text);

    if (result['success']) {
      setState(() {
        _secondsRemaining = 120; // Đồng bộ với backend (2 phút)
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'])),
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
    } else {
      setState(() {
        _isSendingOtp = false;
        _errorMessage = result['message'];
      });
    }
  }

  void _validateOtp(String value) async {
    if (value.isEmpty) {
      setState(() {
        _isOtpValid = false;
      });
      return;
    }

    final authController = Get.find<AuthController>();
    final result = await authController.confirmOtpApi(_emailController.text, value);

    setState(() {
      _isOtpValid = result['success'];
      if (!result['success']) {
        _errorMessage = result['message'];
      } else {
        _errorMessage = null;
      }
    });
  }

  void _resetPassword() async {
    if (_newPasswordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = 'Passwords do not match';
      });
      return;
    }

    if (_newPasswordController.text.length < 6) {
      setState(() {
        _errorMessage = 'New password must be at least 6 characters';
      });
      return;
    }

    setState(() {
      _isSendingOtp = true;
      _errorMessage = null;
    });

    final authController = Get.find<AuthController>();
    final result = await authController.resetPasswordApi(
      _emailController.text,
      _otpController.text,
      _newPasswordController.text,
    );

    setState(() {
      _isSendingOtp = false;
    });

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'])),
      );
      Get.off(() => const SigninScreen());
    } else {
      setState(() {
        _errorMessage = result['message'];
      });
    }
  }

  bool _canResetPassword() {
    return _emailController.text.isNotEmpty &&
        _otpController.text.isNotEmpty &&
        _newPasswordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        _isOtpValid &&
        _newPasswordController.text == _confirmPasswordController.text;
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
              if (_isOtpValid) ...[
                CustomTextfield(
                  label: 'New Password',
                  prefixIcon: Icons.lock_outline,
                  keyboardType: TextInputType.visiblePassword,
                  controller: _newPasswordController,
                  isPassWord: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a new password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextfield(
                  label: 'Confirm Password',
                  prefixIcon: Icons.lock_outline,
                  keyboardType: TextInputType.visiblePassword,
                  controller: _confirmPasswordController,
                  isPassWord: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _newPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
              ],
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
                  onPressed: _canResetPassword() ? _resetPassword : null,
                  child: const Text('Reset Password'),
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}
