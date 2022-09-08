import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mplus_provider/crop_video.dart';
import 'package:mplus_provider/empty_widget.dart';
import 'package:mplus_provider/login_register_screens/register_shop.dart';
import 'package:mplus_provider/models/order_info.dart';
import 'package:mplus_provider/models/product.dart';
import 'package:mplus_provider/models/shops.dart';
import 'package:mplus_provider/setting_pages/notification_page.dart';
import 'package:mplus_provider/ui/widgets/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;

//import 'package:kdar_app/loading.dart';
//import 'package:kdar_app/models/delivery_history.dart';
//import 'package:kdar_app/order_details.dart';
//import 'package:kdar_app/setting_pages/notification_page.dart';
//
//import '../cart_screen.dart';
import '../globals.dart';
import '../order_details.dart';
import 'package:mplus_provider/models/shopReport.dart';

import '../video_test.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var load = 0;
  var nextPage;
  var loading2 = false;
  ScrollController controller = ScrollController();

  _orderRow([var context, var index, var height]) {
    return GestureDetector(
      onTap: () async {
        bool reload = await Navigator.of(context, rootNavigator: true)
            .push(MaterialPageRoute(
                builder: (context) => new OrderDetails(
                      from: 'home',
                      order: waitingOrderList[index],
                    )));
        if (reload || !reload) {
          setState(() {});
        }
      },
      child: ContainerResponsive(
        heightResponsive: true,
        widthResponsive: true,
        height: 130,
        margin:
            EdgeInsetsResponsive.only(right: 30, left: 30, top: 10, bottom: 5),
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: Color(0xffF2F2F2)),
            borderRadius: BorderRadius.circular(5)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                ContainerResponsive(
                  heightResponsive: true,
                  widthResponsive: true,
                  width: 100,
                  height: 100,
                  margin: EdgeInsetsResponsive.symmetric(horizontal: 10),
                  child: CachedNetworkImage(
                    imageUrl: waitingOrderList[index].customerInfo != null
                        ? baseImageURL +
                            waitingOrderList[index]
                                .customerInfo
                                .image
                                .toString()
                        : '',
                    fit: BoxFit.fill,
                    placeholder: (context, url) => ImageLoad(90.0),
                    errorWidget: (context, url, error) => Image.asset(
                      'images/image404.png',
                      width: 90,
                      height: 90,
                    ),
                  ),
                ),
                ContainerResponsive(
                  heightResponsive: true,
                  widthResponsive: true,
                  margin: EdgeInsetsResponsive.symmetric(horizontal: 10),
                  child: ContainerResponsive(
                      heightResponsive: true,
                      widthResponsive: true,
                      margin: EdgeInsetsResponsive.only(right: 15),
                      child: Text(
                        waitingOrderList[index].customerInfo != null
                            ? '${waitingOrderList[index].customerInfo?.firstName}'
                            : 'unknown'.tr(),
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
                        textAlign: TextAlign.right,
                      )),
                )
              ],
            ),
            Row(
              children: [
                Container(
                  height: 50,
                  color: Colors.grey[500],
                  width: .5,
                ),
                SizedBoxResponsive(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                        child: ContainerResponsive(
                      heightResponsive: true,
                      widthResponsive: true,
                      margin: EdgeInsetsResponsive.symmetric(horizontal: 10),
                      child: TextResponsive(
                        'orderNumber'.tr(),
                        style: TextStyle(
                            fontSize: 24,
                            color: Theme.of(context).accentColor,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                    SizedBoxResponsive(
                      height: 20,
                    ),
                    Center(
                        child: Padding(
                      padding: EdgeInsetsResponsive.all(5),
                      child: TextResponsive(
                        '${waitingOrderList[index].id}',
                        style: TextStyle(fontSize: 21),
                      ),
                    ))
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  var prefs;

  showShowCase() async {
    var prefs = await SharedPreferences.getInstance();
    var firstTime = prefs.getBool('firstTime');
    if (firstTime != false) {
      ShowCaseWidget.of(context).startShowCase([showCaseOne, showcaseFive]);
    }
  }

  _getShopReport() async {
    try {
      String _id = shop.id.toString();
      final response =
          await http.get(Uri.parse(baseURL + 'shopReports&shop=$_id'));
      log('shop report url: ' + baseURL + 'shopReports&shop=$_id');
      shopReport = shopReportFromJson(response.body);
      print(shopReport.data.totalCount.toString());
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

  _getOrderHistory() async {
    try {
      prefs = await SharedPreferences.getInstance();
      String _id = shop.id.toString();
      var response =
          await dioClient.get(baseURL + 'shopOrderHistorey/shopId=$_id');
      log('shop order history url: ' +
          baseURL +
          'shopOrderHistorey/shopId=$_id');

      allOrderList = [];
      waitingOrderList = [];
      preparingOrderList = [];
      doneOrderList = [];

      allOrderList.clear();
      waitingOrderList.clear();
      preparingOrderList.clear();
      doneOrderList.clear();
      nextPage = response.data['next_page_url'];
      var data = response.data['data'];
      var shops = data as List;

      shops.forEach((v) {
        allOrderList.add(OrderInfo.fromJson(v));
      });

      allOrderList.forEach((order) {
        if (order.state == '1') {
          waitingOrderList.add(order);
        } else if (order.state == '2') {
          preparingOrderList.add(order);
        } else if (order.state == '3') {
          doneOrderList.add(order);
        }
      });

      if (this.mounted) {
        setState(() {
          load += 1;
          if (waitingOrderList.length < 10 && nextPage != null) {
            getMoreOrders();
          }
        });
      }

      print(waitingOrderList.length);
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

  getMoreOrders() async {
    if (nextPage != null) {
      if (mounted) {
        setState(() {
          loading2 = true;
        });
      }
      var response = await Dio().get(nextPage);
      var data = response.data['data'];
      nextPage = response.data['next_page_url'];
      var newOrders = data as List;
      newOrders.forEach((v) {
        allOrderList.add(OrderInfo.fromJson(v));
      });
      allOrderList.forEach((order) {
        if (order.state == '1') {
          waitingOrderList.add(order);
        } else if (order.state == '2') {
          preparingOrderList.add(order);
        } else if (order.state == '3') {
          doneOrderList.add(order);
        }
      });
    }
    if (mounted) {
      setState(() {
        loading2 = false;
      });
    }
  }

  _getMyProducts() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      var response = await dioClient
          .get(baseURL + 'getMyshopProducts/${pref.getString('user_id')}/id');

      myProducts = [];

      var data = response.data;
      var products = data as List;
      print('DATA $products');

      products.forEach((v) {
        myProducts.add(Product.fromJson(v));
      });

      if (this.mounted) {
        setState(() {
          load += 1;
          print(load);
        });
      }
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

  homeLoad() {
    return Column(
      children: <Widget>[
        SizedBoxResponsive(
          height: 70,
        ),
        SizedBoxResponsive(
          height: 80,
          child: ContainerResponsive(
            margin: EdgeInsetsResponsive.symmetric(horizontal: 30),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextResponsive(
                  'mainMenu'.tr(),
                  style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.w300,
                      color: Color(0xff575757)),
                ),
                ContainerResponsive(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NotificationPage()));
                        },
                        child: Showcase(
                          key: showcaseFive,
                          overlayOpacity: 0.9,
                          textColor: Colors.white,
                          showcaseBackgroundColor:
                              Theme.of(context).primaryColor,
                          overlayColor: Theme.of(context).accentColor,
                          description: 'ordersShowCase'.tr(),
                          disableAnimation: false,
                          child: ContainerResponsive(
                              width: 50,
                              height: 50,
                              child: Icon(
                                Icons.notifications_none,
                                size: ScreenUtil().setSp(50).toDouble(),
                                color: Theme.of(context).accentColor,
                              )),
                        ),
                      ),
                      SizedBoxResponsive(width: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Center(child: Load(150.0))
      ],
    );
  }

  Future getShopData(var userId) async {
    var pref = await SharedPreferences.getInstance();
    var id = pref.getString('user_id');
    log('========================>>>>>  $id  <<<<<<<<<============');
    log('========================>>>>>  $userId  <<<<<<<<<============');
    try {
      var response =
          await dioClient.get(baseURL + 'getMyShops/OrderBy&iddealerId&$id');
      if (response.data != '') {
        var data = response.data;
        shop = Shop.fromJson(data);
        print(bottomSelectedIndex);
        setState(() {
          load++;
        });
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
                      customerId: id,
                    )));
      }
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
    load = 0;
    getShopData('');
    _getOrderHistory();
    _getShopReport();
    controller.addListener(() {
      if ((controller.position.pixels == controller.position.maxScrollExtent &&
          loading2 == false)) {
        setState(() {
          loading2 = true;
        });
        getMoreOrders();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveWidgets.init(context,
        height: 1560, width: 720, allowFontScaling: true);

    final height = MediaQuery.of(context).size.height / 100;

    return ResponsiveWidgets.builder(
      height: 1560,
      width: 720,
      allowFontScaling: true,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: load < 2
            ? homeLoad()
            : Stack(
                children: [
                  Column(
                    children: <Widget>[
                      SizedBoxResponsive(
                        height: 70,
                      ),
                      SizedBoxResponsive(
                        height: 80,
                        child: ContainerResponsive(
                          margin:
                              EdgeInsetsResponsive.symmetric(horizontal: 30),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () async {
                                  // Navigator.of(context).push(MaterialPageRoute(
                                  //     builder: (context) => Vid()));
                                },
                                child: TextResponsive(
                                  'mainMenu'.tr(),
                                  style: TextStyle(
                                      fontSize: 50,
                                      fontWeight: FontWeight.w300,
                                      color: Color(0xff575757)),
                                ),
                              ),
                              ContainerResponsive(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    NotificationPage()));
                                      },
                                      child: Showcase(
                                        key: showcaseFive,
                                        overlayOpacity: 0.9,
                                        textColor: Colors.white,
                                        showcaseBackgroundColor:
                                            Theme.of(context).primaryColor,
                                        overlayColor:
                                            Theme.of(context).accentColor,
                                        description: 'hereCustomerOrders'.tr(),
                                        disableAnimation: false,
                                        child: Icon(
                                          Icons.notifications_none,
                                          size:
                                              ScreenUtil().setSp(50).toDouble(),
                                          color: Theme.of(context).accentColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: waitingOrderList.isEmpty
                            ? Padding(
                                padding: EdgeInsets.only(bottom: 18.0),
                                child: Showcase(
                                    key: showCaseOne,
                                    overlayOpacity: 0.9,
                                    shapeBorder: CircleBorder(),
                                    textColor: Colors.white,
                                    showcaseBackgroundColor:
                                        Theme.of(context).primaryColor,
                                    overlayColor: Theme.of(context).accentColor,
                                    description: 'hereCustomerOrders'.tr(),
                                    disableAnimation: false,
                                    child: EmptyWidget()),
                              )
                            : Padding(
                                padding: EdgeInsets.only(bottom: 18.0),
                                child: Showcase(
                                  key: showCaseOne,
                                  overlayOpacity: 0.9,
                                  shapeBorder: CircleBorder(),
                                  textColor: Colors.white,
                                  showcaseBackgroundColor:
                                      Theme.of(context).primaryColor,
                                  overlayColor: Theme.of(context).accentColor,
                                  description: 'customersOrders'.tr(),
                                  disableAnimation: false,
                                  child: ListView.builder(
                                    controller: controller,
                                    itemBuilder: (context, index) =>
                                        _orderRow(context, index, height * 12),
                                    itemCount: waitingOrderList.length,
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                  loading2 == true
                      ? Positioned(
                          bottom: 10,
                          child: Container(
                              width: MediaQuery.of(context).size.width,
                              child:
                                  Center(child: CupertinoActivityIndicator())))
                      : ContainerResponsive(),
                ],
              ),
      ),
    );
  }
}
