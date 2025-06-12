import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

import 'home_screen.dart';
import 'ai_screen.dart';
import 'favorite_screen.dart';
import 'notification_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      tabs: [
        PersistentTabConfig(
          screen: HomeScreen(),
          item: ItemConfig(
            icon: Icon(Icons.home),
            title: "Trang chủ",
            activeForegroundColor: Colors.blue,
            inactiveForegroundColor: Colors.grey,
          ),
        ),
        PersistentTabConfig(
          screen: AiScreen(),
          item: ItemConfig(
            icon: Icon(Icons.android),
            title: "AI",
            activeForegroundColor: Colors.blue,
            inactiveForegroundColor: Colors.grey,
          ),
        ),
        PersistentTabConfig(
          screen: FavoriteScreen(),
          item: ItemConfig(
            icon: Icon(Icons.favorite),
            title: "Yêu thích",
            activeForegroundColor: Colors.blue,
            inactiveForegroundColor: Colors.grey,
          ),
        ),
        PersistentTabConfig(
          screen: NotificationScreen(),
          item: ItemConfig(
            icon: Icon(Icons.notifications),
            title: "Thông báo",
            activeForegroundColor: Colors.blue,
            inactiveForegroundColor: Colors.grey,
          ),
        ),
        PersistentTabConfig(
          screen: ProfileScreen(),
          item: ItemConfig(
            icon: Icon(Icons.person),
            title: "Thông tin",
            activeForegroundColor: Colors.blue,
            inactiveForegroundColor: Colors.grey,
          ),
        ),
      ],
      navBarBuilder: (navBarConfig) => Style2BottomNavBar(
        navBarConfig: navBarConfig,
      ),
    );
  }
}
