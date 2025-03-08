import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:t_wear/core/theme/cubit/theme_cubit.dart';
import 'package:t_wear/core/theme/theme.dart';
import 'package:t_wear/core/utils/get_theme_state.dart';
import 'package:t_wear/core/utils/screen_size.dart';

class TrendingPicksShimmer extends StatelessWidget {
  const TrendingPicksShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final [swidth, sheight] = getScreenSize(context);
    final bool isLargeScreen = swidth > 800;
    final CTheme themeMode = getThemeMode(context);
    final isDarkMode = themeMode.getThemeType() is Dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Shimmer.fromColors(
            baseColor: !isDarkMode ? Colors.grey[300]! : Colors.grey[800]!,
            highlightColor: !isDarkMode ? Colors.grey[300]! : Colors.grey[600]!,
            child: Container(
              width: 200,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (isLargeScreen)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SizedBox(
              height: 320,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Shimmer.fromColors(
                      baseColor:
                          !isDarkMode ? Colors.grey[300]! : Colors.grey[800]!,
                      highlightColor:
                          !isDarkMode ? Colors.grey[300]! : Colors.grey[600]!,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Expanded(
                          child: Shimmer.fromColors(
                            baseColor: !isDarkMode
                                ? Colors.grey[300]!
                                : Colors.grey[800]!,
                            highlightColor: !isDarkMode
                                ? Colors.grey[100]!
                                : Colors.grey[600]!,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Shimmer.fromColors(
                            baseColor: !isDarkMode
                                ? Colors.grey[300]!
                                : Colors.grey[800]!,
                            highlightColor: !isDarkMode
                                ? Colors.grey[100]!
                                : Colors.grey[600]!,
                            child: Container(
                              margin: const EdgeInsets.only(top: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          SizedBox(
            height: 270,
            child: Shimmer.fromColors(
              baseColor: !isDarkMode ? Colors.grey[300]! : Colors.grey[800]!,
              highlightColor:
                  !isDarkMode ? Colors.grey[100]! : Colors.grey[600]!,
              child: Center(
                child: Container(
                      width: swidth * 0.8,
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                      ),
                
                    ),
              )
            ),
          ),
        const SizedBox(height: 16),
        Center(
          child: Shimmer.fromColors(
            baseColor: !isDarkMode ? Colors.grey[300]! : Colors.grey[800]!,
            highlightColor: !isDarkMode ? Colors.grey[100]! : Colors.grey[600]!,
            child: Container(
              width: 120,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
