import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:easy_localization/easy_localization.dart';

Load(var _height) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      SizedBox(
        width: _height - 20,
        height: _height - 20,
        child: FlareActor("assets/flrs/loadingCircles.flr",
            alignment: Alignment.center,
            color: Color(0xff373645),
            fit: BoxFit.fill,
            animation: "Loading"),
      ),
      Text('loading'.tr())
    ],
  );
}

ImageLoad(_height) {
  return SizedBoxResponsive(
    width: _height,
    height: _height,
    child: FlareActor("assets/flrs/loadingCircles.flr",
        color: Color(0xff373645),
        alignment: Alignment.center,
        fit: BoxFit.fill,
        animation: "Loading"),
  );
}
