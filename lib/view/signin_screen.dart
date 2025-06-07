import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/auth_controller.dart';
import 'package:flutter_application_1/utils/app_textstyles.dart';
import 'package:flutter_application_1/view/forget_password_screen.dart';
import 'package:flutter_application_1/view/main_screen.dart';
import 'package:flutter_application_1/view/signup_screen.dart';
import 'package:flutter_application_1/view/widgets/custom_textfield.dart';
import 'package:get/get.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Text(
                  'Welcome Back!',
                  style: AppTextstyles.withColor(
                    AppTextstyles.h1,
                    Theme.of(context).textTheme.bodyLarge!.color!,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign in to continue',
                  style: AppTextstyles.withColor(
                    AppTextstyles.h2,
                    Theme.of(context).textTheme.bodyLarge!.color!,
                  ),
                ),
                const SizedBox(height: 40),
                // Email Input
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
                // Forget Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Get.to(() => const ForgetPasswordScreen()),
                    child: Text(
                      'Forget Password',
                      style: AppTextstyles.withColor(
                        AppTextstyles.buttonMedium,
                        Theme.of(context).textTheme.bodyLarge!.color!,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Error message
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                // Sign In Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleSignIn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : Text(
                            'Sign In',
                            style: AppTextstyles.withColor(
                              AppTextstyles.buttonMedium,
                              isDark ? Colors.white : Colors.black,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                // Sign up textButton
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: AppTextstyles.withColor(
                        AppTextstyles.bodyMedium,
                        isDark ? Colors.grey[400]! : Colors.grey[600]!,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Get.to(() => const SignupScreen()),
                      child: Text(
                        'Sign up',
                        style: AppTextstyles.withColor(
                          AppTextstyles.bodyMedium,
                          Theme.of(context).textTheme.bodyLarge!.color!,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSignIn() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final AuthController authController = Get.find<AuthController>();
      // Gọi hàm login thực tế, ví dụ:
      // bool result = await authController.loginApi(_emailController.text, _passwordController.text);
      // if (result) {
      //   Get.off(() => const MainScreen());
      // } else {
      //   setState(() => _errorMessage = "Login failed. Please check your credentials.");
      // }
      // Demo: luôn thành công
      await Future.delayed(const Duration(seconds: 1));
      Get.off(() => const MainScreen());
    } catch (e) {
      setState(() {
        _errorMessage = "An error occurred: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
