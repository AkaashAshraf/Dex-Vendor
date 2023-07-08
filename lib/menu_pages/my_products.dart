import 'dart:developer';
import 'dart:ui' as ui;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:mplus_provider/add_new_product.dart';
import 'package:mplus_provider/menu_pages/add_status.dart';
import 'package:mplus_provider/models/product.dart';
import 'package:mplus_provider/product_details.dart';
import 'package:mplus_provider/setting_pages/notification_page.dart';
import 'package:mplus_provider/ui/widgets/loading.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:easy_localization/easy_localization.dart';
import '../globals.dart';

class MyProductsPage extends StatefulWidget {
  @override
  _MyProductsPageState createState() => _MyProductsPageState();
}

class _MyProductsPageState extends State<MyProductsPage> {
  var width, height;

  _menuCard(int index) {
//    var price = productsList[index].price;
    print('RATE ${lst[index].rate}');
    return GestureDetector(
      onTap: () {
        List<Product> child = [];
        for (int i = 0; i < children.length; i++) {
          if (children[i].parent == lst[index].id) {
            child.add(children[i]);
          }
        }
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ProductDetails(
                  product: lst[index],
                  children: child,
                )));
      },
      child: ContainerResponsive(
        height: 180,
        margin: EdgeInsetsResponsive.only(bottom: 10, left: 15, right: 15),
        decoration: BoxDecoration(
            color: Color(0xffF9F9F9), borderRadius: BorderRadius.circular(10)),
        child: Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ContainerResponsive(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xffF9F9F9),
                ),
                width: 690 / 5 * (5.0 - 3.3),
//                child: Image.asset('images/orange.png',width: width * 10,height: height * 10,),
                child: CachedNetworkImage(
                  imageUrl: baseImageURL + lst[index].image.toString(),
                  width: 66,
                  height: 66,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => ImageLoad(66.0),
                  errorWidget: (context, url, error) => Image.asset(
                    'images/image404.png',
                    width: 66,
                    height: 66,
                  ),
                ),
              ),
              ContainerResponsive(
                width: 690 / 5 * 3.3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 5,
                                  child: TextResponsive(
                                    lst[index].name != null
                                        ? context.locale == Locale('en')
                                            ? lst[index].name
                                            : lst[index].nameAr
                                        : '',
                                    style: TextStyle(
                                        fontSize: 30, color: Color(0xff111111)),
                                    textAlign: TextAlign.right,
                                    // textDirection: TextDirection.rtl,
                                  ),
                                ),
                                SizedBoxResponsive(
                                  width: 60,
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Padding(
                                    padding:
                                        EdgeInsetsResponsive.only(left: 10),
                                    child: new StarRating(
                                      rating: lst[index].rate != null
                                          ? 1 / lst[index].rate
                                          : 0,
                                      size: 15,
                                      color: Color(0xffFAC917),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ContainerResponsive(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Flexible(
                                  child: TextResponsive(
                                    lst[index].description != null
                                        ? context.locale == Locale('en')
                                            ? lst[index].description
                                            : lst[index].descriptionAr
                                        : '',
                                    style: TextStyle(
                                        fontSize: 20, color: Color(0xff989898)),
                                    textAlign: TextAlign.right,
                                    // textDirection: TextDirection.rtl,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ContainerResponsive(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                TextResponsive(
                                  '(${context.locale == Locale('ar') ? lst[index].unitAr : lst[index].unit} ${lst[index].weight})',
                                  style: TextStyle(
                                      fontSize: 25, color: Colors.grey),
                                  textAlign: TextAlign.right,
                                  // textDirection: TextDirection.rtl,
                                ),
                                TextResponsive(
                                  '${lst[index].price} ' + 'sr'.tr(),
                                  style: TextStyle(
                                      fontSize: 25,
                                      color: Theme.of(context).accentColor),
                                  textAlign: TextAlign.right,
                                  // textDirection: TextDirection.rtl,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                          //SizedBox(height: 5,),
                          // Text('30 رس',style: TextStyle(fontSize: 15),textAlign: TextAlign.right,textDirection: TextDirection.rtl,),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: <Widget>[
            IconSlideAction(
              caption: 'Delete',
              color: Colors.redAccent,
              icon: Icons.delete_sweep,
            ),
          ],
        ),
      ),
    );
  }

  Widget _getFAB() {
    return SpeedDial(
      overlayOpacity: 0.0,
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22),
      backgroundColor: Theme.of(context).primaryColor,
      visible: true,
      curve: Curves.bounceIn,
      children: [
        // FAB 1
        SpeedDialChild(
            backgroundColor: Theme.of(context).primaryColor,
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AddNewProduct(
                        products: parents,
                      )));
            },
            labelWidget: ContainerResponsive(
              padding: EdgeInsetsResponsive.only(right: 10),
              child: Row(
                mainAxisAlignment: context.locale == Locale('en')
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.end,
                children: context.locale == Locale('ar')
                    ? [
                        CircleAvatar(
                            radius: 23,
                            backgroundColor:
                                Theme.of(context).secondaryHeaderColor,
                            child: Icon(Icons.add, color: Colors.white)),
                        SizedBoxResponsive(
                          width: 10,
                        ),
                        ContainerResponsive(
                            height: 50,
                            padding:
                                EdgeInsetsResponsive.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                                color: Theme.of(context).secondaryHeaderColor,
                                borderRadius: BorderRadius.circular(15)),
                            child: Center(
                              child: TextResponsive('addProducts'.tr(),
                                  style: TextStyle(
                                      fontSize: 25, color: Colors.white)),
                            )),
                      ]
                    : [
                        ContainerResponsive(
                            height: 50,
                            padding:
                                EdgeInsetsResponsive.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                                color: Theme.of(context).secondaryHeaderColor,
                                borderRadius: BorderRadius.circular(15)),
                            child: Center(
                              child: TextResponsive('addProducts'.tr(),
                                  style: TextStyle(
                                      fontSize: 25, color: Colors.white)),
                            )),
                        SizedBoxResponsive(
                          width: 10,
                        ),
                        CircleAvatar(
                            radius: 23,
                            backgroundColor:
                                Theme.of(context).secondaryHeaderColor,
                            child: Icon(Icons.add, color: Colors.white)),
                      ],
              ),
            )),
        // FAB 2
        SpeedDialChild(
            backgroundColor: Theme.of(context).primaryColor,
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Status()));
            },
            labelWidget: ContainerResponsive(
              padding: EdgeInsetsResponsive.only(right: 10, left: 30),
              child: Row(
                mainAxisAlignment: context.locale == Locale('en')
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.spaceBetween,
                children: context.locale == Locale('ar')
                    ? [
                        CircleAvatar(
                            radius: 23,
                            backgroundColor:
                                Theme.of(context).secondaryHeaderColor,
                            child: Icon(Icons.image, color: Colors.white)),
                        SizedBoxResponsive(
                          width: 10,
                        ),
                        ContainerResponsive(
                            height: 50,
                            padding:
                                EdgeInsetsResponsive.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                                color: Theme.of(context).secondaryHeaderColor,
                                borderRadius: BorderRadius.circular(15)),
                            child: Center(
                              child: TextResponsive('addSataus'.tr(),
                                  style: TextStyle(
                                      fontSize: 25, color: Colors.white)),
                            )),
                      ]
                    : [
                        ContainerResponsive(
                            height: 50,
                            padding:
                                EdgeInsetsResponsive.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                                color: Theme.of(context).secondaryHeaderColor,
                                borderRadius: BorderRadius.circular(15)),
                            child: Center(
                              child: TextResponsive('addSataus'.tr(),
                                  style: TextStyle(
                                      fontSize: 25, color: Colors.white)),
                            )),
                        SizedBoxResponsive(
                          width: 10,
                        ),
                        CircleAvatar(
                            radius: 23,
                            backgroundColor:
                                Theme.of(context).secondaryHeaderColor,
                            child: Icon(Icons.image, color: Colors.white)),
                      ],
              ),
            ))
      ],
    );
  }

  TextEditingController cont = new TextEditingController();
  showShowCase() async {
    var prefs = await SharedPreferences.getInstance();
    bool secFirstTime = prefs.getBool('secFirstTime');
    if (secFirstTime != false) {
      ShowCaseWidget.of(context).startShowCase([showCaseTwo]);
      currentShowCase = 2;
    }
  }

  int load = 0;
  List<Product> parents = [];
  List<Product> children = [];
  List<Product> lst;

  getMyProducts() async {
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

      for (int i = 0; i < myProducts.length; i++) {
        if (myProducts[i].parent == 0) {
          parents.add(myProducts[i]);
        } else {
          children.add(myProducts[i]);
        }
      }
      lst = parents;
      if (this.mounted) {
        setState(() {
          load = load + 1;
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

  @override
  void initState() {
    super.initState();
    showShowCase();
    getMyProducts();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveWidgets.init(
      context,
      height: 1560,
      width: 720,
      allowFontScaling: true,
    );
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
            Column(
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
                        ContainerResponsive(
                          child: TextResponsive(
                            'myProducts'.tr(),
                            style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.w300,
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
                SizedBoxResponsive(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          ContainerResponsive(
                            heightResponsive: true,
                            widthResponsive: true,
                            width: 650,
                            height: 75,
                            decoration: BoxDecoration(
                                color: Color(0xffF9F9F9),
                                borderRadius: BorderRadius.circular(2)),
                            child: TextField(
                              onChanged: (text) {
                                setState(() {
                                  lst = context.locale == Locale('ar')
                                      ? myProducts
                                          .where((i) => i.nameAr
                                              .toLowerCase()
                                              .contains(
                                                  cont.text.toLowerCase()))
                                          .toList()
                                      : myProducts
                                          .where((i) => i.name
                                              .toLowerCase()
                                              .contains(
                                                  cont.text.toLowerCase()))
                                          .toList();
                                });
                              },
                              controller: cont,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'searchProduct'.tr(),
                                  contentPadding: EdgeInsetsResponsive.only(
                                      right: 20, top: 18),
                                  hintStyle: TextStyle(fontSize: 15),
                                  prefixIcon: IconButton(
                                    icon: Icon(
                                      Icons.search,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        lst = myProducts
                                            .where((i) => i.name
                                                .toLowerCase()
                                                .contains(
                                                    cont.text.toLowerCase()))
                                            .toList();
                                      });
                                    },
                                  )),
                              textAlign: TextAlign.right,
                              keyboardType: TextInputType.visiblePassword,
                              style: TextStyle(
                                color: Color(0xff111111),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBoxResponsive(height: 20),
                Expanded(
                  child: load == 1
                      ? ListView.builder(
                          itemBuilder: (context, index) => _menuCard(index),
                          itemCount: lst.length,
                        )
                      : Center(child: Load(150.0)),
                ),
              ],
            ),
            Positioned(bottom: 20, right: 10, child: _getFAB())
          ],
        ),
      ),
    );
  }
}
