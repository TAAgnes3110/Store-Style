import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/utils/app_textstyles.dart';

class SaleBanner extends StatelessWidget {
  const SaleBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Get Your',
                  style: AppTextstyles.withColor(
                    AppTextstyles.h3,
                    Colors.white,
                  ),
                ),
                Text(
                  'Special Sale',
                  style: AppTextstyles.withColor(
                    AppTextstyles.withWeight(
                      AppTextstyles.h3,
                      FontWeight.bold,
                      ),
                    Colors.white,
                  ),
                ),
                Text(
                  'Up to 40% off',
                  style: AppTextstyles.withColor(
                    AppTextstyles.h3,
                    Colors.white,
                  ),
                ),
              ],
            )
          ),
          ElevatedButton(
            onPressed: (){

            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Theme.of(context).colorScheme.primary,
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12
              ),
            ),
            child: Text(
              'Shop Now',
              style: AppTextstyles.withWeight(
                AppTextstyles.bodyMedium,
                FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
