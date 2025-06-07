import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/app_textstyles.dart';
import 'package:flutter_application_1/view/signin_screen.dart';
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

  String? _sentOtp;
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email before requesting OTP.')),
      );
      return;
    }
    setState(() {
      _isSendingOtp = true;
      _secondsRemaining = 120;
      _sentOtp = (100000 + (DateTime.now().millisecondsSinceEpoch % 900000)).toString(); // giả lập OTP
      _isOtpValid = false;
    });
    // TODO: Gửi OTP thực tế qua API ở đây, ví dụ: await sendOtpToEmail(_emailController.text, _sentOtp);

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
                    onPressed: _isSendingOtp ? null : _sendOtp,
                    child: _isSendingOtp
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
              const SizedBox(height: 24),
              // Đăng ký button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _canSignUp()
                      ? () {
                          // Xử lý đăng ký ở đây
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Sign up successful!')),
                          );
                          Get.to(() => const SigninScreen());
                        }
                      : null,
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
