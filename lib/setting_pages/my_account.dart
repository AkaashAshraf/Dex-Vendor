import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mplus_provider/globals.dart';
import 'package:mplus_provider/models/shops.dart';
import 'package:mplus_provider/setting_pages/my_account_pages/comments.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:mplus_provider/setting_pages/my_account_pages/offers.dart';
import 'package:mplus_provider/setting_pages/my_account_pages/profile.dart';
import 'package:mplus_provider/setting_pages/my_account_pages/store_info.dart';
import '../models/user.dart';
import 'package:easy_localization/easy_localization.dart';

class MyAccount extends StatefulWidget {
  User user;
  Shop shop;

  MyAccount({this.user, this.shop});

  @override
  _MyAccountState createState() => _MyAccountState(this.user, this.shop);
}

class _MyAccountState extends State<MyAccount> {
  User user;
  Shop shop;

  _MyAccountState(this.user, this.shop);

  var width, height;

  @override
  Widget build(BuildContext context) {
    ResponsiveWidgets.init(context,
        height: 1560, width: 720, allowFontScaling: true);

    height = MediaQuery.of(context).size.height / 100;
    width = MediaQuery.of(context).size.width / 100;

    bool isSwitched = true;

    return ResponsiveWidgets.builder(
      height: 1560,
      width: 720,
      allowFontScaling: true,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBoxResponsive(
                height: 70,
              ),
              appBar(
                context: context,
                backButton: true,
                title: 'myAccount'.tr(),
              ),
              SizedBoxResponsive(
                height: 20,
              ),
              ContainerResponsive(
                  heightResponsive: true,
                  widthResponsive: true,
                  height: 80,
                  color: Color(0xffF8F8F8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsetsResponsive.only(left: 50.0),
                        child: TextResponsive(
                          'myAccount'.tr(),
                          style: TextStyle(fontSize: 31),
                        ),
                      )
                    ],
                  )),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Profile(user)));
                },
                child: ContainerResponsive(
                    heightResponsive: true,
                    widthResponsive: true,
                    height: 100,
                    decoration: BoxDecoration(
                        color: Color(0xffFFFFFF),
                        border: Border(
                            bottom: BorderSide(
                                width: 1, color: Color(0xffF2F2F2)))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          ContainerResponsive(
                              heightResponsive: true,
                              widthResponsive: true,
                              width: 70,
                              height: 70,
                              child: ContainerResponsive(
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).accentColor,
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(16.0),
                                          topRight: Radius.circular(16.0))),
                                  width: 70,
                                  height: 70,
                                  child: Center(
                                    child: Icon(Icons.person_outline,
                                        color: Colors.white),
                                  ))),
                          ContainerResponsive(
                            heightResponsive: true,
                            widthResponsive: true,
                            margin: EdgeInsets.only(left: 15, right: 15),
                            child: TextResponsive(
                              'personalData'.tr(),
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                          Spacer(),
                          ContainerResponsive(
                              heightResponsive: true,
                              widthResponsive: true,
                              child: Icon(
                                Icons.arrow_forward_ios,
                                size: 18,
                                color: Theme.of(context).accentColor,
                              )),
                        ],
                      ),
                    )),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => StoreInfo(shop)));
                },
                child: ContainerResponsive(
                    heightResponsive: true,
                    widthResponsive: true,
                    height: 100,
                    decoration: BoxDecoration(
                        color: Color(0xffFFFFFF),
                        border: Border(
                            bottom: BorderSide(
                                width: 1, color: Color(0xffF2F2F2)))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          ContainerResponsive(
                              heightResponsive: true,
                              widthResponsive: true,
                              width: 70,
                              height: 70,
                              child: ContainerResponsive(
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).accentColor,
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(16.0),
                                          topRight: Radius.circular(16.0))),
                                  width: 70,
                                  height: 70,
                                  child: Center(
                                    child: Icon(Icons.info_outline,
                                        color: Colors.white),
                                  ))),
                          ContainerResponsive(
                            heightResponsive: true,
                            widthResponsive: true,
                            margin: EdgeInsets.only(left: 15, right: 15),
                            child: TextResponsive(
                              'storeInfo'.tr(),
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                          Spacer(),
                          ContainerResponsive(
                              heightResponsive: true,
                              widthResponsive: true,
                              child: Icon(
                                Icons.arrow_forward_ios,
                                size: 18,
                                color: Theme.of(context).accentColor,
                              )),
                        ],
                      ),
                    )),
              ),
              Visibility(
                visible: false,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Comments(
                                  shop: shop,
                                )));
                  },
                  child: ContainerResponsive(
                      heightResponsive: true,
                      widthResponsive: true,
                      height: 100,
                      decoration: BoxDecoration(
                          color: Color(0xffFFFFFF),
                          border: Border(
                              bottom: BorderSide(
                                  width: 1, color: Color(0xffF2F2F2)))),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            ContainerResponsive(
                                heightResponsive: true,
                                widthResponsive: true,
                                width: 70,
                                height: 70,
                                child: ContainerResponsive(
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).accentColor,
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(16.0),
                                            topRight: Radius.circular(16.0))),
                                    width: 70,
                                    height: 70,
                                    child: Center(
                                      child: Icon(Icons.comment,
                                          color: Colors.white),
                                    ))),
                            ContainerResponsive(
                              heightResponsive: true,
                              widthResponsive: true,
                              margin: EdgeInsets.only(left: 15, right: 15),
                              child: TextResponsive(
                                'comments'.tr(),
                                style: TextStyle(fontSize: 30),
                              ),
                            ),
                            Spacer(),
                            ContainerResponsive(
                                heightResponsive: true,
                                widthResponsive: true,
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 18,
                                  color: Theme.of(context).accentColor,
                                )),
                          ],
                        ),
                      )),
                ),
              ),
              Visibility(
                visible: false,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Offers()));
                  },
                  child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          color: Color(0xffFFFFFF),
                          border: Border(
                              bottom: BorderSide(
                                  width: 1, color: Color(0xffF2F2F2)))),
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            left: 15,
                            top: 10,
                            child: Container(
                              width: 35,
                              height: 35,
                              child: SvgPicture.asset('images/contact.svg',
                                  semanticsLabel: 'A red up arrow'),
                            ),
                          ),
                          Positioned(
                            left: 60,
                            top: 12,
                            child: Container(
                              child: Text(
                                'العروض',
                                style: TextStyle(fontSize: 17),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 10,
                            top: 16,
                            child: Container(
                                child: Icon(
                              Icons.arrow_forward_ios,
                              size: 18,
                              color: Theme.of(context).accentColor,
                            )),
                          )
                        ],
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
