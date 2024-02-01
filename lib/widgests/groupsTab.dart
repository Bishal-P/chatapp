import 'package:flutter/material.dart';

class groupTab extends StatefulWidget {
  const groupTab({super.key});

  @override
  State<groupTab> createState() => _groupTabState();
}

class _groupTabState extends State<groupTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("Groups"),
      ),
    );
  }
}