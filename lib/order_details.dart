import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mplus_provider/globals.dart';
import 'package:mplus_provider/models/cart_products.dart';
import 'package:mplus_provider/models/order_info.dart';
import 'package:mplus_provider/setting_pages/notification_page.dart';
import 'package:mplus_provider/ui/widgets/loading.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:easy_localization/easy_localization.dart';

import 'custom_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

import 'location_screen.dart';
import 'models/driver_info.dart';
import 'models/shops.dart';
import 'newChat.dart';

class OrderDetails extends StatefulWidget {
  final from;
  final OrderInfo order;
  OrderDetails({this.from, this.order});

  @override
  _OrderDetailsState createState() =>
      _OrderDetailsState(from: from, order: order);
}

class _OrderDetailsState extends State<OrderDetails>
    with TickerProviderStateMixin {
  var from;
  OrderInfo order;
  _OrderDetailsState({this.from, this.order});

  void _onDial(String ph) async {
    final url = 'tel:$ph';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  var _showOrderDetails = false;
  var _isOrderVisible = false;
  var _driverInfo = false;

  var _showClientDetails = false;
  var _showdriverDetails = false;
  var _isClientVisible = false;
  var _isdriverVisible = false;
  var _isDriverInfo = false;
  var address = '';
  var lat;
  var lng;

  // var stateTitle = 'تم تجهييز الطلب';
  var stateTitle = 'theOrderHasBeenProcessed';

  _getOrderHistory() async {
    try {
      String _id = shop.id.toString();
      var response =
          await dioClient.get(baseURL + 'shopOrderHistorey/shop&$_id');

      allOrderList = [];
      waitingOrderList = [];
      preparingOrderList = [];
      doneOrderList = [];

      allOrderList.clear();
      waitingOrderList.clear();
      preparingOrderList.clear();
      doneOrderList.clear();
      var data = response.data;
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

      print('WAITING ${waitingOrderList.length}');
      print('Preparing ${waitingOrderList.length}');
      print('Done ${waitingOrderList.length}');

      if (this.mounted) {
        setState(() {
          print('ORDER LENGHT ${allOrderList.length}');
        });
      }

      print(waitingOrderList.length);
    } on DioError catch (error) {
      _getOrderHistory();
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

  shopRow([BuildContext context, int index, double height]) {
    return Container(
      height: height,
      margin: EdgeInsets.only(right: 20, left: 20, top: 5, bottom: 5),
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: Color(0xffF2F2F2)),
          borderRadius: BorderRadius.circular(5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: 75,
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: Colors.white,
                border:
                    Border(left: BorderSide(color: Colors.black12, width: 2))),
            child: IconButton(
              icon: Icon(
                Icons.message,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Chat(
                        from: 'details',
                        to: 'driver',
                        status: order.state,
                        orderId: order.id.toString(),
                        targetId: driverInfo.id.toString(),
                        targetName: driverInfo.firstName.toString(),
                        targetImage: driverInfo.image.toString())));
              },
            ),
          ),
          Container(
            width: 60,
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                    child: Text(
                  'orderNumber'.tr(),
                  style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.bold),
                )),
                Center(
                    child: Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Text(
                    order.id.toString(),
                    style: TextStyle(fontSize: 13),
                  ),
                ))
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 0, top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(left: 8),
                          child: Text(
                            driverInfo.firstName.toString(),
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                            ),
                          )),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 0, left: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              driverInfo.rate?.toString() ?? '5',
                              style: TextStyle(fontSize: 10),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            new StarRating(
                              rating: driverInfo.rate != null
                                  ? double.parse(driverInfo.rate.toString())
                                  : 5.0,
                              size: 15,
                              color: Color(0xffFAC917),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 50,
                  height: 50,
                  margin: EdgeInsets.only(left: 5),
                  child: CachedNetworkImage(
                    imageUrl: baseImageURL + driverInfo.image.toString(),
                    fit: BoxFit.cover,
                    placeholder: (context, url) => ImageLoad(50.0),
                    errorWidget: (context, url, error) => Image.asset(
                      'images/image404.png',
                      width: 50,
                      height: 50,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  accept(String orderId) async {
    try {
      var response = await dioClient
          .get(baseURL + 'setOrderState/orderId&$orderId/stateId&2');
      var data = response.data;
      order = OrderInfo.fromJson(data);
      setState(() {
        stateId = int.parse(order.state);
      });
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: "offerAccepted".tr(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.white,
            textColor: Color(0xff34C961),
            fontSize: 15.0);
        _getOrderHistory();
        Navigator.pop(context);
        setState(() {
          bottomSelectedIndex = 3;
          repetNoti = ValueNotifier(false);
        });
        // Navigator.pushReplacement(
        //     context, MaterialPageRoute(builder: (context) => Home()));
      } else {
        Fluttertoast.showToast(
            msg: 'linkedUpInTheNetworks'.tr(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
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

  DriverInfo driverInfo;
  Shop shopInfo;
  int isLoading = 0;
  _getDriverInfo() async {
    try {
      var response =
          await dioClient.get(baseURL + 'DeliveryInfo/orderId&${order.id}');

      var data = response.data;
      lat = response.data["Data"]["end_latitude"];
      lng = response.data["Data"]["end_longitude"];
      print('DATA $data');
      if (data['Data']['DriverInfo'] != null) {
        driverInfo = DriverInfo.fromJson(data['Data']['DriverInfo']);
        address = data['Data']['address'];
      }
      if (data['Data']['OrderInfo']['ShopInfo'] != null) {
        shopInfo = Shop.fromJson(data['Data']['OrderInfo']['ShopInfo']);
      }

      setState(() {
        isLoading++;
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

  var pay = 0;

  Future getOrderInfo(int id) async {
    try {
      var response = await Dio().get(baseURL + 'DeliveryInfo/orderId&$id');
      var data = response.data;
      if (data['Data'] != null) {
        pay = data['Data']['OrderInfo']['paymentMethod'];
        lat = response.data["Data"]["end_latitude"];
        lng = response.data["Data"]["end_longitude"];
        setState(() {
          isLoading++;
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

  double tax = 0.0;
  int stateId;
  ProgressDialog _pr;
  List<CartProdcuts> parents = [];
  List<CartProdcuts> children = [];

  @override
  void initState() {
    if (int.parse(order.state) > 1) {
      _getDriverInfo();
    } else {
      isLoading++;
    }
    getOrderInfo(order.id);
    _pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    _pr.style(
        message: 'pleaseWait'.tr(),
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));

    super.initState();
    if (order.totalValue != null) {
      tax = ((order.taxOne + order.taxTwo) * order.totalValue);
    }
    stateId = int.parse(order.state).toInt();
    for (int i = 0; i < order.cartProdcuts.length; i++) {
      if (order.cartProdcuts[i].parent == 0) {
        parents.add(order.cartProdcuts[i]);
      } else {
        children.add(order.cartProdcuts[i]);
      }
    }
  }

  preparingFinish(String orderId) async {
    try {
      var response = await dioClient
          .get(baseURL + 'setOrderState/orderId&$orderId/stateId&3');
      print('RESPONSE ${response.data}');
      var data = response.data;
      order = OrderInfo.fromJson(data);
      setState(() {
        stateId = int.parse(order.state);
      });
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: "requestProcessedSuccessfully".tr(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.white,
            textColor: Color(0xff34C961),
            fontSize: 15.0);
        Navigator.pop(context);
        _getOrderHistory();
      } else {
        Fluttertoast.showToast(
            msg: 'linkedUpInTheNetworks'.tr(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
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

  _cartItem(bool child, int index, List<CartProdcuts> list) {
    return ContainerResponsive(
        decoration:
            BoxDecoration(border: Border.all(width: 1, color: Colors.black)),
        margin: EdgeInsetsResponsive.only(
            top: 5,
            right: child ? 10 : 0,
            left: child ? 10 : 0,
            bottom: child ? 5 : 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            ContainerResponsive(
              width: 200,
              child: Center(
                  child: TextResponsive(
                list[index].productName.toString(),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: list[index].productName.toString().length > 20
                        ? 18
                        : 25,
                    color: Color(0xff575757)),
              )),
            ),
            ContainerResponsive(height: 20, width: 1, color: Colors.grey[600]),
            ContainerResponsive(
              width: 100,
              child: Container(
                margin: EdgeInsetsResponsive.only(top: 5, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ContainerResponsive(
                      child: Center(
                        child: TextResponsive(
                          list[index].quantity == null
                              ? '1'
                              : list[index].quantity.toString(),
                          style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ContainerResponsive(height: 20, width: 1, color: Colors.grey[600]),
            ContainerResponsive(
              width: 100,
              margin: EdgeInsetsResponsive.only(top: 5, bottom: 5),
              child: Center(
                  child: Text(
                list[index].price.toStringAsFixed(2),
                style: TextStyle(
                    fontSize: 15, color: Theme.of(context).primaryColor),
              )),
            ),
            !child
                ? Container()
                : ContainerResponsive(
                    height: 20, width: 1, color: Colors.grey[600]),
            !child
                ? Container()
                : ContainerResponsive(
                    width: 200,
                    child: Center(
                        child: TextResponsive(
                            context.locale == Locale('en')
                                ? list[index].section.toString()
                                : list[index].sectionAr.toString(),
                            style: TextStyle(
                                fontSize: context.locale == Locale('en')
                                    ? list[index].section.toString().length > 20
                                        ? 20
                                        : 25
                                    : list[index].sectionAr.toString().length >
                                            20
                                        ? 20
                                        : 25,
                                color: Color(0xff575757)))),
                  ),
          ],
        ));
  }

  _orderRow([BuildContext con, int index, double height]) {
    return GestureDetector(
      child: ContainerResponsive(
        height: 130,
        margin:
            EdgeInsetsResponsive.only(left: 20, right: 20, top: 5, bottom: 5),
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: Color(0xffF2F2F2)),
            borderRadius: BorderRadius.circular(5)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ContainerResponsive(
                width: 120,
                height: 120,
                margin: EdgeInsets.only(left: 5),
                child: CachedNetworkImage(
                  imageUrl: order.customerInfo != null
                      ? baseImageURL + order.customerInfo?.image.toString()
                      : '',
                  fit: BoxFit.fill,
                  placeholder: (context, url) => ImageLoad(90.0),
                  errorWidget: (context, url, error) => Image.asset(
                    'images/image404.png',
                    width: 90,
                    height: 90,
                  ),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                ContainerResponsive(
                  margin: EdgeInsetsResponsive.only(left: 10, top: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ContainerResponsive(
                          margin: EdgeInsetsResponsive.only(left: 15),
                          child: TextResponsive(
                            order.customerInfo != null
                                ? order.customerInfo.firstName.toString()
                                : 'unknown'.tr(),
                            style: TextStyle(
                                fontSize: 28,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          )),
                      // SizedBoxResponsive(
                      //   height: 20,
                      // ),
                      ContainerResponsive(
                        margin: EdgeInsetsResponsive.only(left: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            TextResponsive(
                              order.updatedAt.toString(),
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.black,
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
            VerticalDivider(
              thickness: 1.2,
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                      child: TextResponsive(
                    'orderNumber'.tr(),
                    style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.bold),
                  )),
                  SizedBoxResponsive(
                    height: 15,
                  ),
                  Center(
                      child: Padding(
                    padding: EdgeInsetsResponsive.only(left: 13),
                    child: TextResponsive(
                      order.id.toString(),
                      style: TextStyle(fontSize: 22),
                    ),
                  ))
                ],
              ),
            ),
            VerticalDivider(
              thickness: 1.2,
            ),
            Center(
              child: IconButton(
                icon:
                    Icon(Icons.message, color: Theme.of(context).primaryColor),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Chat(
                            from: 'details',
                            to: "customer",
                            status: order.state,
                            orderId: order.id.toString(),
                            targetId: order.customerInfo.id.toString(),
                            targetName: order.customerInfo.firstName.toString(),
                            targetImage: order.customerInfo.image.toString(),
                          )));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> onWillPop() {
    Navigator.of(context).pop(true);
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveWidgets.init(
      context,
      height: 1560,
      width: 720,
      allowFontScaling: true,
    );

    return ResponsiveWidgets.builder(
      height: 1560,
      width: 720,
      allowFontScaling: true,
      child: WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: isLoading < 2
              ? Center(child: Load(150.0))
              : Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            SizedBoxResponsive(
                              height: 70,
                            ),
                            SizedBoxResponsive(
                              height: 80,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        IconButton(
                                            icon: Icon(
                                              Icons.arrow_back,
                                              color: Color(0xff575757),
                                              size: 25,
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop(true);
                                            }),
                                        GestureDetector(
                                          onTap: () async {
                                            // var response = await Dio().get(baseURL +
                                            //     'ContactDealer/orderId&${order.id}');
                                            // print(response.data);
                                          },
                                          child: TextResponsive(
                                            'orderDetails'.tr(),
                                            style: TextStyle(
                                                fontSize: 48,
                                                fontWeight: FontWeight.w300,
                                                color: Color(0xff575757)),
                                          ),
                                        ),
                                      ]),
                                  ContainerResponsive(
                                      width: 100,
                                      height: 100,
                                      child: FlatButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        NotificationPage()));
                                          },
                                          child: Icon(Icons.notifications_none,
                                              color:
                                                  Theme.of(context).accentColor,
                                              size: ScreenUtil()
                                                  .setSp(50)
                                                  .toDouble())))
                                ],
                              ),
                            ),
                            SizedBoxResponsive(
                              height: 40,
                            ),
                          ],
                        ),
                      ),
                    ),
                    ContainerResponsive(
                      margin: EdgeInsetsResponsive.only(top: 160, bottom: 50),
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            _orderRow(context),
                            SizedBoxResponsive(
                              height: 20,
                            ),
                            ContainerResponsive(
                                height: 90,
                                color: Color(0xffeeeeee),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          EdgeInsetsResponsive.only(left: 50.0),
                                      child: TextResponsive(
                                        'orderTracking'.tr(),
                                        style: TextStyle(fontSize: 35),
                                      ),
                                    )
                                  ],
                                )),
                            ContainerResponsive(
                              margin: EdgeInsetsResponsive.all(20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  ContainerResponsive(
                                    child: Column(
                                      children: <Widget>[
                                        ContainerResponsive(
                                          width: 45,
                                          height: 45,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 1,
                                                  color: Colors.black26),
                                              color: stateId > 1
                                                  ? Theme.of(context)
                                                      .primaryColor
                                                  : Colors.white,
                                              shape: BoxShape.circle),
                                          child: Center(
                                              child: Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 17,
                                          )),
                                        ),
                                        Column(
                                          children: <Widget>[
                                            ContainerResponsive(
                                              width: 2,
                                              height: 15,
                                              color: stateId > 1
                                                  ? Theme.of(context)
                                                      .primaryColor
                                                  : Colors.grey,
                                            ),
                                            SizedBoxResponsive(
                                              height: 7,
                                            ),
                                            ContainerResponsive(
                                              width: 2,
                                              height: 15,
                                              color: stateId > 1
                                                  ? Theme.of(context)
                                                      .primaryColor
                                                  : Colors.grey,
                                            ),
                                          ],
                                        ),
                                        ContainerResponsive(
                                          width: 45,
                                          height: 45,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 1,
                                                  color: Colors.black26),
                                              color: stateId > 1
                                                  ? Theme.of(context)
                                                      .primaryColor
                                                  : Colors.white,
                                              shape: BoxShape.circle),
                                          child: Center(
                                              child: Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 17,
                                          )),
                                        ),
                                        Column(
                                          children: <Widget>[
                                            ContainerResponsive(
                                              width: 2,
                                              height: 15,
                                              color: stateId > 2
                                                  ? Theme.of(context)
                                                      .primaryColor
                                                  : Colors.grey,
                                            ),
                                            SizedBoxResponsive(
                                              height: 7,
                                            ),
                                            ContainerResponsive(
                                              width: 2,
                                              height: 15,
                                              color: stateId > 2
                                                  ? Theme.of(context)
                                                      .primaryColor
                                                  : Colors.grey,
                                            ),
                                          ],
                                        ),
                                        ContainerResponsive(
                                          width: 45,
                                          height: 45,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 1,
                                                  color: Colors.black26),
                                              color: stateId > 2
                                                  ? Theme.of(context)
                                                      .primaryColor
                                                  : Colors.white,
                                              shape: BoxShape.circle),
                                          child: Center(
                                              child: Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 17,
                                          )),
                                        ),
                                        // Column(
                                        //   children: <Widget>[
                                        //     ContainerResponsive(
                                        //       width: 2,
                                        //       height: 15,
                                        //       color: stateId > 3
                                        //           ? Theme.of(context).primaryColor
                                        //           : Colors.grey,
                                        //     ),
                                        //     SizedBoxResponsive(
                                        //       height: 7,
                                        //     ),
                                        //     ContainerResponsive(
                                        //       width: 2,
                                        //       height: 15,
                                        //       color: stateId > 3
                                        //           ? Theme.of(context).primaryColor
                                        //           : Colors.grey,
                                        //     ),
                                        //   ],
                                        // ),
                                        // ContainerResponsive(
                                        //   width: 45,
                                        //   height: 45,
                                        //   decoration: BoxDecoration(
                                        //       border: Border.all(
                                        //         width: 1,
                                        //         color: Colors.black26,
                                        //       ),
                                        //       shape: BoxShape.circle,
                                        //       color: stateId > 3
                                        //           ? Theme.of(context).primaryColor
                                        //           : Colors.white),
                                        //   child: Center(
                                        //       child: Icon(
                                        //     Icons.check,
                                        //     color: Colors.white,
                                        //     size: 17,
                                        //   )),
                                        // ),
                                        // Column(
                                        //   children: <Widget>[
                                        //     ContainerResponsive(
                                        //       width: 2,
                                        //       height: 15,
                                        //       color: stateId > 4
                                        //           ? Theme.of(context).primaryColor
                                        //           : Colors.grey,
                                        //     ),
                                        //     SizedBoxResponsive(
                                        //       height: 5,
                                        //     ),
                                        //     ContainerResponsive(
                                        //       width: 2,
                                        //       height: 15,
                                        //       color: stateId > 4
                                        //           ? Theme.of(context).primaryColor
                                        //           : Colors.grey,
                                        //     ),
                                        //   ],
                                        // ),
                                        // ContainerResponsive(
                                        //   width: 45,
                                        //   height: 45,
                                        //   decoration: BoxDecoration(
                                        //       border: Border.all(
                                        //           width: 1,
                                        //           color: Colors.black26),
                                        //       color: stateId > 4
                                        //           ? Theme.of(context).primaryColor
                                        //           : Colors.white,
                                        //       shape: BoxShape.circle),
                                        //   child: Center(
                                        //       child: Icon(
                                        //     Icons.check,
                                        //     color: Colors.white,
                                        //     size: 17,
                                        //   )),
                                        // ),
                                        SizedBoxResponsive(
                                          height: 30,
                                        ),
                                      ],
                                    ),
                                  ),
                                  ContainerResponsive(
                                    margin: EdgeInsetsResponsive.only(
                                        left: 20, top: 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        ContainerResponsive(
                                          height: 80,
                                          child: Align(
                                              alignment: Alignment.topCenter,
                                              child: TextResponsive(
                                                'orderAccepted'.tr(),
                                                style: TextStyle(fontSize: 26),
                                              )),
                                        ),
                                        SizedBoxResponsive(
                                          height: 80,
                                          child: TextResponsive(
                                            'prepairingOrder'.tr(),
                                            style: TextStyle(fontSize: 26),
                                          ),
                                        ),
                                        SizedBoxResponsive(
                                          height: 80,
                                          child: TextResponsive(
                                            'orderSentCommissioner'.tr(),
                                            style: TextStyle(fontSize: 26),
                                          ),
                                        ),
                                        // SizedBoxResponsive(
                                        //   height: 80,
                                        //   child: TextResponsive(
                                        //     'deliveringOrder'.tr(),
                                        //
                                        //     style: TextStyle(fontSize: 26),
                                        //   ),
                                        // ),
                                        // SizedBoxResponsive(
                                        //   height: 80,
                                        //   child: TextResponsive(
                                        //     'orderHanded'.tr(),
                                        //
                                        //     style: TextStyle(fontSize: 26),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _showOrderDetails
                                      ? _showOrderDetails = false
                                      : _showOrderDetails = true;
                                  _isOrderVisible
                                      ? _isOrderVisible = false
                                      : _isOrderVisible = true;
                                });
                              },
                              child: ContainerResponsive(
                                  height: 90,
                                  color: Color(0xffeeeeee),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsetsResponsive.only(
                                            left: 50.0),
                                        child: TextResponsive(
                                          'orderDetails'.tr(),
                                          style: TextStyle(fontSize: 35),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsetsResponsive.only(left: 45),
                                        child: _showOrderDetails
                                            ? Icon(
                                                Icons.keyboard_arrow_up,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                size: 30,
                                              )
                                            : Icon(
                                                Icons.keyboard_arrow_down,
                                                size: 30,
                                              ),
                                      ),
                                    ],
                                  )),
                            ),
                            _isOrderVisible
                                ? Visibility(
                                    visible: _isOrderVisible,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        ContainerResponsive(
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              physics: ClampingScrollPhysics(),
                                              itemCount: parents.length,
                                              itemBuilder: (context, index) {
                                                List<CartProdcuts> childs = [];
                                                for (int i = 0;
                                                    i < children.length;
                                                    i++) {
                                                  if (children[i].parent ==
                                                      parents[index]
                                                          .productsId) {
                                                    childs.add(children[i]);
                                                  }
                                                }
                                                return ExpansionTile(
                                                    title: _cartItem(
                                                        false, index, parents),
                                                    children: [
                                                      TextResponsive(
                                                          'adds'.tr(),
                                                          style: TextStyle(
                                                              fontSize: 25,
                                                              color: Colors
                                                                  .black)),
                                                      ContainerResponsive(
                                                        child: ListView.builder(
                                                          shrinkWrap: true,
                                                          physics:
                                                              ClampingScrollPhysics(),
                                                          itemBuilder: (context,
                                                                  index) =>
                                                              _cartItem(
                                                                  true,
                                                                  index,
                                                                  childs),
                                                          itemCount:
                                                              childs.length,
                                                        ),
                                                      ),
                                                      SizedBoxResponsive(
                                                          height: 5)
                                                    ]);
                                              }),
                                        ),
                                        ContainerResponsive(
                                          color: Color(0xffF8F8F8),
                                          height: 75,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              ContainerResponsive(
                                                  margin:
                                                      EdgeInsetsResponsive.only(
                                                          left: 50),
                                                  child: TextResponsive(
                                                    'paymentMethod'.tr(),
                                                    style:
                                                        TextStyle(fontSize: 26),
                                                  ))
                                            ],
                                          ),
                                        ),
                                        SizedBoxResponsive(
                                          height: 10,
                                        ),
                                        ContainerResponsive(
                                          margin: EdgeInsetsResponsive.all(5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              ContainerResponsive(
                                                  margin:
                                                      EdgeInsetsResponsive.only(
                                                          left: 50),
                                                  child: TextResponsive(
                                                    pay == 1
                                                        ? 'payOnDelivery'.tr()
                                                        : 'online'.tr(),
                                                    style:
                                                        TextStyle(fontSize: 26),
                                                  )),
                                            ],
                                          ),
                                        ),
                                        SizedBoxResponsive(
                                          height: 10,
                                        ),
                                        ContainerResponsive(
                                          color: Color(0xffF8F8F8),
                                          height: 70,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              ContainerResponsive(
                                                  margin:
                                                      EdgeInsetsResponsive.only(
                                                          left: 50),
                                                  child: TextResponsive(
                                                    'handingDetails'.tr(),
                                                    style:
                                                        TextStyle(fontSize: 26),
                                                  ))
                                            ],
                                          ),
                                        ),
                                        ContainerResponsive(
                                          margin: EdgeInsetsResponsive.only(
                                              top: 20, left: 50),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    EdgeInsetsResponsive.only(
                                                        left: 0.0),
                                                child: TextResponsive(
                                                  'handingLocation'.tr(),
                                                  style: TextStyle(
                                                      color: Color(0xff616161),
                                                      fontSize: 26),
                                                ),
                                              ),
                                              SizedBoxResponsive(
                                                height: 10,
                                              ),
                                              ContainerResponsive(
                                                margin:
                                                    EdgeInsetsResponsive.only(
                                                        top: 15),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.of(context).push(MaterialPageRoute(
                                                            builder: (context) =>
                                                                ProductLocation(
                                                                    latLng:
                                                                        LatLng(
                                                                            lat,
                                                                            lng),
                                                                    from:
                                                                        'order')));
                                                      },
                                                      child: TextResponsive(
                                                          '(' +
                                                              'viewLocation'
                                                                  .tr() +
                                                              ')',
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor)),
                                                    ),
                                                    SizedBoxResponsive(
                                                      width: 30,
                                                    ),
                                                    TextResponsive(
                                                      address,
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          color: Color(
                                                              0xff707070)),
                                                    ),
                                                    SizedBoxResponsive(
                                                      width: 10,
                                                    ),
                                                    Icon(
                                                      Icons.location_on,
                                                      size: 13,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBoxResponsive(
                                          height: 10,
                                        ),
                                        ContainerResponsive(
                                          height: 2,
                                          margin: EdgeInsetsResponsive.only(
                                              left: 40, right: 40),
                                          color: Color(0xffE4DEDE),
                                        ),
                                        SizedBoxResponsive(
                                          height: 20,
                                        ),
                                        ContainerResponsive(
                                          margin: EdgeInsetsResponsive.only(
                                              top: 10, left: 50),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsResponsive
                                                            .only(left: 0.0),
                                                    child: TextResponsive(
                                                      'deliveryTime'.tr(),
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xff616161),
                                                          fontSize: 26),
                                                    ),
                                                  ),
                                                  SizedBoxResponsive(
                                                    height: 10,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsResponsive
                                                            .only(left: 0.0),
                                                    child: TextResponsive(
                                                        order.time
                                                            .toString()
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            color: Color(
                                                                0xff818181))),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBoxResponsive(
                                          height: 10,
                                        ),
                                        ContainerResponsive(
                                          height: 2,
                                          margin: EdgeInsetsResponsive.only(
                                              left: 40, right: 40),
                                          color: Color(0xffE4DEDE),
                                        ),
                                        SizedBoxResponsive(
                                          height: 20,
                                        ),
                                        ContainerResponsive(
                                          margin: EdgeInsetsResponsive.only(
                                              top: 10, left: 50),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsResponsive
                                                            .only(left: 0.0),
                                                    child: TextResponsive(
                                                      order.shopInfo == null
                                                          ? 'TAX 1'
                                                          : context.locale ==
                                                                  Locale('en')
                                                              ? order.shopInfo
                                                                  .taxOneName
                                                                  .toString()
                                                              : order.shopInfo
                                                                  .taxOneNameAr
                                                                  .toString(),
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xff616161),
                                                          fontSize: 26),
                                                    ),
                                                  ),
                                                  SizedBoxResponsive(
                                                    height: 10,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsResponsive
                                                            .only(left: 0.0),
                                                    child: TextResponsive(
                                                        order.shopInfo == null
                                                            ? '0.0 %'
                                                            : '${order.shopInfo.taxOne} %',
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            color: Color(
                                                                0xff818181))),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBoxResponsive(
                                          height: 10,
                                        ),
                                        ContainerResponsive(
                                          height: 2,
                                          margin: EdgeInsetsResponsive.only(
                                              left: 40, right: 40),
                                          color: Color(0xffE4DEDE),
                                        ),
                                        SizedBoxResponsive(
                                          height: 20,
                                        ),
                                        ContainerResponsive(
                                          margin: EdgeInsetsResponsive.only(
                                              top: 10, left: 50),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsResponsive
                                                            .only(left: 0.0),
                                                    child: TextResponsive(
                                                      order.shopInfo == null
                                                          ? 'TAX 2'
                                                          : context.locale ==
                                                                  Locale('en')
                                                              ? order.shopInfo
                                                                  .taxTwoName
                                                                  .toString()
                                                              : order.shopInfo
                                                                  .taxTwoNameAr
                                                                  .toString(),
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xff616161),
                                                          fontSize: 26),
                                                    ),
                                                  ),
                                                  SizedBoxResponsive(
                                                    height: 10,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsResponsive
                                                            .only(left: 0.0),
                                                    child: TextResponsive(
                                                        order.shopInfo == null
                                                            ? '0.0 %'
                                                            : '${order.shopInfo.taxTwo} %',
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            color: Color(
                                                                0xff818181))),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBoxResponsive(
                                          height: 10,
                                        ),
                                        ContainerResponsive(
                                          height: 2,
                                          margin: EdgeInsetsResponsive.only(
                                              left: 40, right: 40),
                                          color: Color(0xffE4DEDE),
                                        ),
                                        SizedBoxResponsive(
                                          height: 20,
                                        ),
                                        ContainerResponsive(
                                          color: Color(0xffF8F8F8),
                                          height: 80,
                                          padding: EdgeInsetsResponsive.all(16),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              ContainerResponsive(
                                                  margin:
                                                      EdgeInsetsResponsive.only(
                                                          left: 50),
                                                  child: TextResponsive(
                                                    'deliveryPrice'.tr(),
                                                    style:
                                                        TextStyle(fontSize: 26),
                                                  )),
                                              ContainerResponsive(
                                                  margin:
                                                      EdgeInsetsResponsive.only(
                                                          left: 50),
                                                  child: TextResponsive(
                                                    order.delivery
                                                            .toStringAsFixed(
                                                                2) +
                                                        " " +
                                                        'sr'.tr(),
                                                    style: TextStyle(
                                                        fontSize: 26,
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                  )),
                                            ],
                                          ),
                                        ),
                                        ContainerResponsive(
                                          color: Color(0xffF8F8F8),
                                          height: 80,
                                          padding: EdgeInsetsResponsive.all(16),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              ContainerResponsive(
                                                  margin:
                                                      EdgeInsetsResponsive.only(
                                                          left: 50),
                                                  child: TextResponsive(
                                                    'totalTax'.tr(),
                                                    style:
                                                        TextStyle(fontSize: 26),
                                                  )),
                                              ContainerResponsive(
                                                  margin:
                                                      EdgeInsetsResponsive.only(
                                                          left: 50),
                                                  child: TextResponsive(
                                                    tax.toStringAsFixed(2) +
                                                        " " +
                                                        'sr'.tr(),
                                                    style: TextStyle(
                                                        fontSize: 26,
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                  )),
                                            ],
                                          ),
                                        ),
                                        ContainerResponsive(
                                          color: Color(0xffF8F8F8),
                                          height: 80,
                                          padding: EdgeInsetsResponsive.all(16),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              ContainerResponsive(
                                                  margin:
                                                      EdgeInsetsResponsive.only(
                                                          left: 50),
                                                  child: TextResponsive(
                                                    'VAT'.tr(),
                                                    style:
                                                        TextStyle(fontSize: 26),
                                                  )),
                                              ContainerResponsive(
                                                  margin:
                                                      EdgeInsetsResponsive.only(
                                                          left: 50),
                                                  child: TextResponsive(
                                                    '${(order.totalValue * 0.05).toStringAsFixed(2)}' +
                                                        " " +
                                                        'sr'.tr(),
                                                    style: TextStyle(
                                                        fontSize: 26,
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                  )),
                                            ],
                                          ),
                                        ),
                                        ContainerResponsive(
                                          color: Color(0xffF8F8F8),
                                          height: 80,
                                          padding: EdgeInsetsResponsive.all(16),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              ContainerResponsive(
                                                  margin:
                                                      EdgeInsetsResponsive.only(
                                                          left: 50),
                                                  child: TextResponsive(
                                                    'total'.tr(),
                                                    style:
                                                        TextStyle(fontSize: 26),
                                                  )),
                                              ContainerResponsive(
                                                  margin:
                                                      EdgeInsetsResponsive.only(
                                                          left: 50),
                                                  child: TextResponsive(
                                                    order.totalValue != null
                                                        ? (order.totalValue +
                                                                    (order.totalValue *
                                                                        0.05) +
                                                                    tax +
                                                                    order
                                                                        .delivery)
                                                                .toStringAsFixed(
                                                                    2) +
                                                            " " +
                                                            'sr'.tr()
                                                        : "0.00" +
                                                            " " +
                                                            'sr'.tr(),
                                                    style: TextStyle(
                                                        fontSize: 26,
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                  )),
                                            ],
                                          ),
                                        ),
                                        SizedBoxResponsive(
                                          height: 20,
                                        ),
                                      ],
                                    ),
                                  )
                                : ContainerResponsive(),
                            SizedBoxResponsive(
                              height: 20,
                            ),
                            driverInfo != null
                                ? Column(
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _showdriverDetails
                                                ? _showdriverDetails = false
                                                : _showdriverDetails = true;
                                            _isdriverVisible
                                                ? _isdriverVisible = false
                                                : _isdriverVisible = true;
                                          });
                                        },
                                        child: ContainerResponsive(
                                            height: 90,
                                            color: Color(0xffeeeeee),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      EdgeInsetsResponsive.only(
                                                          left: 45.0),
                                                  child: TextResponsive(
                                                    'commissionerDetails'.tr(),
                                                    style:
                                                        TextStyle(fontSize: 35),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      EdgeInsetsResponsive.only(
                                                          left: 45),
                                                  child: _showdriverDetails
                                                      ? Icon(
                                                          Icons
                                                              .keyboard_arrow_up,
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          size: 30,
                                                        )
                                                      : Icon(
                                                          Icons
                                                              .keyboard_arrow_down,
                                                          size: 30,
                                                        ),
                                                ),
                                              ],
                                            )),
                                      ),
                                      _isdriverVisible
                                          ? Visibility(
                                              visible: _isdriverVisible,
                                              child: shopRow(context))
                                          : Container(),
                                    ],
                                  )
                                : Container(),
                            SizedBoxResponsive(
                              height: 20,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _showClientDetails
                                      ? _showClientDetails = false
                                      : _showClientDetails = true;
                                  _isClientVisible
                                      ? _isClientVisible = false
                                      : _isClientVisible = true;
                                });
                              },
                              child: ContainerResponsive(
                                  height: 90,
                                  color: Color(0xffeeeeee),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsetsResponsive.only(
                                            left: 45.0),
                                        child: TextResponsive(
                                          'customerDetails'.tr(),
                                          style: TextStyle(fontSize: 35),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsetsResponsive.only(left: 45),
                                        child: _showClientDetails
                                            ? Icon(
                                                Icons.keyboard_arrow_up,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                size: 30,
                                              )
                                            : Icon(
                                                Icons.keyboard_arrow_down,
                                                size: 30,
                                              ),
                                      ),
                                    ],
                                  )),
                            ),
                            _isClientVisible
                                ? Visibility(
                                    visible: _isClientVisible,
                                    child: Column(
                                      children: <Widget>[
                                        SizedBoxResponsive(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            ContainerResponsive(
                                              margin: EdgeInsetsResponsive.only(
                                                  left: 50, top: 20),
                                              child: TextResponsive(
                                                'customerName'.tr(),
                                                style: TextStyle(
                                                    fontSize: 26,
                                                    color: Theme.of(context)
                                                        .accentColor,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            )
                                          ],
                                        ),
                                        ContainerResponsive(
                                          margin: EdgeInsetsResponsive.only(
                                              left: 50, top: 20),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              GestureDetector(
                                                onTap: () {
                                                  _onDial(order
                                                      .customerInfo.loginPhone
                                                      .toString());
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.phone,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      size: 25,
                                                    ),
                                                    SizedBoxResponsive(
                                                      width: 10,
                                                    ),
                                                    TextResponsive('call'.tr(),
                                                        style: TextStyle(
                                                            fontSize: 26))
                                                  ],
                                                ),
                                              ),
                                              SizedBoxResponsive(
                                                width: 100,
                                              ),
                                              TextResponsive(
                                                  order.customerInfo?.firstName
                                                      .toString(),
                                                  style:
                                                      TextStyle(fontSize: 26)),
                                            ],
                                          ),
                                        ),
                                        SizedBoxResponsive(
                                          height: 40,
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(),
                            SizedBoxResponsive(
                              height: 20,
                            ),

                            /*Visibility(
                          visible:stateId == 2 ? true : false,
                          child: GestureDetector(
                            onTap: (){
                              setState(() {
                                _driverInfo ? _driverInfo = false : _driverInfo = true;
                                _isDriverInfo ? _isDriverInfo = false : _isDriverInfo = true;
                              });
                            },
                            child: Container(
                                height: 50,
                                color: Color(0xffeeeeee),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[

                                    Padding(
                                      padding: const EdgeInsets.only(left: 25),
                                      child: _isDriverInfo
                                          ? Icon(
                                        Icons.keyboard_arrow_up,
                                        color: Colors.green,
                                        size: 30,

                                      )
                                          : Icon(
                                        Icons.keyboard_arrow_down,
                                        size: 30,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 30.0),
                                      child: Text(
                                        'تفاصيل المندوب',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),

                                  ],
                                )
                            ),
                          ),
                        ),
                        _isDriverInfo
                            ? Visibility(
                          visible: _isDriverInfo,
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 2,
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    margin:EdgeInsets.only(left: 15,top: 10),
                                    child: Text('اسم المندوب',style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xff34C961),
                                        fontWeight: FontWeight.bold),),
                                  )
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 25,top: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Icon(Icons.phone,color: Color(0xff34C961),size: 25,),
                                        SizedBox(width: 5,),
                                        Text('إجراء مكالمه')
                                      ],
                                    ),
                                    SizedBox(width: 50,),
                                    Text('حسن الجوهري'),
                                  ],
                                ),
                              ),

                              SizedBox(height: 20,),


                            ],
                          ),
                        )
                            : Container(),*/
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        child: stateId > 1
                            ? GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        CustomDialog(
                                      type: 'loading',
                                    ),
                                  );
                                  preparingFinish('${order.id}');
                                  /*setState(() {
                          if(stateId < 6){
                            stateId++;
                          }
                          if(stateId == 6){
                            setState(() {
                              bottomSelectedIndex = 3;
                            });
                            prefix0.Navigator.pop(context);
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) => Home()));
                          }
                          if(stateId  == 2){
                            stateTitle = 'جارى تجهيز الطلب';
                            _driverInfo = true;
                          }
                          else if(stateId  == 3){
                            stateTitle = 'تم إرسال الطلب للمندوب';
                            _driverInfo = false;
                          }
                          else if(stateId  == 4){
                            stateTitle = 'جارى التوصيل الطلب';
                          }
                          else if(stateId  == 5){
                            stateTitle = 'العودة للرئيسية';
                          }
                        });*/
                                },
                                child: stateId != 3
                                    ? Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                100 *
                                                100,
                                        height: 50,
                                        decoration: BoxDecoration(
                                            color:
                                                Theme.of(context).primaryColor,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(30),
                                                topRight: Radius.circular(30))),
                                        child: Center(
                                          child: Text(
                                            '$stateTitle',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ).tr(),
                                        ),
                                      )
                                    : Container(),
                              )
                            : ContainerResponsive(
                                width: 720,
                                height: 90,
                                child: Row(
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          repetNoti = ValueNotifier(false);
                                          repetNoti.value = false;
                                        });
                                      },
                                      child: ContainerResponsive(
                                        width: 720 / 2,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(30),
                                          ),
                                          color: Theme.of(context).accentColor,
                                        ),
                                        child: Center(
                                          child: TextResponsive(
                                            'iDecline'.tr(),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 35),
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              CustomDialog(
                                            type: 'loading',
                                          ),
                                        );
                                        accept('${order.id}');
                                        print('amjed : ${order.id}');
                                      },
                                      child: ContainerResponsive(
                                        width: 720 / 2,
                                        height: 90,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(30)),
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        child: Center(
                                          child: TextResponsive(
                                            'iAccept'.tr(),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 35),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
