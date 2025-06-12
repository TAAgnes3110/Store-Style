import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/auth_controller.dart';
import 'package:flutter_application_1/utils/app_textstyles.dart';
import 'package:flutter_application_1/view/Auth/signin_screen.dart';
import 'package:flutter_application_1/view/widgets/custom_textfield.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  String? _errorMessage;
  bool _isSendingOtp = false;
  int _secondsRemaining = 0;
  Timer? _timer;
  bool _isOtpValid = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmpasswordController.dispose();
    _dobController.dispose();
    _otpController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  bool _confirmpassword() {
    return _passwordController.text == _confirmpasswordController.text;
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
      _secondsRemaining = 120;
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

  void _signUp() async {
    if (!_canSignUp()) {
      setState(() {
        _errorMessage = 'Please fill all fields and verify OTP';
      });
      return;
    }

    setState(() {
      _isSendingOtp = true;
      _errorMessage = null;
    });

    final authController = Get.find<AuthController>();
    final result = await authController.signupApi(
      _usernameController.text,
      _emailController.text,
      _passwordController.text,
      _dobController.text,
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

  bool _canSignUp() {
    return _usernameController.text.isNotEmpty &&
        _dobController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _confirmpasswordController.text.isNotEmpty &&
        _otpController.text.isNotEmpty &&
        _confirmpassword() &&
        _isOtpValid;
  }

  @override
  Widget build(BuildContext context) {
    // final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(
                'Create Account',
                style: AppTextstyles.withColor(
                  AppTextstyles.h1,
                  Theme.of(context).textTheme.bodyLarge!.color!,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Welcom Sign Up',
                style: AppTextstyles.withColor(
                  AppTextstyles.h2,
                  Theme.of(context).textTheme.bodyMedium!.color!,
                ),
              ),
              const SizedBox(height: 40),
              // Full name input text
              CustomTextfield(
                label: 'Full Name',
                prefixIcon: Icons.person_outline,
                keyboardType: TextInputType.name,
                controller: _usernameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Date of Birth
              GestureDetector(
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2000, 1, 1),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setState(() {
                      _dobController.text = DateFormat('dd/MM/yyyy').format(picked);
                    });
                  }
                },
                child: AbsorbPointer(
                  child: CustomTextfield(
                    label: 'Date of Birth',
                    prefixIcon: Icons.cake,
                    controller: _dobController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select your date of birth';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Email
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
                    onPressed: (_isSendingOtp || _secondsRemaining > 0) ? null : _sendOtp,
                    child: (_secondsRemaining > 0)
                        ? Text('Resend (${_secondsRemaining}s)')
                        : const Text('Send OTP'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Password Input
              CustomTextfield(
                label: 'Password',
                prefixIcon: Icons.lock_outline,
                keyboardType: TextInputType.visiblePassword,
                controller: _passwordController,
                isPassWord: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Confirm Password
              CustomTextfield(
                label: 'Confirm Password',
                prefixIcon: Icons.lock_outline,
                keyboardType: TextInputType.visiblePassword,
                controller: _confirmpasswordController,
                isPassWord: true,
                validator: (value) {
                  if (!_confirmpassword()) {
                    return 'The passwords you entered do not match.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
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
                  onPressed: _canSignUp() ? _signUp : null,
                  child: const Text('Sign Up'),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
