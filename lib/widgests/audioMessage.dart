import 'package:chatapp/models/messageModel.dart';
import 'package:flutter/material.dart';

class audioMessage extends StatefulWidget {
  final Message2? message;
  const audioMessage({super.key, this.message});

  @override
  State<audioMessage> createState() => _audioMessageState();
}

class _audioMessageState extends State<audioMessage> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 200,
          height: 60,
          decoration: BoxDecoration(
            color: Color.fromARGB(186, 136, 131, 131),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: () => print("Playing audio"),
                icon: Icon(Icons.play_arrow),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.32,
                child: LinearProgressIndicator(
                  value: 0.4,
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Color.fromARGB(255, 135, 219, 56)),
                  backgroundColor: Color.fromARGB(255, 230, 226, 226),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
