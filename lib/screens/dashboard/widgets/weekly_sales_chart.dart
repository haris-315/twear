import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t_wear/core/theme/cubit/theme_cubit.dart';
import 'package:t_wear/core/theme/theme.dart';
import 'package:t_wear/core/utils/get_theme_state.dart';

class WeeklySalesChart extends StatefulWidget {
  const WeeklySalesChart({super.key});

  @override
  State<WeeklySalesChart> createState() => _WeeklySalesChartState();
}

class _WeeklySalesChartState extends State<WeeklySalesChart> {
  final List<double> weeklySales = [15, 7, 20, 14];
  late ThemeChangeEvent chartEvent;
  late ThemeCubit themeCubit;
  bool showChart = true;
  void setUpCharts(CTheme themeMode) async {
    setState(() {
      showChart = false;
    });
    await Future.delayed(const Duration(milliseconds: 1500));
    setState(() {
      showChart = true;
    });
  }

  @override
  void initState() {
    super.initState();
    chartEvent = ThemeChangeEvent(onChange: setUpCharts);
    themeCubit = context.read<ThemeCubit>();
    themeCubit.registerEvent(chartEvent);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    themeCubit.flushEvent(chartEvent);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final CTheme themeMode = getThemeMode(context);
    return Center(
      child: !showChart
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: themeMode.borderColor2,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Loading Charts...",
                  style: TextStyle(
                      color: themeMode.primTextColor,
                      fontSize: 30,
                      fontFamily: "jman"),
                )
              ],
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 950),
                  curve: Curves.easeIn,
                  color: themeMode.backgroundColor,
                  child: LineChart(LineChartData(
                    backgroundColor: Colors.transparent,
                    maxY: 25,
                    minY: 0,
                    minX: 1,
                    maxX: 4,
                    lineBarsData: [
                      LineChartBarData(
                        spots: List.generate(weeklySales.length, (index) {
                          return FlSpot(index + 1, weeklySales[index]);
                        }),
                        isCurved: true,
                        color: themeMode.borderColor2,
                        barWidth: 4,
                        belowBarData: BarAreaData(
                          show: true,
                          color: themeMode.oppositeShimmerColor
                              ?.withValues(alpha: .3),
                        ),
                      ),
                    ],
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            switch (value.toInt()) {
                              case 1:
                                return Text(
                                  'Week 1',
                                  style: TextStyle(
                                    color: themeMode.primTextColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                );
                              case 2:
                                return Text(
                                  'Week 2',
                                  style: TextStyle(
                                    color: themeMode.primTextColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                );
                              case 3:
                                return Text(
                                  'Week 3',
                                  style: TextStyle(
                                    color: themeMode.primTextColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                );
                              case 4:
                                return Text(
                                  'Week 4',
                                  style: TextStyle(
                                    color: themeMode.primTextColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                );
                              default:
                                return const SizedBox.shrink();
                            }
                          },
                        ),
                      ),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                value.toInt().toString(),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: themeMode.primTextColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border(
                        left: BorderSide(
                            color: themeMode.borderColor ?? Colors.grey),
                        bottom: BorderSide(
                            color: themeMode.borderColor ?? Colors.grey),
                      ),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: true,
                      horizontalInterval: 5,
                      verticalInterval: 1,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: themeMode.gridLineColor,
                          strokeWidth: 0.8,
                          dashArray: [4, 4],
                        );
                      },
                      getDrawingVerticalLine: (value) {
                        return FlLine(
                          color: themeMode.gridLineColor,
                          strokeWidth: 0.8,
                          dashArray: [4, 4],
                        );
                      },
                    ),
                  )),
                ),
              ),
            ),
    );
  }
}
