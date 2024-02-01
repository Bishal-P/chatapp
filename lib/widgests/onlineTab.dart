import 'package:flutter/material.dart';

class onlineTab extends StatefulWidget {
  const onlineTab({super.key});

  @override
  State<onlineTab> createState() => _onlineTabState();
}

class _onlineTabState extends State<onlineTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("Online"),
      ),
    );
  }
}
