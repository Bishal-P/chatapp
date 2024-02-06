import 'package:chatapp/models/messageModel.dart';
import 'package:flutter/material.dart';

class textMessage extends StatefulWidget {
  final Message2 message;
  final bool onlyEmoji;
  const textMessage({super.key, required this.message, required this.onlyEmoji});

  @override
  State<textMessage> createState() => _textMessageState();
}

class _textMessageState extends State<textMessage> {
  @override
  Widget build(BuildContext context) {
    return Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.73,
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                decoration: BoxDecoration(
                  color: widget.onlyEmoji
                      ? Colors.transparent
                      :const Color.fromARGB(255, 44, 110, 253),
                  borderRadius:const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(0),
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
                child: TextSelectionTheme(
                  data: const TextSelectionThemeData(
                    // cursorColor: Colors.blue,
                    selectionColor: Color.fromARGB(255, 73, 73, 73),
                    selectionHandleColor: Colors.blue,
                  ),
                  child: SelectableText.rich(
                    TextSpan(
                      onExit: (event) => null,
                      text:widget.message.msg,
                      style: TextStyle(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        fontSize: widget.onlyEmoji ? 29 : 16,
                      ),
                    ),
                  ),
                ),
              );
  }
}