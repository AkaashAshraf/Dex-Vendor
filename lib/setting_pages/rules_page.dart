import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import '../globals.dart';

class RulesPage extends StatefulWidget {
  final String from;
  RulesPage({this.from});
  @override
  _RulesPageState createState() => _RulesPageState(from);
}

class _RulesPageState extends State<RulesPage> {
  String from;
  _RulesPageState(from);
  @override
  Widget build(BuildContext context) {
    ResponsiveWidgets.init(context,
        height: 1560, width: 720, allowFontScaling: true);

    String txt  = Localizations.localeOf(context).languageCode == 'en'
        ? appInfo.termsEn ?? ''
        : appInfo.terms;

    return ResponsiveWidgets.builder(
      height: 1560,
      width: 720,
      allowFontScaling: true,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          // decoration: BoxDecoration(
          //     image: DecorationImage(
          //         image: AssetImage('images/background.png'),
          //         fit: BoxFit.cover)),
          child: Stack(
            children: <Widget>[
              Container(
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
                              backButton: from == 'logIn' ? false : true,
                              context: context,
                              title: 'termsUse'.tr()),
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

                          SizedBoxResponsive(
                            height: 0,
                          ),

                          /*Container(
                              margin: EdgeInsets.all(15),
                              child: appInfo.privacyPolicy == null ? Center(child: CircularProgressIndicator(),) : Text(appInfo.privacyPolicy,textAlign: TextAlign.center,style: TextStyle(fontSize: 13),),
                            ),*/

                          ContainerResponsive(
                            heightResponsive: true,
                            widthResponsive: true,
                            margin: EdgeInsetsResponsive.all(10.0),
                            child: Html(
                              data: """$txt""",
                            ),
                          ),
                        ],
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
