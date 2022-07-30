import 'package:flutter/cupertino.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:easy_localization/easy_localization.dart';

class EmptyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ResponsiveWidgets.init(
      context,
      height: 1560,
      width: 720,
      allowFontScaling: true,
    );

    return ResponsiveWidgets.builder(
      height: 1560,
      width: 720,
      allowFontScaling: true,
      child: ContainerResponsive(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                CupertinoIcons.delete,
                color: Color(0xff373645),
                size: 40,
              ),
              SizedBoxResponsive(
                height: 20,
              ),
              TextResponsive(
                'noData'.tr(),
                style: TextStyle(fontSize: 30),
              )
            ],
          ),
        ),
      ),
    );
  }
}
