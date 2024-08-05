import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartWidget extends StatelessWidget {
  final double boGuests;
  final double bbGuests;
  final double hbGuests;
  final double fbGuests;
  final String boField1;
  final String boField2;
  final String boField3;
  final String bbField1;
  final String bbField2;
  final String bbField3;
  final String hbField1;
  final String hbField2;
  final String hbField3;
  final String fbField1;
  final String fbField2;
  final String fbField3;
  final int totalGuests;

  const PieChartWidget({
    Key? key,
    required this.boGuests,
    required this.bbGuests,
    required this.hbGuests,
    required this.fbGuests,
    required this.boField1,
    required this.boField2,
    required this.boField3,
    required this.bbField1,
    required this.bbField2,
    required this.bbField3,
    required this.hbField1,
    required this.hbField2,
    required this.hbField3,
    required this.fbField1,
    required this.fbField2,
    required this.fbField3,
    required this.totalGuests,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Stack(
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 60,
              sections: showingSections(),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Total Guests',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '$totalGuests',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(4, (i) {
      final fontSize = 12.0;
      final radius = 80.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.red,
            value: boGuests,
            title: 'BO\n$boField1\n$boField2\n$boField3',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.blue,
            value: bbGuests,
            title: 'BB\n$bbField1\n$bbField2\n$bbField3',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: Colors.green,
            value: hbGuests,
            title: 'HB\n$hbField1\n$hbField2\n$hbField3',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        case 3:
          return PieChartSectionData(
            color: Colors.orange,
            value: fbGuests,
            title: 'FB\n$fbField1\n$fbField2\n$fbField3',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        default:
          throw Error();
      }
    });
  }
}
