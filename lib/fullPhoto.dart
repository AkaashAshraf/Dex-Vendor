import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:responsive_widgets/responsive_widgets.dart';

class FullPhoto extends StatelessWidget {
  final String url;

  FullPhoto({Key key, @required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ResponsiveWidgets.init(context,
        height: 1560, width: 720, allowFontScaling: true);

    return ResponsiveWidgets.builder(
      height: 1560,
      width: 720,
      allowFontScaling: true,
      child: new Scaffold(
        appBar: new AppBar(
          title: new TextResponsive(
            'FULL PHOTO',
            style: TextStyle(
                color: Color(0xff34C961),
                fontWeight: FontWeight.bold,
                fontSize: 35),
          ),
          centerTitle: true,
        ),
        body: new FullPhotoScreen(url: url),
      ),
    );
  }
}

class FullPhotoScreen extends StatefulWidget {
  final String url;

  FullPhotoScreen({Key key, @required this.url}) : super(key: key);

  @override
  State createState() => new FullPhotoScreenState(url: url);
}

class FullPhotoScreenState extends State<FullPhotoScreen> {
  final String url;

  FullPhotoScreenState({Key key, @required this.url});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ContainerResponsive(
        child: PhotoView(imageProvider: NetworkImage(url)));
  }
}
