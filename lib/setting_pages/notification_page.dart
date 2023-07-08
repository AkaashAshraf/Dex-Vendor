import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mplus_provider/ui/widgets/loading.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:mplus_provider/models/notifications.dart';
import 'package:mplus_provider/models/order_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import '../globals.dart';
import '../home.dart';
import '../order_details.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<Notifications> notifications = [];
  var loading;

  notificationLoad() {
    return Column(
      children: <Widget>[
        SizedBoxResponsive(
          height: 70,
        ),
        /////////// Header
        appBar(
            context: context,
            title: 'notifications'.tr(),
            backButton: false,
            isNotification: true),
        SizedBoxResponsive(
          height: 200,
        ),
        Center(child: Load(150.0))
      ],
    );
  }

  Future getNotifications() async {
    try {
      loading = true;
      SharedPreferences pref = await SharedPreferences.getInstance();
      var response = await dioClient
          .get(baseURL + 'getNotifications/${pref.getString('user_id')}');

      var data = response.data;
      var shops = data as List;

      notifications = shops
          .map<Notifications>((json) => Notifications.fromJson(json))
          .toList();

      setState(() {
        loading = false;
      });

      print(notifications.length);
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
    getNotifications();
  }

  void getOrder(deliveryId) async {
    try {
      loading = true;
      print(baseURL + '/DeliveryInfo/deliveryId&$deliveryId');
      var response =
          await dioClient.get(baseURL + 'DeliveryInfo/deliveryId&$deliveryId');
      var data = response.data;
      OrderInfo order = OrderInfo.fromJson(data);
      Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
          builder: (context) => new OrderDetails(
                from: 'home',
                order: order,
              )));
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
  Widget build(BuildContext context) {
    ResponsiveWidgets.init(context,
        height: 1560, width: 720, allowFontScaling: true);

    _notificationCard(int index) {
      return GestureDetector(
        onTap: () {
          if (notifications[index].title == 'newchat') {
            bottomSelectedIndex = 1;
            Navigator.of(context, rootNavigator: true)
                .push(MaterialPageRoute(builder: (context) => new Home()));
          }
        },
        child: Container(
            child: Stack(children: <Widget>[
          Container(
              height: 65,
              width: MediaQuery.of(context).size.width * 90,
              margin: EdgeInsets.only(left: 20, right: 20, top: 5),
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  border: Border.all(color: Color(0xffF0F0F0), width: 1),
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                        border: Border.all(color: Color(0xffF2F2F2), width: 3),
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.contain,
                            image: NetworkImage(baseImageURL +
                                notifications[index].image.toString()))),
                  ),
                  SizedBox(width: 10),
                  Text(
                    _getNotificationTitle(notifications[index].body.toString(),),
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              )),
          Positioned(
            top: 0,
            left: 14,
            child: Visibility(
              visible: index == 0 ? true : false,
              child: Container(
                height: 18,
                width: 18,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ])),
      );
    }

    return ResponsiveWidgets.builder(
      height: 1560,
      width: 720,
      allowFontScaling: true,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: loading
            ? notificationLoad()
            : Column(
                children: <Widget>[
                  SizedBoxResponsive(
                    height: 70,
                  ),
                  /////////// Header
                  appBar(
                      context: context,
                      title: 'notifications'.tr(),
                      backButton: false,
                      isNotification: true),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) => _notificationCard(index),
                      itemCount: notifications.length,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  _getNotificationTitle(String title) {
    return title.contains('تم قبول الطلب')
        ? title.replaceAll('تم قبول الطلب', 'order_accepted'.tr())
        : title.contains('Order Accepted')
            ? title.replaceAll('Order Accepted', 'order_accepted'.tr())
            : title.contains('تحديث من')
                ? title.replaceAll('تحديث من', 'updateFrom'.tr())
                : title.contains('Update From')
                    ? title.replaceAll('تحديث من', 'updateFrom'.tr())
                    : title.contains('Message')
                        ? title.replaceAll('Message', 'message'.tr())
                        : title.contains('رسالة')
                            ? title.replaceAll('رسالة', 'message'.tr())
                            : title.contains('صورة')
                                ? title.replaceAll('صورة', 'img'.tr())
                                : title.contains('Image')
                                    ? title.replaceAll('Image', 'img'.tr())
                                    : title.contains('تم قبول الطلب من')
                                        ? title.replaceAll('تم قبول الطلب من',
                                            'requestAcceptedFrom'.tr())
                                        : title.contains('تم تحديث الطلب')
                                            ? title.replaceAll('تم تحديث الطلب',
                                                'theRequestHasBeenUpdated'.tr())
                                            : title.contains('noti title')
                                                ? title.replaceAll(
                                                    'noti title', 'test'.tr())
                                                : title;
  }
}
