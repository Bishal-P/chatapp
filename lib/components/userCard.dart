import 'package:flutter/material.dart';

class chartUsercard extends StatefulWidget {
  var name;
  var about;
  chartUsercard({super.key, this.name, this.about});

  @override
  State<chartUsercard> createState() => _chartUsercardState();
}

class _chartUsercardState extends State<chartUsercard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      child: InkWell(
        onTap: () {},
        child: ListTile(
          leading: CircleAvatar(
            child: Icon(Icons.person),
          ),
          title: Text(widget.name),
          subtitle: Text(widget.about),
          trailing: const Icon(Icons.message),
        ),
      ),
    );
  }
}
