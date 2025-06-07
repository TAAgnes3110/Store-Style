import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/theme_controller.dart';
import 'package:flutter_application_1/utils/app_themes.dart';
import 'package:flutter_application_1/view/splash_screen.dart';
import 'package:flutter_application_1/controllers/auth_controller.dart';
import 'package:get/get.dart';

import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();
  Get.put(ThemeController());
  Get.put(AuthController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    return GetMaterialApp(
      title: 'Fashion Store',
      theme: AppThemes.light,
      darkTheme: AppThemes.dark,
      themeMode: themeController.theme,
      defaultTransition: Transition.fade,
      home: SplashScreens(),
    );
  }
}
