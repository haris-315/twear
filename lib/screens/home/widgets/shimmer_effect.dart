import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:t_wear/core/theme/cubit/theme_cubit.dart';
import 'package:t_wear/core/theme/theme.dart';
import 'package:t_wear/core/utils/get_theme_state.dart';
import 'package:t_wear/core/utils/screen_size.dart';

class ShimmerLoadingEffect extends StatelessWidget {
  final bool isCategory;
  const ShimmerLoadingEffect({super.key, this.isCategory = false});

  @override
  Widget build(BuildContext context) {
    final themeMode = getThemeMode(context);
    final width = getScreenSize(context).first;
    final isLightMode = themeMode.getThemeType() is Light;

    return Shimmer.fromColors(
      baseColor: isLightMode ? Colors.grey[300]! : Colors.grey[800]!, 
      highlightColor: isLightMode ? Colors.grey[100]! : Colors.grey[600]!, 
      child: isCategory
          ? _buildCategoryShimmer(width, themeMode)
          : _buildProductShimmer(width, themeMode),
    );
  }

  Widget _buildCategoryShimmer(double width, CTheme themeMode) {
    final isLightMode = themeMode.getThemeType() is Light;
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
    color: isLightMode ? Colors.black.withValues(alpha: 0.06) : Colors.grey[250], 
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
        color: isLightMode ? Colors.grey[400]! : Colors.grey[600]!),
          ),
      width: width <= 500 ? 80 : 150,
      height: width <= 500 ? 50 : 160,
      child: Column(children: [
        CircleAvatar(
        backgroundColor: isLightMode ? Colors.grey[300] : Colors.grey[700], 
        radius: 58,
    
    ),
    SizedBox(height: 8,),
    Container(
          height: 14,
            width: width < 600 ? 100 : 150,
            color: isLightMode ? Colors.grey[300] : Colors.black, 
        )
      ],),
    );
  }

  Widget _buildProductShimmer(double width, CTheme themeMode) {
    final isLightMode = themeMode.getThemeType() is Light;
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: isLightMode ? Colors.black.withValues(alpha: 0.06) : Colors.grey[250], 
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: isLightMode ? Colors.grey[400]! : Colors.grey[600]!),
      ),
      width: width < 600 ? 150 : 200,
      height: 270,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              color: isLightMode ? Colors.grey[300] : Colors.black, 
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 16,
            width: width < 600 ? 100 : 150,
            color: isLightMode ? Colors.grey[300] : Colors.black, 
          ),
          const SizedBox(height: 4),
          Container(
            height: 16,
            width: width < 600 ? 80 : 100,
            color: isLightMode ? Colors.grey[300] : Colors.black, 
          ),
          const Spacer(),
          Container(
            height: 16,
            width: 50,
            color: isLightMode ? Colors.grey[300] : Colors.black, 
          ),
        ],
      ),
    );
  }
}