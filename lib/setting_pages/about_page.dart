import 'package:flutter/material.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import '../globals.dart';
import 'notification_page.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    ResponsiveWidgets.init(context,
        height: 1560, width: 720, allowFontScaling: true);

    var string = Localizations.localeOf(context).languageCode == 'en'
        ? appInfo.aboutUsEn ?? ''
        : appInfo.aboutUs;

    return ResponsiveWidgets.builder(
      height: 1560,
      width: 720,
      allowFontScaling: true,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          // decoration: BoxDecoration(
          //   image: DecorationImage(
          //       image: AssetImage('images/background.png'), fit: BoxFit.cover),
          // ),
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: <Widget>[
                    SizedBoxResponsive(
                      height: 20,
                    ),

                    /////////// Header

                    appBar(
                      context: context,
                      title: 'aboutTheApp'.tr(),
                      backButton: true,
                    ),
                    SizedBoxResponsive(
                      height: 40,
                    ),
                    ContainerResponsive(
                        heightResponsive: true,
                        widthResponsive: true,
                        height: 200,
                        width: 200,
                        child: Center(
                          child: Image.asset(
                            'images/logo.png',
                            fit: BoxFit.fill,
                          ),
                        )),
                    ContainerResponsive(
                      margin: EdgeInsetsResponsive.all(10),
                      child: TextResponsive(
                        string,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 22),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
