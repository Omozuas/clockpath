import 'package:flutter/material.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
      child: Center(
        child: Text('RequestsScreen'),
      ),
    );
  }
}
