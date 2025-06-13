import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_application_1/controllers/theme_controller.dart';
import 'package:flutter_application_1/view/MainScreen/all_products_screen.dart';
import 'package:flutter_application_1/view/widgets/category_chips.dart';
import 'package:flutter_application_1/view/widgets/custom_search_bar.dart';
import 'package:flutter_application_1/view/widgets/product_grid.dart';
import 'package:flutter_application_1/view/widgets/sale_banner.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
            child: Column(
                children: [
                    //heading section
                    Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                            children: [
                                CircleAvatar(
                                    radius: 20,
                                    backgroundImage: AssetImage('assets/images/avatar.jpg'),
                                ),

                                SizedBox(width: 12),
                                Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                        Text(
                                            'Hello Kiet',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 14,
                                            ),
                                        ),
                                        Text(
                                            'Good Moring',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                            ),
                                        ),
                                    ],
                                ),
                                const Spacer(),
                                //notification icon
                                IconButton(
                                    onPressed: (){},
                                    icon: Icon(Icons.notifications_active_outlined),
                                ),

                                //cart button
                                IconButton(
                                    onPressed: (){},
                                    icon: Icon(Icons.shopping_bag_outlined),
                                ),

                                //Theme button
                                GetBuilder<ThemeController>(
                                    builder: (controller) => IconButton(
                                        onPressed: () => controller.toggleTheme(),
                                        icon: Icon(
                                            controller.isDarkMode ? Icons.light_mode :
                                            Icons.dark_mode,
                                        ),
                                    )
                                ),
                            ],
                        ),
                    ),

                    //Search bar
                    const CustomSearchBar(),

                    //category chips
                    const CategoryChips(),

                    //sale banner
                    const SaleBanner(),

                    //popular products
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Popular Products',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Get.to(() => const AllProductsScreen()),
                            child: Text(
                              'See All',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          )
                        ],
                      ),
                    ),
                    //products grid
                    const Expanded(child: ProductGrid()),
                ],
            )
        ),
    );
  }
}
