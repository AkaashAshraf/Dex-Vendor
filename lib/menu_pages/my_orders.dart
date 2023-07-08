import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mplus_provider/empty_widget.dart';
import 'package:mplus_provider/globals.dart';
import 'package:mplus_provider/models/order_info.dart';
import 'package:mplus_provider/setting_pages/notification_page.dart';
import 'package:mplus_provider/ui/widgets/loading.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import '../order_details.dart';

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  var width, height;

  _prepareOrderRow([var context, var index, var height]) {
    return GestureDetector(
      onTap: () async {
        bool done = await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => new OrderDetails(
                  from: 'orders',
                  order: preparingOrderList[index],
                )));
        if (done || !done) {
          setState(() {});
        }
      },
      child: ContainerResponsive(
        height: 130,
        margin:
            EdgeInsetsResponsive.only(right: 20, left: 20, top: 15, bottom: 5),
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: Color(0xffF2F2F2)),
            borderRadius: BorderRadius.circular(5)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                ContainerResponsive(
                    width: 100,
                    height: 100,
                    margin: EdgeInsetsResponsive.symmetric(horizontal: 10),
                    child: CachedNetworkImage(
                      imageUrl: baseImageURL +
                          preparingOrderList[index]
                              .customerInfo
                              .image
                              .toString(),
                      fit: BoxFit.fill,
                      placeholder: (context, url) => ImageLoad(90.0),
                      errorWidget: (context, url, error) => Image.asset(
                        'images/image404.png',
                        width: 90,
                        height: 90,
                      ),
                    )),
                Container(
                  margin: EdgeInsets.only(left: 5, top: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            '${preparingOrderList[index].customerInfo?.firstName ?? "unkown".tr()}',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.left,
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              preparingOrderList[index].createdAt.toString(),
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
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
                    ContainerResponsive(
                      child: Center(
                          child: Text(
                        'orderNumber'.tr(),
                        style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).accentColor,
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                        child: Padding(
                      padding: EdgeInsetsResponsive.all(5.0),
                      child: Text(
                        '${preparingOrderList[index].id}',
                        style: TextStyle(fontSize: 13),
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

  _doneOrderRow([var context, var index, var height]) {
    return GestureDetector(
      onTap: () async {
        bool done = await Navigator.of(context, rootNavigator: true)
            .push(MaterialPageRoute(
                builder: (context) => OrderDetails(
                      from: 'orders',
                      order: doneOrderList[index],
                    )));
        if (done || !done) {
          setState(() {});
        }
      },
      child: ContainerResponsive(
        height: 130,
        margin:
            EdgeInsetsResponsive.only(right: 20, left: 20, top: 5, bottom: 5),
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: Color(0xffF2F2F2)),
            borderRadius: BorderRadius.circular(5)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                ContainerResponsive(
                  width: 100,
                  height: 100,
                  margin: EdgeInsetsResponsive.symmetric(horizontal: 5),
                  child: CachedNetworkImage(
                    imageUrl: baseImageURL +
                        doneOrderList[index].customerInfo?.image.toString(),
                    fit: BoxFit.fill,
                    placeholder: (context, url) => ImageLoad(90.0),
                    errorWidget: (context, url, error) => Image.asset(
                      'images/image404.png',
                      width: 90,
                      height: 90,
                    ),
                  ),
                ),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(left: 8),
                          child: Text(
                            '${doneOrderList[index].customerInfo?.firstName.toString()}',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.left,
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              doneOrderList[index].createdAt,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
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
                    ContainerResponsive(
                      child: Center(
                          child: Text(
                        'orderNumber'.tr(),
                        style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).accentColor,
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                        child: Padding(
                      padding: EdgeInsetsResponsive.all(5.0),
                      child: Text(
                        '${doneOrderList[index].id}',
                        style: TextStyle(fontSize: 13),
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

  int load = 2;
  var nextPage;
  var nextPage1;
  var loading2 = false;
  ScrollController controller = ScrollController();
  ScrollController controller1 = ScrollController();

  getMoreOrders() async {
    if (nextPage != null) {
      var response = await Dio().get(nextPage);
      var data = response.data['data'];
      nextPage = response.data['next_page_url'];
      var newOrders = data as List;
      newOrders.forEach((v) {
        preparingOrderList.add(OrderInfo.fromJson(v));
      });
    }
    setState(() {
      loading2 = false;
    });
  }

  getMoreOrders1() async {
    if (nextPage1 != null) {
      var response = await Dio().get(nextPage1);
      var data = response.data['data'];
      nextPage1 = response.data['next_page_url'];
      var newOrders = data as List;
      newOrders.forEach((v) {
        doneOrderList.add(OrderInfo.fromJson(v));
      });
    }
    setState(() {
      loading2 = false;
    });
  }

  getOrderHistory() async {
    try {
      String _id = shop.id.toString();

      var response =
          await dioClient.get(baseURL + 'DeliveryHistorey/store&$_id&state=2');

      preparingOrderList = [];
      preparingOrderList.clear();

      nextPage = response.data['next_page_url'];
      var data = response.data['data'];
      var shops = data as List;

      shops.forEach((v) {
        preparingOrderList.add(OrderInfo.fromJson(v));
      });

      if (this.mounted) {
        setState(() {
          load = load + 1;
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

  getOrderHistory1() async {
    try {
      String _id = shop.id.toString();

      var response =
          await dioClient.get(baseURL + 'DeliveryHistorey/store&$_id&state=3');

      doneOrderList = [];
      doneOrderList.clear();

      nextPage1 = response.data['next_page_url'];
      var data = response.data['data'];
      var shops = data as List;

      shops.forEach((v) {
        doneOrderList.add(OrderInfo.fromJson(v));
      });

      if (this.mounted) {
        setState(() {
          load = load + 1;
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

  @override
  void initState() {
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
        body: Stack(
          children: [
            load == 2
                ? Column(
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              ContainerResponsive(
                                child: TextResponsive(
                                  'orders'.tr(),
                                  style: TextStyle(
                                      fontSize: 50,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xff575757)),
                                ),
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
                      DefaultTabController(
                        initialIndex: 1,
                        length: 2,
                        child: SizedBoxResponsive(
                          child: Column(
                            children: <Widget>[
                              new TabBar(
                                indicatorColor: Theme.of(context).primaryColor,
                                indicatorWeight: 2,
                                tabs: <Widget>[
                                  Tab(
                                    child: TextResponsive(
                                      'onDemandOrders'.tr(),
                                      style: TextStyle(
                                        fontSize: 28,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Tab(
                                    child: TextResponsive(
                                      'finishedOrders'.tr(),
                                      style: TextStyle(
                                        fontSize: 28,
                                        color: Colors.black,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Container(
                                height: height * 75.9,
                                width: MediaQuery.of(context).size.width,
                                child: Stack(
                                  children: <Widget>[
                                    TabBarView(
                                      children: <Widget>[
                                        Container(
                                          color: Colors.white,
                                          child: preparingOrderList.length > 0
                                              ? ListView.builder(
                                                  controller: controller,
                                                  itemBuilder:
                                                      (context, index) =>
                                                          _prepareOrderRow(
                                                              context,
                                                              index,
                                                              height * 12),
                                                  itemCount:
                                                      preparingOrderList.length,
                                                )
                                              : EmptyWidget(),
                                        ),
                                        Container(
                                            color: Colors.white,
                                            child: Column(
                                              children: [
                                                ExpansionTile(
                                                  backgroundColor:
                                                      Colors.grey[200],
                                                  initiallyExpanded: false,
                                                  title: Row(
                                                    children: [
                                                      Text(
                                                        'income'.tr(),
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .secondaryHeaderColor),
                                                      ),
                                                      shopReport == null
                                                          ? Text('0  OMR')
                                                          : Text(shopReport.data
                                                                  .totalIncume
                                                                  .toString() +
                                                              '  OMR'),
                                                      Spacer(),
                                                      Text(
                                                        'totalOrders'.tr(),
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .secondaryHeaderColor),
                                                      ),
                                                      shopReport == null
                                                          ? Text('0')
                                                          : Text(shopReport
                                                              .data.totalCount
                                                              .toString()),
                                                    ],
                                                  ),
                                                ),
                                                doneOrderList.length > 0
                                                    ? Expanded(
                                                        child: ListView.builder(
                                                          controller:
                                                              controller1,
                                                          itemBuilder: (context,
                                                                  index) =>
                                                              _doneOrderRow(
                                                                  context,
                                                                  index,
                                                                  height * 12),
                                                          itemCount:
                                                              doneOrderList
                                                                  .length,
                                                        ),
                                                      )
                                                    : Expanded(
                                                        child: EmptyWidget()),
                                              ],
                                            ))
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(child: Load(200.0)),
                    ],
                  ),
            loading2 == true
                ? Positioned(
                    bottom: 10,
                    child: ContainerResponsive(
                        child: Center(child: CupertinoActivityIndicator())))
                : ContainerResponsive(),
          ],
        ),
      ),
    );
  }
}
