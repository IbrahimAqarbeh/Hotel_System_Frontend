// circular_progress_widget.dart
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CircularProgressWidget extends StatelessWidget {
  final int upperNumber;
  final String lowerNumber;
  final double percentage;
  final Color progressColor;
  final String text;

  CircularProgressWidget({
    required this.upperNumber,
    required this.lowerNumber,
    required this.percentage,
    required this.progressColor,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: 65.0, 
      lineWidth: 10.0,
      percent: percentage,
      center: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$text',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            '$upperNumber',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            '$lowerNumber',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
          ),
        ],
      ),
      progressColor: progressColor,
      backgroundColor: Colors.white,
      circularStrokeCap: CircularStrokeCap.round,
    );
  }
}
