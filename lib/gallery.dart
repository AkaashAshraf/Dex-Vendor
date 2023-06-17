import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:photo_view/photo_view.dart';
import 'package:responsive_widgets/responsive_widgets.dart';

class GalleryPage extends StatefulWidget {
  final String imagePath;
  GalleryPage({this.imagePath});

  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  @override
  Widget build(BuildContext context) {
    ResponsiveWidgets.init(context,
        height: 1560, width: 720, allowFontScaling: true);

    return ResponsiveWidgets.builder(
      height: 1560,
      width: 720,
      allowFontScaling: true,
      child: new Scaffold(
        body: Stack(
          children: <Widget>[
            ContainerResponsive(
              color: Colors.red,
              child: PhotoView(
                imageProvider: NetworkImage(widget.imagePath),
              ),
            ),
            ContainerResponsive(
              height: 150,
              child: AppBar(
                backgroundColor: Color.fromRGBO(0, 0, 0, 0.2),
                elevation: 0.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
