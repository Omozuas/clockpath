import 'package:flutter/material.dart';

class ClockHistoryScreen extends StatefulWidget {
  const ClockHistoryScreen({super.key});

  @override
  State<ClockHistoryScreen> createState() => _ClockHistoryScreenState();
}

class _ClockHistoryScreenState extends State<ClockHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
      child: Center(
        child: Text('ClockHistoryScreen'),
      ),
    );
  }
}
