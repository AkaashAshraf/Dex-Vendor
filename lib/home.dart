import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:mplus_provider/menu_pages/my_orders.dart';
import 'package:mplus_provider/menu_pages/my_products.dart';
import 'package:mplus_provider/menu_pages/settings.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:easy_localization/easy_localization.dart';

import 'globals.dart';
import 'menu_pages/home.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TabController _tabController;

  List<Widget> pages = [
    HomePage(),
    OrdersPage(),
    MyProductsPage(),
    SettingPage(),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        vsync: this, length: pages.length, initialIndex: bottomSelectedIndex);
    print(bottomSelectedIndex);
    // localNoti();
    // noti();
  }

  // void localNoti() async {
  //   const AndroidInitializationSettings initializationSettingsAndroid =
  //       AndroidInitializationSettings('app_icon');
  //   final IOSInitializationSettings initializationSettingsIOS =
  //       IOSInitializationSettings();

  //   final InitializationSettings initializationSettings =
  //       InitializationSettings(
  //           initializationSettingsAndroid, initializationSettingsIOS);
  //   await flutterLocalNotificationsPlugin.initialize(initializationSettings,
  //       onSelectNotification: onDidSelectLocalNotification);
  // }

  // Future<dynamic> showNotification(
  //     {String title, String body, String payload}) async {
  //   AndroidNotificationDetails androidNotiDetails = AndroidNotificationDetails(
  //     'your channel id',
  //     'DEX Provider',
  //     'DeliveryX Provider App',
  //     importance: Importance.Max,
  //     priority: Priority.High,
  //   );
  //   IOSNotificationDetails iosDeatails = IOSNotificationDetails();
  //   NotificationDetails platformChannelSpecifics =
  //       NotificationDetails(androidNotiDetails, iosDeatails);
  //   await flutterLocalNotificationsPlugin
  //       .show(0, title, body, platformChannelSpecifics, payload: payload);
  // }

  Future onDidSelectLocalNotification(String payload) {
    // will be used later
    return Future.value();
  }

  void noti() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        print(message.notification);
        // var noti = message.notification;
        // // showNotification(title: noti!.title, body: noti.body, payload: '');
      } else {
        print(message);
      }
    });
  }

  void forgetFirstTime() async {
    var pref = await SharedPreferences.getInstance();
    pref.setBool('firstTime', false);
  }

  void forgetSecFirstTime() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('secFirstTime', false);
  }

  void forget3FirstTime() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('3FirstTime', false);
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveWidgets.init(context,
        height: 1560, width: 720, allowFontScaling: true);

    return ResponsiveWidgets.builder(
      height: 1560,
      width: 720,
      allowFontScaling: true,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ShowCaseWidget(
            onFinish: () {
              if (currentShowCase == 1) {
                forgetFirstTime();
              } else if (currentShowCase == 2) {
                forgetSecFirstTime();
              } else if (currentShowCase == 3) {
                forget3FirstTime();
                currentShowCase++;
              }
            },
            builder: Builder(
              builder: (context) => TabBarView(
                physics: NeverScrollableScrollPhysics(),
                controller: _tabController,
                children: pages,
              ),
            )),
        bottomNavigationBar: AnimatedBottomNav(
            currentIndex: bottomSelectedIndex,
            onChange: (index) {
              setState(() {
                bottomSelectedIndex = index;
                _tabController.animateTo(bottomSelectedIndex);
              });
            }),
      ),
    );
  }
}

class AnimatedBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onChange;

  const AnimatedBottomNav({Key key, this.currentIndex, this.onChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kToolbarHeight,
      decoration: BoxDecoration(color: Colors.white),
      child: Row(
        children: <Widget>[
          Expanded(
            child: InkWell(
              onTap: () => onChange(0),
              child: BottomNavItem(
                icon: Icons.home,
                title: 'mainMenu'.tr(),
                isActive: currentIndex == 0,
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () => onChange(1),
              child: BottomNavItem(
                icon: Icons.list,
                title: "orders".tr(),
                isActive: currentIndex == 1,
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () => onChange(2),
              child: BottomNavItem(
                icon: Icons.shopping_cart,
                title: "products".tr(),
                isActive: currentIndex == 2,
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () => onChange(3),
              child: BottomNavItem(
                icon: Icons.person,
                title: "settings".tr(),
                isActive: currentIndex == 3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomNavItem extends StatelessWidget {
  final bool isActive;
  final IconData icon;
  final Color activeColor;
  final Color inactiveColor;
  final String title;

  const BottomNavItem(
      {Key key,
      this.isActive = false,
      this.icon,
      this.activeColor,
      this.inactiveColor,
      this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      transitionBuilder: (child, animation) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
      duration: Duration(milliseconds: 500),
      reverseDuration: Duration(milliseconds: 200),
      child: isActive
          ? Container(
              color: Colors.white,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: activeColor ?? Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Container(
                    width: 5.0,
                    height: 5.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: activeColor ?? Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            )
          : Icon(
              icon,
              color: inactiveColor ?? Colors.grey,
            ),
    );
  }
}
