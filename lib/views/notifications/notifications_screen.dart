import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
      child: Center(
        child: Text('NotificationsScreen'),
      ),
    );
  }
}
