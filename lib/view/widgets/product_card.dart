import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/models/product.dart';
import 'package:flutter_application_1/utils/app_textstyles.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      constraints: BoxConstraints(
        maxWidth: screenWidth * 0.45,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black54 : Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 16/9,
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.asset(
                    product.imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                ),
              ),


              //favorite button
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: Icon(
                    product.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: product.isFavorite ?
                    Theme.of(context).colorScheme.secondary:
                    isDark ? Colors.white : Colors.black,
                  ),
                  onPressed: () {
                    // Handle favorite toggle
                  },
                ),
              ),
              if (product.oldPrice != null)
                Positioned(
                  left: 8,
                  top: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(4),
                    ),


                    //discount text
                    child: Text(
                      '${calculateDiscount(product.price, product.oldPrice)}% OFF',
                      style: AppTextstyles.withColor(
                        AppTextstyles.withWeight(
                          AppTextstyles.buttonSmall,
                          FontWeight.bold,
                        ),
                        Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),


          // Product details
          Padding(
            padding: EdgeInsets.all(screenWidth * 0.02),
            child: Column(
              children: [
                Text(
                  product.name,
                  style: AppTextstyles.withColor(
                    AppTextstyles.withWeight(
                      AppTextstyles.h3,
                      FontWeight.w600,
                    ),
                    Theme.of(context).textTheme.bodyLarge!.color!,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: screenWidth * 0.01),
                Text(
                  product.category,
                  style: AppTextstyles.withColor(
                    AppTextstyles.bodyMedium,
                    isDark ? Colors.grey[400]! : Colors.grey[600]!,
                  ),
                ),
                SizedBox(height: screenWidth * 0.01),
                Row(
                  children: [
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: AppTextstyles.withColor(
                        AppTextstyles.withWeight(
                          AppTextstyles.h3,
                          FontWeight.bold,
                        ),
                        Theme.of(context).textTheme.bodyLarge!.color!,
                      ),
                    ),
                    if (product.oldPrice != null)
                      Padding(
                        padding: EdgeInsets.only(left: screenWidth * 0.02),
                        child: Text(
                          '\$${product.oldPrice!.toStringAsFixed(2)}',
                          style: AppTextstyles.withColor(
                            AppTextstyles.bodyMedium.copyWith(
                              decoration: TextDecoration.lineThrough,
                            ),
                            isDark ? Colors.grey[400]! : Colors.grey[600]!,
                          ),
                        ),
                      ),
                  ],
                )
              ],
            )
          )
        ],
      ),
    );
  }

  //calculate discount percentage
  int calculateDiscount(double currentPrice, double? oldPrice) {
    return oldPrice != null
        ? ((oldPrice - currentPrice) / oldPrice * 100).round()
        : 0;
  }
}
