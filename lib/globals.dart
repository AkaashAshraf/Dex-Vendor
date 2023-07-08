import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mplus_provider/models/cities.dart';
import 'package:mplus_provider/setting_pages/notification_page.dart';
import 'models/app_info.dart';
import 'models/categories.dart';
import 'models/order_info.dart';
import 'models/product.dart';
import 'models/shops.dart';
import 'package:responsive_widgets/responsive_widgets.dart';

String baseURL = 'https://dexoman.com/api/';
// String baseImageURL = 'http://dexoman.com/storage/';
String baseImageURL = 'https://dexoman.com/backend/public/storage/';
String baseNotificationURL = 'https://dexoman.com/api/fire/';
Dio dioClient = new Dio();

AppInfo appInfo;

List<Shop> shopList = [];
Shop shop;
var userId;
var userName;
var userImage;

int currentShowCase = 1;
GlobalKey showCaseOne = GlobalKey();
GlobalKey showCaseTwo = GlobalKey();
GlobalKey showCaseThree = GlobalKey();
GlobalKey showcaseFive = GlobalKey();
int cartIDs = 0;
int bottomSelectedIndex = 0;
dynamic notiColor = Colors.green[50];

var latitude = 0.0;
var longitude = 0.0;
LatLng lastMapPosition;

ValueNotifier<bool> repetNoti = ValueNotifier<bool>(true);

class MessageNotification extends StatelessWidget {
  final VoidCallback onReplay;

  final String message;
  final String title;

  MessageNotification({Key key, this.onReplay, this.message, this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ResponsiveWidgets.init(context,
        height: 1560, width: 720, allowFontScaling: true);

    return ResponsiveWidgets.builder(
      height: 1560,
      width: 720,
      allowFontScaling: true,
      child: Card(
        color: notiColor,
        margin: EdgeInsetsResponsive.symmetric(horizontal: 10),
        child: SafeArea(
          child: ListTile(
            leading: SizedBoxResponsive.fromSize(
                size: const Size(80, 80),
                child: ClipOval(child: Image.asset('images/logo.png'))),
            title: TextResponsive(title),
            subtitle: TextResponsive(message),
            trailing: IconButton(
                icon: Icon(Icons.reply),
                onPressed: () {
                  if (onReplay != null) onReplay();
                }),
          ),
        ),
      ),
    );
  }
}

Widget appBar(
    {BuildContext context,
    bool backButton,
    String title,
    bool isNotification = false}) {
  return SizedBoxResponsive(
    height: 80,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Color(0xff575757),
                  size: 25,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            TextResponsive(
              title,
              style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff575757)),
            ),
          ],
        ),
        backButton
            ? ContainerResponsive(
                width: 95,
                height: 95,
                child: FlatButton(
                    onPressed: () {
                      isNotification
                          // ignore: unnecessary_statements
                          ? null
                          : Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NotificationPage()));
                    },
                    child: Icon(
                      Icons.notifications_none,
                      size: ScreenUtil().setSp(50).toDouble(),
                      color: Theme.of(context).accentColor,
                    )))
            : ContainerResponsive()
      ],
    ),
  );
}

Future getAppInfo() async {
  try {
    var response = await dioClient.get(baseURL + 'AppInfo/3');
    var data = response.data;

    appInfo = AppInfo.fromJson(data);
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

var units;

var locationSelected = false;
var lat;
var lang;
List<City> cities = [];

var fcmToken;

List<Category> categoryList = [];
List<OrderInfo> allOrderList = [];

// Waiting Order
List<OrderInfo> waitingOrderList = [];

// Preparing Order
List<OrderInfo> preparingOrderList = [];

//Finished Order
List<OrderInfo> doneOrderList = [];

//My Products
List<Product> myProducts = [];

var shopReport;
