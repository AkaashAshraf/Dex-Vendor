import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:mplus_provider/edit_product.dart';
import 'package:mplus_provider/globals.dart';
import 'package:mplus_provider/models/product.dart';
import 'package:mplus_provider/setting_pages/notification_page.dart';
import 'package:mplus_provider/ui/widgets/loading.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:easy_localization/easy_localization.dart';

import 'custom_dialog.dart';

class ProductDetails extends StatefulWidget {
  final Product product;
  final List<Product> children;

  ProductDetails({this.product, this.children});

  @override
  _ProductDetailsState createState() =>
      _ProductDetailsState(this.product, this.children);
}

class _ProductDetailsState extends State<ProductDetails> {
  Product product;
  List<Product> children;

  _ProductDetailsState(this.product, this.children);

  var loading = false;
  int quantity = 1;
  var addToCart = false;

  List imgList = [];

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  Future deleteProduct(var id) async {
    setState(() {
      loading = true;
    });
    try {
      var response =
          await dioClient.get(baseURL + 'deleteProduct/ProdcutId&$id');
      if (response.data.toString().contains("sucess")) {
        setState(() {
          loading = false;
        });
        bottomSelectedIndex = 3;
        Navigator.of(context).popUntil(ModalRoute.withName('home'));
        Navigator.of(context).pushReplacementNamed('home');
      } else {
        setState(() {
          loading = false;
        });
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

  Widget adds(index) {
    return ContainerResponsive(
      padding: EdgeInsetsResponsive.symmetric(horizontal: 35),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextResponsive(
            context.locale == Locale('en')
                ? "${children[index].name}"
                : "${children[index].nameAr}",
            style: TextStyle(
              fontSize: 30,
              color: Colors.black,
            ),
          ),
          Row(
            children: [
              TextResponsive(
                "${children[index].price} ${'sr'.tr()}",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                ),
              ),
              SizedBoxResponsive(width: 0),
              IconButton(
                  onPressed: () async {
                    var deleteConfirmed = await showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          CustomDialog(type: 'deleteDialog', product: product),
                    );
                    if (deleteConfirmed == true) {
                      var id = product.id.toString();
                      deleteProduct(id);
                    }
                  },
                  icon: Icon(Icons.delete_forever)),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          EditProduct(product: children[index], type: 'add')));
                },
                icon: Icon(Icons.edit),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveWidgets.init(context,
        height: 1560, width: 720, allowFontScaling: true);

    if (imgList.length == 0) {
      imgList.add('images/orange1.PNG');
    }

    return ResponsiveWidgets.builder(
      height: 1560,
      width: 720,
      allowFontScaling: true,
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: <Widget>[
              Expanded(
                child: loading == true
                    ? Center(child: Load(150.0))
                    : ListView(
                        children: <Widget>[
                          /*** Header One ***/

                          SizedBoxResponsive(
                            height: 20,
                          ),
                          SizedBoxResponsive(
                            height: 80,
                            child: Row(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    IconButton(
                                        icon: Icon(
                                          Icons.arrow_back,
                                          color: Color(0xff575757),
                                          size: 28,
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        }),
                                    TextResponsive(
                                      product.name != null
                                          ? context.locale == Locale('en')
                                              ? product.name
                                              : product.nameAr
                                          : '',
                                      style: TextStyle(
                                          fontSize: 48,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xff575757)),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                NotificationPage()));
                                  },
                                  child: ContainerResponsive(
                                      width: 100,
                                      height: 100,
                                      // ignore: deprecated_member_use
                                      child: FlatButton(
                                          onPressed: null,
                                          child: Icon(
                                            Icons.notifications_none,
                                            size: ScreenUtil()
                                                .setSp(50)
                                                .toDouble(),
                                            color:
                                                Theme.of(context).accentColor,
                                          ))),
                                ),
                              ],
                            ),
                          ),

                          /*** Header Tow ***/

                          SizedBoxResponsive(
                            height: 20,
                          ),
                          ContainerResponsive(
                            height: 300,
                            width: 600,
                            child: CachedNetworkImage(
                              imageUrl: baseImageURL + product.image.toString(),
                              fit: BoxFit.contain,
                              placeholder: (context, url) =>
                                  Center(child: ImageLoad(150.0)),
                              errorWidget: (context, url, error) => Image.asset(
                                'images/image404.png',
                                width: 20,
                                height: 20,
                              ),
                            ),
                          ),
                          Stack(
                            children: <Widget>[
                              ContainerResponsive(
                                child: Image.asset(
                                  'images/curve.PNG',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ],
                          ),

                          /*** Header Three ***/

                          SizedBoxResponsive(
                            height: 80,
                            child: Row(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    ContainerResponsive(
                                      margin: EdgeInsetsResponsive.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: TextResponsive(
                                        product.name != null
                                            ? context.locale == Locale('en')
                                                ? product.name
                                                : product.nameAr
                                            : '',
                                        style: TextStyle(
                                            fontSize: 35,
                                            color: Color(0xff111111)),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    ContainerResponsive(
                                        margin: EdgeInsetsResponsive.only(
                                            left: 10, top: 5),
                                        height: 40,
                                        child: new StarRating(
                                          rating: product.rate != null
                                              ? 1 / product.rate
                                              : 0,
                                          size: 23,
                                          color: Color(0xffFAC917),
                                        )),
                                    ContainerResponsive(
                                        margin: EdgeInsetsResponsive.only(
                                            left: 10, top: 5),
                                        child: TextResponsive(
                                          '(' +
                                              '${product.ratersCount} ${product.ratersCount}' +
                                              ')',
                                          style: TextStyle(
                                              color: Color(0xff989898),
                                              fontSize: 22),
                                        )),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ContainerResponsive(
                                  margin: EdgeInsetsResponsive.symmetric(
                                      horizontal: 10, vertical: 0),
                                  child: TextResponsive(
                                    '${product.price}' + ' ' + 'sr'.tr(),
                                    style: TextStyle(
                                        fontSize: 26,
                                        color: Theme.of(context).accentColor),
                                    textAlign: TextAlign.left,
                                  )),
                              ContainerResponsive(
                                  margin: EdgeInsetsResponsive.only(
                                      left: 15, top: 0),
                                  child: TextResponsive(
                                    '(${context.locale == Locale('ar') ? product.unitAr : product.unit} ${product.weight})',
                                    style: TextStyle(
                                        fontSize: 26, color: Colors.grey),
                                    textAlign: TextAlign.left,
                                  )),
                            ],
                          ),
                          SizedBoxResponsive(
                            height: 20,
                          ),
                          ContainerResponsive(
                              margin: EdgeInsetsResponsive.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: TextResponsive(
                                product.description != null
                                    ? context.locale == Locale('en')
                                        ? product.description
                                        : product.descriptionAr
                                    : '',
                                style: TextStyle(
                                    fontSize: 25,
                                    color: Color(0xff111111),
                                    wordSpacing: 5),
                              )),
                          SizedBoxResponsive(
                            height: 40,
                          ),
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Text('adds'.tr(),
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.black))),
                          ContainerResponsive(
                            margin: EdgeInsetsResponsive.all(10),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.black),
                                borderRadius: BorderRadius.circular(10)),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: children.length,
                              itemBuilder: (context, index) => adds(index),
                            ),
                          )
                        ],
                      ),
              ),
              /*** Bottom ***/
              Row(children: <Widget>[
                GestureDetector(
                  onTap: () async {
                    var deleteConfirmed = await showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          CustomDialog(type: 'deleteDialog', product: product),
                    );
                    if (deleteConfirmed == true) {
                      var id = product.id.toString();
                      deleteProduct(id);
                    }
                  },
                  child: ContainerResponsive(
                    width: 720 / 2,
                    height: 90,
                    color: Theme.of(context).accentColor,
                    child: Center(
                      child: TextResponsive(
                        'delete'.tr(),
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditProduct(
                                  product: product,
                                )));
                  },
                  child: ContainerResponsive(
                    width: 720 / 2,
                    height: 90,
                    color: Theme.of(context).primaryColor,
                    child: Center(
                      child: TextResponsive(
                        'edit'.tr(),
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      ),
                    ),
                  ),
                ),
              ])
            ],
          )),
    );
  }
}
