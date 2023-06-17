import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mplus_provider/models/chat_model.dart';
import 'package:mplus_provider/ui/widgets/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../globals.dart';
import 'chat_item.dart';

class ChatListPage extends StatefulWidget {
  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  List<DeliveryChatListItem> deliveryChatListItem = [];
  bool loading = false;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void fetchDeliveryChats() async {
    try {
      setState(() {
        loading = true;
      });
      var pref = await SharedPreferences.getInstance();
      var id = pref.getString('user_id');
      var response = await Dio().get(baseURL + 'getchatmessages&target=$id');

      var data = response.data['data'];
      var categories = data as List;

      deliveryChatListItem = categories
          .map<DeliveryChatListItem>(
              (json) => DeliveryChatListItem.fromJson(json))
          .toList();
      setState(() {
        loading = false;
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
  }

  @override
  void initState() {
    super.initState();
    registerNotification();
    // configLocalNotification();
    Future.delayed(Duration.zero, () {
      fetchDeliveryChats();
    });
  }

  void registerNotification() {
    FirebaseMessaging.instance.requestPermission();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('onMessage: $message');
      var noti = message.notification;
      showNotification(title: noti.title, body: noti.body, payload: '');
    });
  }

  void configLocalNotification() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void showNotification({String title, String body, String payload}) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      Platform.isAndroid
          ? 'com.dfa.flutterchatdemo'
          : 'com.duytq.flutterchatdemo',
      'Flutter chat demo',
      'your channel description',
      playSound: true,
      enableVibration: true,
      importance: Importance.max,
      priority: Priority.high,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: payload);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, cons) {
      var _height = cons.maxHeight;
      return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.white,
            title: Icon(Icons.chat, color: Theme.of(context).accentColor),
            centerTitle: true,
            leading: IconButton(
                color: Colors.black,
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
          ),
          body: loading == true
              ? Center(child: Load(200.0))
              : ListView.builder(
                  itemBuilder: (context, index) {
                    return Container(
                      height: _height * .1,
                      child: DeliveryChat(
                        deliveryChatListItem: deliveryChatListItem[index],
                      ),
                    );
                  },
                  itemCount: deliveryChatListItem.length,
                ));
    });
  }
}
