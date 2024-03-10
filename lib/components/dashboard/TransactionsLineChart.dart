import 'dart:math';

import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lunchmoney/lunchmoney.dart';

class TransactionsLineChart extends StatelessWidget {
  final List<Transaction> transactions;

  const TransactionsLineChart({super.key, required this.transactions});

  double get dateInterval =>
      (transactions.last.date.millisecondsSinceEpoch.toDouble() / 1000 / 60) -
      (transactions.first.date.millisecondsSinceEpoch.toDouble() / 1000 / 60);

  List<FlSpot> get spots {
    Map<double, double> spotsByDay = {};
    for (var transaction in transactions) {
      final thisDay = transaction.date.millisecondsSinceEpoch.toDouble() / 1000 / 60;
      spotsByDay[thisDay] = (spotsByDay[thisDay] ?? 0) + transaction.amount;
    }

    return spotsByDay.entries.map((e) => FlSpot(e.key, e.value)).toList();
  }

  double get maxY => max(transactions.sorted((a, b) => a.amount.compareTo(b.amount)).last.amount,
          transactions.sorted((a, b) => a.amount.compareTo(b.amount)).first.amount)
      .abs();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.7,
      child: Card(
        color: Theme.of(context).colorScheme.secondaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: transactions.isEmpty
              ? Center(
                  child: Text(
                    "No transactions in this period",
                    style: TextStyle(
                      color: Theme.of(context).disabledColor,
                    ),
                  ),
                )
              : LineChart(
                  LineChartData(
                    maxY: maxY,
                    minY: -maxY,
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        isCurved: true,
                        curveSmoothness: 0.2,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        color: Theme.of(context).colorScheme.onSurface,
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                              Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ],
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: true,
                      horizontalInterval: 1,
                      verticalInterval: 1,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Theme.of(context).primaryColor,
                          strokeWidth: 1,
                        );
                      },
                      getDrawingVerticalLine: (value) {
                        return FlLine(
                          color: Theme.of(context).primaryColor,
                          strokeWidth: 1,
                        );
                      },
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          interval: pow(10, maxY.abs().toInt().toString().length - 1).toDouble(),
                          showTitles: true,
                          reservedSize: 48,
                          getTitlesWidget: (val, meta) {
                            return Text(
                              NumberFormat.compactSimpleCurrency(decimalDigits: 0).format(
                                (val / pow(10, val.abs().toInt().toString().length - 1)).round() *
                                    pow(10, val.abs().toInt().toString().length - 1),
                              ),
                              style: TextStyle(
                                color: val == 0
                                    ? null
                                    : val < 0
                                        ? Colors.redAccent
                                        : Colors.green,
                              ),
                            );
                          },
                        ),
                      ),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(sideTitles: SideTitles(interval: dateInterval)),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
