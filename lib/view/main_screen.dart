import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/Navigation_controller.dart';
import 'package:flutter_application_1/controllers/theme_controller.dart';
import 'package:flutter_application_1/view/home_screen.dart'; // Thêm dòng này nếu có HomeScreen
import 'package:get/get.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigationController navigationController = Get.put(NavigationController());
    return GetBuilder<ThemeController>(
      builder: (themeController) => Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Obx(
            () => IndexedStack(
              key: ValueKey(navigationController.currentIndex.value),
              index: navigationController.currentIndex.value,
              children: const [
                HomeScreen(),
                // Thêm các màn hình khác nếu có
              ],
            ),
          ),
        ),
      ),
    );
  }
}
