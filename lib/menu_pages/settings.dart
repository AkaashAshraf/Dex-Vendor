import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mplus_provider/chat/chat_list.dart';
import 'package:mplus_provider/login_register_screens/login_screen.dart';
import 'package:mplus_provider/login_register_screens/register_screen.dart';
import 'package:mplus_provider/menu_pages/home.dart';
import 'package:mplus_provider/models/shops.dart';
import 'package:mplus_provider/setting_pages/about_page.dart';
import 'package:mplus_provider/setting_pages/contact_page.dart';
import 'package:mplus_provider/ui/widgets/loading.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:mplus_provider/setting_pages/my_account.dart';
import 'package:mplus_provider/setting_pages/notification_page.dart';
import 'package:mplus_provider/setting_pages/rules_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:mplus_provider/crop_video.dart';
import '../globals.dart';
import '../main.dart';
import '../models/user.dart';
import 'my_orders.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  var width, height;
  var user;
  var shop;
  var loading = false;
  var prefs;

  Future getUserData() async {
    try {
      loading = true;

      prefs = await SharedPreferences.getInstance();

      var response = await dioClient
          .get(baseURL + 'getUserinfo/${prefs.getString('user_phone')}');
      print('RESPONSE $response');
      var data = response.data;
      print('BEFOR $data');
      user = User.fromJson(data);

      getShopData(user.id);

//      print(user);
    } on DioError catch (error) {
      switch (error.type) {
        case DioErrorType.connectTimeout:
        case DioErrorType.sendTimeout:
        case DioErrorType.cancel:
          throw error;
          break;
        default:
          throw error;
      }
    } catch (error) {
      throw error;
    }
  }

  Future getShopData(var userId) async {
    try {
      prefs = await SharedPreferences.getInstance();
      var response = await dioClient
          .get(baseURL + 'getMyShops/OrderBy&iddealerId&$userId');
      print('RESPONSE Shop  ${response.data}');
      if (response.data != '') {
        print('RESPONSE MESSAGE ${response.data}');
        // ignore: unused_local_variable
        var data = response.data;
        print("After");
        shop = Shop.fromJson(response.data);

        if (this.mounted) {
          setState(() {
            loading = false;
          });
        }
      } else {
        if (this.mounted) {
          setState(() {
            loading = false;
          });
        }
      }
      print("AFTE");
//      print(user);
    } on DioError catch (error) {
      switch (error.type) {
        case DioErrorType.connectTimeout:
        case DioErrorType.sendTimeout:
        case DioErrorType.cancel:
          throw error;
          break;
        default:
          throw error;
      }
    } catch (error) {
      throw error;
    }
  }

  showShowCase() async {
    var prefs = await SharedPreferences.getInstance();
    var rdFirstTime = prefs.getBool('3FirstTime');
    if (rdFirstTime != false) {
      ShowCaseWidget.of(context).startShowCase([showCaseThree]);
      currentShowCase = 3;
    }
  }

  var _locale;

  @override
  void initState() {
    getUserData();
    showShowCase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveWidgets.init(context,
        height: 1560, width: 720, allowFontScaling: true);
    height = MediaQuery.of(context).size.height / 100;
    width = MediaQuery.of(context).size.width / 100;

    return ResponsiveWidgets.builder(
      height: 1560,
      width: 720,
      allowFontScaling: true,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: loading
            ? Center(child: Load(150.0))
            : SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBoxResponsive(
                      height: 70,
                    ),
                    SizedBoxResponsive(
                      height: 80,
                      child: ContainerResponsive(
                        margin: EdgeInsetsResponsive.symmetric(horizontal: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            TextResponsive(
                              'settings'.tr(),
                              style: TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.w300,
                                  color: Theme.of(context).accentColor),
                            ),
                            GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              NotificationPage()));
                                },
                                child: Icon(Icons.notifications_none,
                                    size: ScreenUtil().setSp(50).toDouble(),
                                    color: Theme.of(context).accentColor)),
                          ],
                        ),
                      ),
                    ),
                    SizedBoxResponsive(
                      height: 20,
                    ),
                    user.id != null
                        ? ContainerResponsive(
                            heightResponsive: true,
                            widthResponsive: true,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                ContainerResponsive(
                                  heightResponsive: true,
                                  widthResponsive: true,
                                  margin: EdgeInsetsResponsive.only(left: 30),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsetsResponsive.only(
                                            top: 16, left: 10),
                                        child: TextResponsive(
                                          user.firstName,
                                          style: TextStyle(
                                              fontSize: 48,
                                              fontWeight: FontWeight.w900),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsResponsive.only(
                                            top: 16, left: 5),
                                        child: TextResponsive(
                                          context.locale == Locale('ar')
                                              ? shop.nameAr.toString()
                                              : shop.name.toString(),
                                          style: TextStyle(
                                              fontSize: 35,
                                              fontWeight: FontWeight.w200),
                                        ),
                                      ),
                                      SizedBoxResponsive(
                                        height: 35,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          TextResponsive(
                                            'membersCenter'.tr(),
                                            style: TextStyle(
                                                fontSize: 25,
                                                color: Theme.of(context)
                                                    .accentColor),
                                          ),
                                          Icon(
                                            Icons.arrow_right,
                                            color: Colors.black26,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                ContainerResponsive(
                                    heightResponsive: true,
                                    widthResponsive: true,
                                    margin: EdgeInsetsResponsive.only(left: 20),
                                    width: 200,
                                    height: 200,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 5, color: Colors.white),
                                        shape: BoxShape.circle),
                                    child: CachedNetworkImage(
                                      width: 100,
                                      height: 100,
                                      imageUrl: baseImageURL + shop.image,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          ImageLoad(55.0),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                        'images/image404.png',
                                        width: 55,
                                        height: 55,
                                      ),
                                    ))
                              ],
                            ))
                        : ContainerResponsive(
                            heightResponsive: true,
                            widthResponsive: true,
                            height: 120,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                ContainerResponsive(
                                    heightResponsive: true,
                                    widthResponsive: true,
                                    margin: EdgeInsetsResponsive.only(left: 0),
                                    child: TextResponsive(
                                      'enterMembersCenter'.tr(),
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w900),
                                    )),
                                SizedBoxResponsive(
                                  height: 20,
                                ),
                                ContainerResponsive(
                                  heightResponsive: true,
                                  widthResponsive: true,
                                  margin: EdgeInsetsResponsive.only(
                                      left: 10, right: 15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            EdgeInsetsResponsive.only(left: 20),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        RegisterScreen()));
                                          },
                                          child: TextResponsive(
                                            'createNewAccount'.tr(),
                                            style: TextStyle(
                                                fontSize: 28,
                                                fontWeight: FontWeight.w600,
                                                decoration:
                                                    TextDecoration.underline,
                                                color: Color(0xff34C961)),
                                          ),
                                        ),
                                      ),
                                      TextResponsive(
                                        'or'.tr(),
                                        style: TextStyle(fontSize: 26),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsetsResponsive.only(left: 10),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        LoginScreen()));
                                          },
                                          child: TextResponsive(
                                            'تسجيل'.tr(),
                                            style: TextStyle(
                                                fontSize: 26,
                                                fontWeight: FontWeight.w600,
                                                decoration:
                                                    TextDecoration.underline,
                                                color: Color(0xff34C961)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )),
                    SizedBoxResponsive(height: 10),
                    ContainerResponsive(
                        heightResponsive: true,
                        widthResponsive: true,
                        height: 80,
                        color: Color(0xffF8F8F8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsetsResponsive.only(left: 40.0),
                              child: TextResponsive(
                                'generalSettings'.tr(),
                                style: TextStyle(
                                  fontSize: 26,
                                  color: Colors.black,
                                ),
                              ),
                            )
                          ],
                        )),
                    Showcase(
                      key: showCaseThree,
                      overlayOpacity: 0.9,
                      shapeBorder: CircleBorder(),
                      textColor: Colors.white,
                      showcaseBackgroundColor: Theme.of(context).primaryColor,
                      overlayColor: Theme.of(context).accentColor,
                      description: 'pressShowInfo'.tr(),
                      disableAnimation: false,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyAccount(
                                        user: user,
                                        shop: shop,
                                      )));
                        },
                        child: ContainerResponsive(
                            heightResponsive: true,
                            widthResponsive: true,
                            height: 100,
                            padding:
                                EdgeInsetsResponsive.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                                color: Color(0xffFFFFFF),
                                border: Border(
                                    bottom: BorderSide(
                                        width: 1, color: Color(0xffF2F2F2)))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: [
                                    ContainerResponsive(
                                        heightResponsive: true,
                                        widthResponsive: true,
                                        width: 70,
                                        height: 70,
                                        child: ContainerResponsive(
                                            margin: EdgeInsetsResponsive.only(
                                                left: 5),
                                            decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .accentColor,
                                                borderRadius: BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(16.0),
                                                    topRight:
                                                        Radius.circular(16.0))),
                                            width: 70,
                                            height: 70,
                                            child: Center(
                                              child: Icon(Icons.person_outline,
                                                  color: Colors.white),
                                            ))),
                                    SizedBoxResponsive(width: 30),
                                    ContainerResponsive(
                                      heightResponsive: true,
                                      widthResponsive: true,
                                      child: TextResponsive(
                                        'myAccount'.tr(),
                                        style: TextStyle(fontSize: 30),
                                      ),
                                    ),
                                  ],
                                ),
                                ContainerResponsive(
                                    heightResponsive: true,
                                    widthResponsive: true,
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 18,
                                      color: Theme.of(context).accentColor,
                                    )),
                              ],
                            )),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NotificationPage()));
                      },
                      child: ContainerResponsive(
                          heightResponsive: true,
                          widthResponsive: true,
                          padding:
                              EdgeInsetsResponsive.symmetric(horizontal: 20),
                          height: 100,
                          decoration: BoxDecoration(
                              color: Color(0xffFFFFFF),
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1, color: Color(0xffF2F2F2)))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: [
                                  ContainerResponsive(
                                    heightResponsive: true,
                                    widthResponsive: true,
                                    width: 70,
                                    height: 70,
                                    child: ContainerResponsive(
                                        decoration: BoxDecoration(
                                            color:
                                                Theme.of(context).accentColor,
                                            borderRadius: BorderRadius.only(
                                                bottomLeft:
                                                    Radius.circular(16.0),
                                                topRight:
                                                    Radius.circular(16.0))),
                                        width: 70,
                                        height: 70,
                                        child: Center(
                                          child: Icon(Icons.notifications_none,
                                              color: Colors.white),
                                        )),
                                  ),
                                  SizedBoxResponsive(width: 30),
                                  ContainerResponsive(
                                    heightResponsive: true,
                                    widthResponsive: true,
                                    child: TextResponsive(
                                      'notifications'.tr(),
                                      style: TextStyle(fontSize: 30),
                                    ),
                                  ),
                                ],
                              ),
                              ContainerResponsive(
                                  heightResponsive: true,
                                  widthResponsive: true,
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 18,
                                    color: Theme.of(context).accentColor,
                                  )),
                            ],
                          )),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OrdersPage()));
                      },
                      child: ContainerResponsive(
                          heightResponsive: true,
                          widthResponsive: true,
                          padding:
                              EdgeInsetsResponsive.symmetric(horizontal: 20),
                          height: 100,
                          decoration: BoxDecoration(
                              color: Color(0xffFFFFFF),
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1, color: Color(0xffF2F2F2)))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: [
                                  ContainerResponsive(
                                    heightResponsive: true,
                                    widthResponsive: true,
                                    width: 70,
                                    height: 70,
                                    child: ContainerResponsive(
                                        decoration: BoxDecoration(
                                            color:
                                                Theme.of(context).accentColor,
                                            borderRadius: BorderRadius.only(
                                                bottomLeft:
                                                    Radius.circular(16.0),
                                                topRight:
                                                    Radius.circular(16.0))),
                                        width: 70,
                                        height: 70,
                                        child: Center(
                                          child: Icon(Icons.list,
                                              color: Colors.white),
                                        )),
                                  ),
                                  SizedBoxResponsive(width: 30),
                                  ContainerResponsive(
                                    heightResponsive: true,
                                    widthResponsive: true,
                                    child: TextResponsive(
                                      'myOrders'.tr(),
                                      style: TextStyle(fontSize: 30),
                                    ),
                                  ),
                                ],
                              ),
                              ContainerResponsive(
                                  heightResponsive: true,
                                  widthResponsive: true,
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 18,
                                    color: Theme.of(context).accentColor,
                                  )),
                            ],
                          )),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatListPage()));
                      },
                      child: ContainerResponsive(
                          heightResponsive: true,
                          widthResponsive: true,
                          padding:
                              EdgeInsetsResponsive.symmetric(horizontal: 20),
                          height: 100,
                          decoration: BoxDecoration(
                              color: Color(0xffFFFFFF),
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1, color: Color(0xffF2F2F2)))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: [
                                  ContainerResponsive(
                                    heightResponsive: true,
                                    widthResponsive: true,
                                    width: 70,
                                    height: 70,
                                    child: ContainerResponsive(
                                        decoration: BoxDecoration(
                                            color:
                                                Theme.of(context).accentColor,
                                            borderRadius: BorderRadius.only(
                                                bottomLeft:
                                                    Radius.circular(16.0),
                                                topRight:
                                                    Radius.circular(16.0))),
                                        width: 70,
                                        height: 70,
                                        child: Center(
                                          child: Icon(Icons.chat,
                                              color: Colors.white),
                                        )),
                                  ),
                                  SizedBoxResponsive(width: 30),
                                  ContainerResponsive(
                                    heightResponsive: true,
                                    widthResponsive: true,
                                    child: TextResponsive(
                                      'chat'.tr(),
                                      style: TextStyle(fontSize: 30),
                                    ),
                                  ),
                                ],
                              ),
                              ContainerResponsive(
                                  heightResponsive: true,
                                  widthResponsive: true,
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 18,
                                    color: Theme.of(context).accentColor,
                                  )),
                            ],
                          )),
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
                              padding: EdgeInsetsResponsive.only(left: 40),
                              child: TextResponsive(
                                'aboutApp'.tr(),
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.black,
                                ),
                              ),
                            )
                          ],
                        )),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AboutPage()));
                      },
                      child: ContainerResponsive(
                          heightResponsive: true,
                          widthResponsive: true,
                          padding:
                              EdgeInsetsResponsive.symmetric(horizontal: 20),
                          height: 100,
                          decoration: BoxDecoration(
                              color: Color(0xffFFFFFF),
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1, color: Color(0xffF2F2F2)))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: [
                                  ContainerResponsive(
                                      heightResponsive: true,
                                      widthResponsive: true,
                                      width: 70,
                                      height: 70,
                                      child: ContainerResponsive(
                                          decoration: BoxDecoration(
                                              color:
                                                  Theme.of(context).accentColor,
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(16.0),
                                                  topRight:
                                                      Radius.circular(16.0))),
                                          width: 70,
                                          height: 70,
                                          child: Center(
                                            child: Icon(Icons.info_outline,
                                                color: Colors.white),
                                          ))),
                                  SizedBoxResponsive(width: 30),
                                  ContainerResponsive(
                                    heightResponsive: true,
                                    widthResponsive: true,
                                    child: TextResponsive(
                                      'aboutTheApp'.tr(),
                                      style: TextStyle(fontSize: 30),
                                    ),
                                  ),
                                ],
                              ),
                              ContainerResponsive(
                                  heightResponsive: true,
                                  widthResponsive: true,
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 18,
                                    color: Theme.of(context).accentColor,
                                  )),
                            ],
                          )),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ContactPage(user: user)));
                      },
                      child: ContainerResponsive(
                          heightResponsive: true,
                          widthResponsive: true,
                          padding:
                              EdgeInsetsResponsive.symmetric(horizontal: 20),
                          height: 100,
                          decoration: BoxDecoration(
                              color: Color(0xffFFFFFF),
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1, color: Color(0xffF2F2F2)))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: [
                                  ContainerResponsive(
                                    heightResponsive: true,
                                    widthResponsive: true,
                                    width: 70,
                                    height: 70,
                                    child: ContainerResponsive(
                                        decoration: BoxDecoration(
                                            color:
                                                Theme.of(context).accentColor,
                                            borderRadius: BorderRadius.only(
                                                bottomLeft:
                                                    Radius.circular(16.0),
                                                topRight:
                                                    Radius.circular(16.0))),
                                        width: 70,
                                        height: 70,
                                        child: Center(
                                          child: Icon(Icons.phone_in_talk,
                                              color: Colors.white),
                                        )),
                                  ),
                                  SizedBoxResponsive(width: 30),
                                  ContainerResponsive(
                                    heightResponsive: true,
                                    widthResponsive: true,
                                    child: TextResponsive(
                                      'contactUs'.tr(),
                                      style: TextStyle(fontSize: 30),
                                    ),
                                  ),
                                ],
                              ),
                              ContainerResponsive(
                                  heightResponsive: true,
                                  widthResponsive: true,
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 18,
                                    color: Theme.of(context).accentColor,
                                  )),
                            ],
                          )),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.locale =
                            Localizations.localeOf(context).languageCode == 'en'
                                ? Locale('ar')
                                : Locale('en');
                        _locale = context.locale;
                        MyApp.setLocale(context, _locale);
                        setState(() {});
                      },
                      child: ContainerResponsive(
                          heightResponsive: true,
                          widthResponsive: true,
                          padding:
                              EdgeInsetsResponsive.symmetric(horizontal: 20),
                          height: 100,
                          decoration: BoxDecoration(
                              color: Color(0xffFFFFFF),
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1, color: Color(0xffF2F2F2)))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: [
                                  ContainerResponsive(
                                    heightResponsive: true,
                                    widthResponsive: true,
                                    width: 70,
                                    height: 70,
                                    child: ContainerResponsive(
                                        decoration: BoxDecoration(
                                            color:
                                                Theme.of(context).accentColor,
                                            borderRadius: BorderRadius.only(
                                                bottomLeft:
                                                    Radius.circular(16.0),
                                                topRight:
                                                    Radius.circular(16.0))),
                                        width: 70,
                                        height: 70,
                                        child: Center(
                                          child: Icon(Icons.translate,
                                              color: Colors.white),
                                        )),
                                  ),
                                  SizedBoxResponsive(width: 30),
                                  ContainerResponsive(
                                    heightResponsive: true,
                                    widthResponsive: true,
                                    child: TextResponsive(
                                      'changeLang'.tr(),
                                      style: TextStyle(fontSize: 30),
                                    ),
                                  ),
                                ],
                              ),
                              ContainerResponsive(
                                  heightResponsive: true,
                                  widthResponsive: true,
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 18,
                                    color: Theme.of(context).accentColor,
                                  )),
                            ],
                          )),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await FlutterShare.share(
                            title: 'Ahlan Washlan',
                            text: 'check out my website www.ahlnwashlan.com',
                            linkUrl: appInfo.play,
                            chooserTitle: 'Ahlan Washlan');
                      },
                      child: ContainerResponsive(
                          heightResponsive: true,
                          widthResponsive: true,
                          padding:
                              EdgeInsetsResponsive.symmetric(horizontal: 20),
                          height: 100,
                          decoration: BoxDecoration(
                              color: Color(0xffFFFFFF),
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1, color: Color(0xffF2F2F2)))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: [
                                  ContainerResponsive(
                                    heightResponsive: true,
                                    widthResponsive: true,
                                    width: 70,
                                    height: 70,
                                    child: ContainerResponsive(
                                        decoration: BoxDecoration(
                                            color:
                                                Theme.of(context).accentColor,
                                            borderRadius: BorderRadius.only(
                                                bottomLeft:
                                                    Radius.circular(16.0),
                                                topRight:
                                                    Radius.circular(16.0))),
                                        width: 70,
                                        height: 70,
                                        child: Center(
                                          child: Icon(Icons.share,
                                              color: Colors.white),
                                        )),
                                  ),
                                  SizedBoxResponsive(width: 30),
                                  ContainerResponsive(
                                    heightResponsive: true,
                                    widthResponsive: true,
                                    child: TextResponsive(
                                      'shareApp'.tr(),
                                      style: TextStyle(fontSize: 30),
                                    ),
                                  ),
                                ],
                              ),
                              ContainerResponsive(
                                  heightResponsive: true,
                                  widthResponsive: true,
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 18,
                                    color: Theme.of(context).accentColor,
                                  )),
                            ],
                          )),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RulesPage()));
                      },
                      child: ContainerResponsive(
                          heightResponsive: true,
                          widthResponsive: true,
                          padding:
                              EdgeInsetsResponsive.symmetric(horizontal: 20),
                          height: 100,
                          decoration: BoxDecoration(
                              color: Color(0xffFFFFFF),
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1, color: Color(0xffF2F2F2)))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: [
                                  ContainerResponsive(
                                    heightResponsive: true,
                                    widthResponsive: true,
                                    width: 70,
                                    height: 70,
                                    child: ContainerResponsive(
                                        decoration: BoxDecoration(
                                            color:
                                                Theme.of(context).accentColor,
                                            borderRadius: BorderRadius.only(
                                                bottomLeft:
                                                    Radius.circular(16.0),
                                                topRight:
                                                    Radius.circular(16.0))),
                                        width: 70,
                                        height: 70,
                                        child: Center(
                                          child: Icon(Icons.list,
                                              color: Colors.white),
                                        )),
                                  ),
                                  SizedBoxResponsive(width: 30),
                                  ContainerResponsive(
                                    heightResponsive: true,
                                    widthResponsive: true,
                                    child: TextResponsive(
                                      'termsOfUse'.tr(),
                                      style: TextStyle(fontSize: 30),
                                    ),
                                  ),
                                ],
                              ),
                              ContainerResponsive(
                                  heightResponsive: true,
                                  widthResponsive: true,
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 18,
                                    color: Theme.of(context).accentColor,
                                  )),
                            ],
                          )),
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            content: ListTile(
                              title: TextResponsive("logout".tr(),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: 26)),
                              subtitle: TextResponsive("sureToLogout".tr(),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: 22)),
                            ),
                            actions: <Widget>[
                              FlatButton(
                                color: Colors.grey.shade200,
                                child: TextResponsive('no'.tr(),
                                    style: TextStyle(
                                        fontSize: 26, color: Colors.black)),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                              FlatButton(
                                color: Theme.of(context).primaryColor,
                                child: TextResponsive('yes'.tr(),
                                    style: TextStyle(
                                        fontSize: 26, color: Colors.black)),
                                onPressed: () {
                                  bottomSelectedIndex = 0;
                                  prefs.clear();
                                  Navigator.of(context).pop();
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginScreen()));
                                },
                              ),
                            ],
                          ),
                        );
                      },
                      child: Visibility(
                        visible: true,
                        child: ContainerResponsive(
                            heightResponsive: true,
                            widthResponsive: true,
                            padding:
                                EdgeInsetsResponsive.symmetric(horizontal: 20),
                            height: 100,
                            decoration: BoxDecoration(
                                color: Color(0xffFFFFFF),
                                border: Border(
                                    bottom: BorderSide(
                                        width: 1, color: Color(0xffF2F2F2)))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: [
                                    ContainerResponsive(
                                        heightResponsive: true,
                                        widthResponsive: true,
                                        width: 70,
                                        height: 70,
                                        child: ContainerResponsive(
                                            decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .accentColor,
                                                borderRadius: BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(16.0),
                                                    topRight:
                                                        Radius.circular(16.0))),
                                            width: 70,
                                            height: 70,
                                            child: Center(
                                              child: Icon(Icons.exit_to_app,
                                                  color: Colors.white),
                                            ))),
                                    SizedBoxResponsive(width: 30),
                                    ContainerResponsive(
                                      heightResponsive: true,
                                      widthResponsive: true,
                                      child: TextResponsive(
                                        'logout'.tr(),
                                        style: TextStyle(fontSize: 30),
                                      ),
                                    ),
                                  ],
                                ),
                                ContainerResponsive(
                                    heightResponsive: true,
                                    widthResponsive: true,
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 18,
                                      color: Theme.of(context).accentColor,
                                    )),
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
