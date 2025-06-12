import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/utils/app_textstyles.dart';

class CategoryChips extends StatefulWidget {
  const CategoryChips({super.key});

  @override
  State<CategoryChips> createState() => _CategoryChipsState();
}

class _CategoryChipsState extends State<CategoryChips> {
    int selectedIndex = 0;
    final categories = [
    'All',
    'Men',
    'Women',
    'Girls'
    ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(16),
        child: Row(
            children: List.generate(
                categories.length,
                (index) => Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child: ChoiceChip(
                            label: Text(
                                categories[index],
                                    style: AppTextstyles.withColor(
                                    selectedIndex == index
                                        ? AppTextstyles.withWeight(
                                            AppTextstyles.bodySmall,
                                            FontWeight.w600,
                                        ) : AppTextstyles.bodySmall,
                                    selectedIndex == index ? Colors.white : isDark ? Colors.grey[400]! : Colors.grey[600]!,
                                ),
                            ),
                            selected: selectedIndex == index,
                            onSelected: (bool selected){
                                setState(() {
                                    selectedIndex = selected ? index : selectedIndex;
                                });
                            },
                            selectedColor: Theme.of(context).colorScheme.primary,
                            backgroundColor: isDark ? Colors.grey[800] : Colors.grey[100],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: selectedIndex == index ? 2 : 0,
                            pressElevation: 0,
                            padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8
                            ),
                            labelPadding: EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 8
                            ),
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            side: BorderSide(
                                color: selectedIndex == index ?
                                Colors.transparent :
                                isDark ? Colors.grey[700]! : Colors.grey[300]!,
                                width: 1,
                            ),
                        ),
                    ),
                ),
            ),
        ),
    );
  }
}
