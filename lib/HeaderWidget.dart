import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class HeaderWidget extends StatefulWidget {
  final String hotelName;
  final DateTime businessDate;

  HeaderWidget({required this.hotelName, required this.businessDate});

  @override
  _HeaderWidgetState createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  late Timer _timer;
  String _currentDateTime = '';

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) => _updateTime());
  }

  void _updateTime() {
    final formatter = DateFormat('yMMMd').add_jm();
    final toShowDateTime = new DateTime(widget.businessDate.year,widget.businessDate.month,widget.businessDate.day,DateTime.now().hour,DateTime.now().minute);
    setState(() {
      _currentDateTime = formatter.format(toShowDateTime);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hotel: ${widget.hotelName}',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          Text(
            _currentDateTime,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
