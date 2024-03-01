import 'package:flutter/material.dart';

class SettScreen extends StatefulWidget {
  const SettScreen({super.key});

  @override
  State<SettScreen> createState() => _SettScreenState();
}

class _SettScreenState extends State<SettScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("SettScreen"),
    );
  }
}
