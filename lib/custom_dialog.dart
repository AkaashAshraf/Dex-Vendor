import 'package:flutter/material.dart';
import 'package:mplus_provider/add_exist_product_one.dart';
import 'package:mplus_provider/add_new_product.dart';
import 'package:mplus_provider/ui/widgets/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:easy_localization/easy_localization.dart';

import 'globals.dart';
import 'models/product.dart';
import 'models/shops.dart';
import 'models/user.dart';
import 'package:dio/dio.dart';

class CustomDialog extends StatefulWidget {
  final String type;
  final Product product;

  CustomDialog({this.type, this.product});

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  var width, height;
  User user;
  Shop shop;
  var loading = false, deleting = false;
  SharedPreferences prefs;

  Future deleteProduct(var id) async {
    setState(() {
      loading = true;
    });
    try {
      prefs = await SharedPreferences.getInstance();
      var response =
          await dioClient.get(baseURL + 'deleteProduct/ProdcutId&$id');
      print('RESPONSE Shop  ${response.data}');
      if (response.data.toString().contains("sucess")) {
        setState(() {
          loading = false;
        });
        Navigator.of(context).pop(true);
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
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: manageDialogs(context, widget.type),
      ),
    );
  }

  manageDialogs(BuildContext context, String type) {
    if (type == 'deleteDialog') {
      return loading == true
          ? ContainerResponsive(
              child: Center(child: Load(150.0)),
            )
          : ContainerResponsive(
              height: 650,
              width: 500,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Stack(
                children: <Widget>[
                  Align(
                      alignment: Alignment.topCenter,
                      child: ContainerResponsive(
                          height: 190,
                          width: 190,
                          margin: EdgeInsetsResponsive.only(top: 40),
                          child: Image.asset(
                            'images/red_cancel.jpg',
                          ))),
                  Align(
                    alignment: Alignment.center,
                    child: ContainerResponsive(
                        margin: EdgeInsetsResponsive.only(top: 40),
                        width: 200,
                        child: TextResponsive(
                          'deleteProduct?'.tr(),
                          style: TextStyle(fontSize: 30, fontFamily: 'JF-Flat'),
                          textAlign: TextAlign.center,
                        )),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ContainerResponsive(
                      color: Colors.black,
                      height: 90,
                      child: Row(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop(false);
                            },
                            child: ContainerResponsive(
                              height: 90,
                              width: 250,
                              color: Theme.of(context).accentColor,
                              child: Center(
                                  child: TextResponsive(
                                'no'.tr(),
                                style: TextStyle(
                                    fontSize: 30,
                                    fontFamily: 'JF-Flat',
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              )),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop(true);
                            },
                            child: ContainerResponsive(
                              height: 90,
                              width: 250,
                              color: Theme.of(context).primaryColor,
                              child: Center(
                                  child: TextResponsive(
                                'yes'.tr(),
                                style: TextStyle(
                                    fontSize: 30,
                                    fontFamily: 'JF-Flat',
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
    } else if (type == 'addProduct') {
      return ContainerResponsive(
          height: 350,
          width: 600,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: <Widget>[
              ContainerResponsive(
                  width: 600,
                  height: 90,
                  decoration:
                      BoxDecoration(color: Theme.of(context).primaryColor),
                  child: Center(
                    child: TextResponsive(
                      'addProduct'.tr(),
                      style: TextStyle(
                          fontSize: 26,
                          fontFamily: 'JF-Flat',
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                  )),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddExistProductOne()));
                },
                child: ContainerResponsive(
                  width: 600,
                  height: 100,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.black26, width: 1))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(),
                      TextResponsive(
                        'addReadyProduct'.tr(),
                        style: TextStyle(
                            fontSize: 22,
                            fontFamily: 'JF-Flat',
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBoxResponsive(
                        width: 20,
                      ),
                      Icon(Icons.add_shopping_cart,
                          color: Theme.of(context).primaryColor),
                      SizedBoxResponsive(
                        width: 20,
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddNewProduct()));
                },
                child: ContainerResponsive(
                  width: 600,
                  height: 100,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.black26, width: 1))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(),
                      TextResponsive(
                        'addNewProduct'.tr(),
                        style: TextStyle(
                            fontSize: 22,
                            fontFamily: 'JF-Flat',
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBoxResponsive(
                        width: 20,
                      ),
                      Icon(
                        Icons.add_shopping_cart,
                        color: Theme.of(context).primaryColor,
                      ),
                      SizedBoxResponsive(
                        width: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ));
    } else if (type == 'loading') {
      return ContainerResponsive(
          height: 350,
          width: 600,
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10)),
          child: Center(
            child: CircularProgressIndicator(),
          ));
    }
  }
}
