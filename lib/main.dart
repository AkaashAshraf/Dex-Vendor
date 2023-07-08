import 'dart:async';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mplus_provider/globals.dart';
import 'package:mplus_provider/login_register_screens/login_screen.dart';
import 'package:mplus_provider/login_register_screens/register_shop.dart';
import 'package:mplus_provider/models/cities.dart';
import 'package:mplus_provider/theme.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_trimmer/video_trimmer.dart';

import 'home.dart';
import 'models/shops.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _onBackgroundMessage(RemoteMessage message) async {
  Firebase.initializeApp();
  if (message.data != null) {
    var data = message.data;
    if (data['title'] == 'newOrder' || data['body'] == 'newOrder') {
      showNotification(title: data['title'], body: data['text'], payload: '');
    } else {
      showNotification(title: data['title'], body: data['text'], payload: '');
    }
  }
}

class Repeat extends ChangeNotifier {
  static bool repeat;

  static void startRepeat() {
    Repeat.repeat = true;
  }

  static void closeRepeat() async {
    Repeat.repeat = false;
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}

var channel;

void repetedNoti(String title, String body, String payload) async {
  await Future.delayed(Duration(seconds: 2));
  if (Repeat.repeat == true) {
    showNotification(title: title, body: body, payload: payload);
    repetedNoti(title, body, payload);
  } else {
    return;
  }
}

Future<dynamic> showNotification(
    {String title, String body, String payload}) async {
  AndroidNotificationDetails androidNotiDetails = AndroidNotificationDetails(
    '1',
    'Order Noti',
    'Uniqu Sound Noti On Background',
    sound: RawResourceAndroidNotificationSound('thatwasquick'),
    importance: Importance.max,
    priority: Priority.high,
  );
  var iosDeatails = IOSNotificationDetails();
  NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidNotiDetails, iOS: iosDeatails);
  await flutterLocalNotificationsPlugin.show(
      0, title, body, platformChannelSpecifics,
      payload: '{{"notification":"sound:"thatwasquick""}}');
}

void localNoti() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');
  final IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings();
  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      .createNotificationChannel(AndroidNotificationChannel(
          '1', 'Order Noti', 'Uniqu Sound Noti On Background',
          importance: Importance.high,
          sound: RawResourceAndroidNotificationSound('thatwasquick')));
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  localNoti();
  FirebaseMessaging.onBackgroundMessage(_onBackgroundMessage);
  runApp(EasyLocalization(
    supportedLocales: [Locale('ar'), Locale('en')],
    path: 'translations',
    fallbackLocale: Locale('ar'),
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale newLocale) async {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.changeLanguage(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  changeLanguage(Locale locale) {
    setState(() {
      context.locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    return OverlaySupport(
        child: MaterialApp(
      routes: {"home": (context) => Home()},
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'Dex Provider',
      theme: appTheme(),
      home: EasyLocalization(
          supportedLocales: [Locale('ar'), Locale('en')],
          path: 'translations',
          fallbackLocale: Locale('en'),
          child: MyHomePage(title: 'Dex Provider')),
    ));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  MediaQueryData queryData;
  AnimationController controller;
  Animation<double> animation;
  var userId;

  var end = 0;

  getCountries() async {
    Dio _client = new Dio();
    try {
      var response = await _client.get(baseURL + 'getCities');
      print(response.data);
      if (response.data != null) {
        cities = [];
        response.data.forEach((v) {
          cities.add(new City.fromJson(v));
        });
        print('${cities[0].id}');
      }
    } on DioError catch (error) {
      print('ERROR COUNTRIES  $error');
      throw error;
    } catch (error) {
      throw error;
    }
  }

  getUnits() async {
    Dio _client = new Dio();
    try {
      var response = await _client.get(baseURL + 'getUnits');
      print(response.data);
      if (response.data != null) {
        units = response.data as List;
      }
    } on DioError catch (error) {
      print('ERROR COUNTRIES  $error');
      throw error;
    } catch (error) {
      throw error;
    }
  }

  Future<void> getFromSF() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    userId = pref.getString('user_id');
    if (userId != null) {
      sendToken(userId);
    }
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    animation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(controller);

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        print(end.toString());
        if (userId != null) {
          if (!getShopsCalled) {
            getShopData(userId);
          }
        } else {
          if (cities != null) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => LoginScreen()));
          } else {
            end++;
          }
        }

        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });

    controller.forward();
  }

  bool getShopsCalled = false;
  Future getShopData(var userId) async {
    getShopsCalled = true;
    try {
      var response = await dioClient
          .get(baseURL + 'getMyShops/OrderBy&iddealerId&$userId');
      print('RESPONSE Shop  ${response.data}');
      if (response.data != '') {
        print('RESPONSE MESSAGE ${response.data}');
        // ignore: unused_local_variable
        var data = response.data;
        print("BEFORE");
        shop = Shop.fromJson(response.data);
        print(bottomSelectedIndex);
        Navigator.pushReplacementNamed(context, 'home');
      } else {
        Fluttertoast.showToast(
            msg: "addStoreFirst".tr(),
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.redAccent,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => RegisterShopScreen(
                      customerId: userId,
                    )));
      }
      print("AFTE");
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

  Timer _timer;

  @override
  void dispose() {
    if (mounted) {
      if (controller != null) {
        controller.dispose();
      }
      if (_timer != null) {
        _timer.cancel();
      }
    }
    super.dispose();
  }

  Future sendToken(var userId) async {
    try {
      var token = await FirebaseMessaging.instance.getToken();

      print('TOKEN $token');

      var response = await dioClient
          .get(baseURL + 'sendToken/Userid=$userId&token=$token&appId=3');

      print('TOKEN RESPONSE $response');

      print("AFTER");
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

  void repetedNoti(String title, String body, String payload) async {
    await Future.delayed(Duration(seconds: 2));
    if (Repeat.repeat == true) {
      showNotification(title: title, body: body, payload: payload);
      repetedNoti(title, body, payload);
    } else {
      return;
    }
  }

  void noti() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.data != null) {
        var data = message.data;
        if (data['title'] == 'newOrder' || data['body'] == 'newOrder') {
          Repeat.startRepeat();
          showNotification(
              title: data['title'], body: data['text'], payload: '');
          // repetedNoti(data['title'], data['title'], '');
        } else {
          showNotification(
              title: data['title'], body: data['text'], payload: '');
        }
      }
    });
  }

  void localNoti() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings();

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onDidSelectLocalNotification);
  }

  Future<dynamic> showNotification(
      {String title, String body, String payload}) async {
    AndroidNotificationDetails androidNotiDetails = AndroidNotificationDetails(
      title.toString(),
      body.toString(),
      'Your Channel Description',
      sound: RawResourceAndroidNotificationSound('thatwasquick'),
      importance: Importance.max,
      priority: Priority.high,
    );
    var iosDeatails = IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidNotiDetails, iOS: iosDeatails);
    await flutterLocalNotificationsPlugin.show(
        0, title, body, platformChannelSpecifics,
        payload: '{{"notification":"sound:"thatwasquick""}}');
  }

  Future onDidSelectLocalNotification(String payload) async {
    Repeat.closeRepeat();
  }

  @override
  void initState() {
    super.initState();
    getFromSF();
    getAppInfo();
    getCountries();
    getUnits();
    localNoti();
    noti();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveWidgets.init(
      context,
      height: 1560,
      width: 720,
      allowFontScaling: true,
    );

    queryData = MediaQuery.of(context);

    return ResponsiveWidgets.builder(
      height: 1560,
      width: 720,
      allowFontScaling: true,
      child: Scaffold(
        body: ContainerResponsive(
            width: 720,
            height: 1560,
            child: Center(
              child: GestureDetector(
                onTap: () async {
                  try {
                    setState(() {
                      showNotification(
                          title: 'noti', body: 'noti', payload: '');
                    });
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
                },
                child: ContainerResponsive(
                    width: 200,
                    height: 200,
                    margin: EdgeInsetsResponsive.fromLTRB(0, 150, 0, 5),
                    child: Image.asset(
                      'images/logo.png',
                      fit: BoxFit.fill,
                    )),
              ),
            )),
      ),
    );
  }
}
