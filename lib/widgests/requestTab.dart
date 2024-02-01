import 'package:flutter/material.dart';

class requestTab extends StatefulWidget {
  const requestTab({super.key});

  @override
  State<requestTab> createState() => _requestTabState();
}

class _requestTabState extends State<requestTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("Requests"),
      ),
    );
  }
}
