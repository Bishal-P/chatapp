import 'dart:ui';

import 'package:flutter/material.dart';
// import 'package:flutter_photo_view_demo/themes/device_size.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class image_viewer extends StatefulWidget {
  final List<String> imageList;
  final int index;
  image_viewer({super.key, required this.imageList, required this.index});
  @override
  _image_viewerState createState() => _image_viewerState();
}

class _image_viewerState extends State<image_viewer> {
  PageController _controller = PageController();
  // final imageList = [];

  @override
  Widget build(BuildContext context) {
    _controller = PageController(initialPage: widget.index);
    print("Entered the image viewer");
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      // !?
      // add this body tag with container and photoview widget
      body: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: SizedBox(
          // height: MediaQuery.of(context).size.height,
          // margin: EdgeInsets.only(left: 15, right: 15),
          width: MediaQuery.of(context).size.width,
          child: PhotoViewGallery.builder(
            pageController: _controller,
            itemCount: widget.imageList.length,
            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                imageProvider:
                    NetworkImage(widget.imageList[index], scale: 1.0),
                minScale: PhotoViewComputedScale.contained * 0.8,
                maxScale: PhotoViewComputedScale.covered * 2,
              );
            },
            scrollPhysics: const BouncingScrollPhysics(),
            backgroundDecoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              // color: Theme.of(context).canvasColor,
              color: Colors.transparent,
            ),
            // enableRotation: true,
            loadingBuilder: (context, event) => Center(
              child: SizedBox(
                width: 30.0,
                height: 30.0,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.orange,
                  value: event == null
                      ? 0
                      : event.cumulativeBytesLoaded /
                          event.expectedTotalBytes!.toInt(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
