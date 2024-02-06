import 'package:flutter/material.dart';

class uploadingFileWidget extends StatefulWidget {
  String msg = "0";
   uploadingFileWidget({super.key, required this.msg});

  @override
  State<uploadingFileWidget> createState() => _uploadingFileWidgetState();
}

class _uploadingFileWidgetState extends State<uploadingFileWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 70,
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 44, 110, 253),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 10, top: 5),
            child: Text(
              "Sending File...",
              style: TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const Center(
            child: LinearProgressIndicator(
              color: Colors.lightBlueAccent,
            ),
          ),
          Expanded(
              child: Center(
                  child: Text(
            "uploading...${widget.msg} %",
            style: const TextStyle(
                color: Colors.white54,
                fontSize: 12,
                fontWeight: FontWeight.bold),
          )))
        ],
      ),
    );
  }
}
