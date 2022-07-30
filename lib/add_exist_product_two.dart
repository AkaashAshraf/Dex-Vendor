import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mplus_provider/models/categories.dart';
import 'package:mplus_provider/models/product.dart';
import 'package:mplus_provider/setting_pages/notification_page.dart';
import 'package:mplus_provider/ui/widgets/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'globals.dart';
import 'package:easy_localization/easy_localization.dart';

class AddExistProductTwo extends StatefulWidget {
  final Category category;

  AddExistProductTwo({this.category});

  @override
  _AddExistProductTwoState createState() =>
      _AddExistProductTwoState(this.category);
}

class _AddExistProductTwoState extends State<AddExistProductTwo> {
  Category category;

  _AddExistProductTwoState(this.category);

  var width, height;
  List<Product> products = [];
  var loading;
  var price = TextEditingController();
  var amount = TextEditingController();
  var weightCont = TextEditingController();
  var shopId;
  var nextPage;
  ScrollController scrollController = ScrollController();
  bool loading2 = false;

  int cityID = 1;

  getFromSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    shopId = prefs.getString('shop_id');
  }

  List<DropdownMenuItem<String>> _dropCity = [];
  List<DropdownMenuItem<String>> _dropWeight = [];

  Future createProduct(
      {String name,
      String description,
      String price,
      String shop,
      int unit,
      String amount,
      String imageUrl,
      String weig}) async {
    try {
      setState(() {
        loading = true;
      });

      FormData data = new FormData.fromMap({
        'name': '$name',
        'description': '$description',
        'categories': '${category?.id}',
        'price': '$price',
        'shop': '$shopId',
        'unit': '$unit',
        'amount': '$amount',
        'weight': '$weig',
        'productImgUrl': imageUrl,
      });

      print('Exisit Products $shopId');

      var response = await dioClient.post(baseURL + 'creatProduct', data: data);
      print('RESPONSE ${response.data}');

      setState(() {
        loading = false;
      });

      if (response != null) {
        Fluttertoast.showToast(
            msg: "addProductDone".tr(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.white,
            textColor: Color(0xff34C961),
            fontSize: 16.0);
        bottomSelectedIndex = 3;
        Navigator.of(context).popUntil(ModalRoute.withName('home'));
        Navigator.of(context).pushReplacementNamed('home');
      } else {
        Fluttertoast.showToast(
            msg: response.toString(),
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

  _categoryCard(BuildContext context, int index, double _width) {
    return ContainerResponsive(
      width: 330,
      child: Stack(
        children: <Widget>[
          ContainerResponsive(
              width: 330,
              height: 360,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xffF8F8F8),
              ),
              margin: EdgeInsets.only(right: 5, left: 5, top: 5, bottom: 15),
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                children: <Widget>[
                  Center(
                    child: ContainerResponsive(
                      height: 120,
                      width: 140,
                      margin: EdgeInsetsResponsive.only(left: 25, right: 25),
//                    child: Image.asset('images/orange.png',width: 78,height: 75,fit: BoxFit.contain,)
                      child: CachedNetworkImage(
                        imageUrl:
                            baseImageURL + products[index].image.toString(),
                        fit: BoxFit.cover,
                        placeholder: (context, url) => ImageLoad(70.0),
                        errorWidget: (context, url, error) => Image.asset(
                          'images/image404.png',
                          height: 70,
                        ),
                      ),
                    ),
                  ),
                  SizedBoxResponsive(
                    height: 10,
                  ),
                  Center(
                    child: ContainerResponsive(
                        width: 120,
                        child: Image.asset(
                          'images/shadow.png',
                          fit: BoxFit.cover,
                        )),
                  ),
                  SizedBoxResponsive(
                    height: 20,
                  ),
                  Center(
                      child: TextResponsive(
                    products[index].name != null ? products[index].name : '',
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                  )),
//                  SizedBox(
//                    height: 8,
//                  ),
//                  Container(
//                      height: 100,
//                      child: Padding(
//                        padding: const EdgeInsets.only(right: 5,left: 5),
//                        child: Text(
//                          'هذا النص هو مثال لنص اخر يمكن ان يستبدل بنص اخر',
//                          style: TextStyle(
//                            fontSize: 10,
//                            color: Colors.black45,
//                          ),
//                          textAlign: TextAlign.center,
//                        ),
//                      )),
                ],
              )),
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Scaffold(
                        backgroundColor: Colors.transparent,
                        body: Center(
                          child: ContainerResponsive(
                              height: 700,
                              width: 560,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  ContainerResponsive(
                                      width: 560,
                                      height: 90,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                      ),
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
                                  SizedBoxResponsive(
                                    height: 40,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      ContainerResponsive(
                                        width: 240,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            ContainerResponsive(
                                              margin: EdgeInsetsResponsive.only(
                                                  right: 20),
                                              child: TextResponsive(
                                                'type'.tr(),
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .accentColor,
                                                    fontFamily: 'JF-Flat',
                                                    fontSize: 22,
                                                    fontWeight:
                                                        FontWeight.w500),
                                                textAlign: TextAlign.right,
                                              ),
                                            ),
                                            SizedBoxResponsive(
                                              height: 10,
                                            ),
                                            ContainerResponsive(
                                              width: 240,
                                              margin: EdgeInsetsResponsive.only(
                                                  right: 15, left: 20, top: 5),
                                              height: 70,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: Color(0xffF8F8F8),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  DropdownButton(
                                                    value: _currentCities,
                                                    items: _dropCity,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        FocusScope.of(context)
                                                            .requestFocus(
                                                                new FocusNode());
                                                        _currentCities =
                                                            value.toString();
                                                        cityID =
                                                            uns.indexOf(value) +
                                                                1;
                                                      });
                                                    },
                                                    hint: ContainerResponsive(
                                                        margin:
                                                            EdgeInsetsResponsive
                                                                .only(
                                                                    top: 10,
                                                                    left: 10),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            Icon(Icons
                                                                .arrow_drop_down),
                                                            Text('unit'.tr()),
                                                          ],
                                                        )),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      ContainerResponsive(
                                        width: 300,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            ContainerResponsive(
                                              margin: EdgeInsetsResponsive.only(
                                                  right: 10),
                                              child: TextResponsive(
                                                'unitPrice'.tr(),
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .accentColor,
                                                    fontFamily: 'JF-Flat',
                                                    fontSize: 22,
                                                    fontWeight:
                                                        FontWeight.w500),
                                                textAlign: TextAlign.right,
                                              ),
                                            ),
                                            SizedBoxResponsive(
                                              height: 10,
                                            ),
                                            ContainerResponsive(
                                              margin: EdgeInsetsResponsive.only(
                                                  right: 15, left: 30, top: 5),
                                              height: 70,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: Color(0xffF8F8F8),
                                              ),
                                              child: Padding(
                                                padding:
                                                    EdgeInsetsResponsive.only(
                                                        right: 15),
                                                child: TextField(
                                                  controller: price,
                                                  decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      hintText:
                                                          'enterUnitPrice'.tr(),
                                                      hintStyle: TextStyle(
                                                          fontSize: ScreenUtil()
                                                              .setSp(25)
                                                              .toDouble(),
                                                          fontFamily:
                                                              'JF-Flat')),
                                                  textAlign: TextAlign.right,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  style: TextStyle(
                                                      color: Color(0xff111111),
                                                      fontSize: ScreenUtil()
                                                          .setSp(25)
                                                          .toDouble()),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBoxResponsive(
                                    height: 30,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      ContainerResponsive(
                                        width: 240,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            ContainerResponsive(
                                              margin: EdgeInsetsResponsive.only(
                                                  right: 20),
                                              child: TextResponsive(
                                                'unit'.tr(),
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .accentColor,
                                                    fontFamily: 'JF-Flat',
                                                    fontSize: 22,
                                                    fontWeight:
                                                        FontWeight.w500),
                                                textAlign: TextAlign.right,
                                              ),
                                            ),
                                            SizedBoxResponsive(
                                              height: 10,
                                            ),
                                            ContainerResponsive(
                                              width: 240,
                                              margin: EdgeInsetsResponsive.only(
                                                  right: 15, left: 20, top: 10),
                                              height: 70,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: Color(0xffF8F8F8),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  DropdownButton(
                                                    value: _currentWeight,
                                                    items: _dropWeight,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        FocusScope.of(context)
                                                            .requestFocus(
                                                                new FocusNode());
                                                        _currentWeight =
                                                            value.toString();
                                                      });
                                                    },
                                                    hint: ContainerResponsive(
                                                        margin:
                                                            EdgeInsetsResponsive
                                                                .only(
                                                                    top: 10,
                                                                    left: 10),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            Icon(Icons
                                                                .arrow_drop_down),
                                                            Text('unit'.tr()),
                                                          ],
                                                        )),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      ContainerResponsive(
                                        width: 300,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            ContainerResponsive(
                                              margin: EdgeInsetsResponsive.only(
                                                  right: 20),
                                              child: TextResponsive(
                                                'weight'.tr(),
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .accentColor,
                                                    fontFamily: 'JF-Flat',
                                                    fontSize: 22,
                                                    fontWeight:
                                                        FontWeight.w500),
                                                textAlign: TextAlign.right,
                                              ),
                                            ),
                                            SizedBoxResponsive(
                                              height: 10,
                                            ),
                                            ContainerResponsive(
                                              margin: EdgeInsetsResponsive.only(
                                                  right: 15, left: 30, top: 10),
                                              height: 70,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: Color(0xffF8F8F8),
                                              ),
                                              child: Padding(
                                                padding:
                                                    EdgeInsetsResponsive.only(
                                                        right: 15),
                                                child: TextField(
                                                  controller: weightCont,
                                                  decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      hintText:
                                                          'enterWeight'.tr(),
                                                      hintStyle: TextStyle(
                                                          fontSize: ScreenUtil()
                                                              .setSp(25)
                                                              .toDouble(),
                                                          fontFamily:
                                                              'JF-Flat')),
                                                  textAlign: TextAlign.right,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  style: TextStyle(
                                                      color: Color(0xff111111),
                                                      fontSize: ScreenUtil()
                                                          .setSp(30)
                                                          .toDouble()),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBoxResponsive(
                                    height: 40,
                                  ),
                                  ContainerResponsive(
                                    margin:
                                        EdgeInsetsResponsive.only(right: 20),
                                    child: TextResponsive(
                                      'availableQuantity'.tr(),
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontFamily: 'JF-Flat',
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  SizedBoxResponsive(
                                    height: 10,
                                  ),
                                  ContainerResponsive(
                                    margin: EdgeInsetsResponsive.only(
                                        right: 15, left: 20, top: 10),
                                    height: 70,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Color(0xffF8F8F8),
                                    ),
                                    child: Padding(
                                      padding:
                                          EdgeInsetsResponsive.only(right: 15),
                                      child: TextField(
                                        controller: amount,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'enterQuantity'.tr(),
                                            hintStyle: TextStyle(
                                              fontSize: ScreenUtil()
                                                  .setSp(25)
                                                  .toDouble(),
                                              fontFamily: 'JF-Flat',
                                            )),
                                        textAlign: TextAlign.right,
                                        keyboardType: TextInputType.number,
                                        style: TextStyle(
                                            color: Color(0xff111111),
                                            fontSize: ScreenUtil()
                                                .setSp(30)
                                                .toDouble()),
                                      ),
                                    ),
                                  ),
                                  SizedBoxResponsive(
                                    height: 40,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if (price.text.trim().length == 0) {
                                        Fluttertoast.showToast(
                                            msg: "enterUnitPrice".tr(),
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            backgroundColor: Colors.redAccent,
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                        return;
                                      } else if (amount.text.trim().length ==
                                          0) {
                                        Fluttertoast.showToast(
                                            msg: "enterQuantity".tr(),
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            backgroundColor: Colors.redAccent,
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                        return;
                                      } else if (weightCont.text
                                              .trim()
                                              .length ==
                                          0) {
                                        Fluttertoast.showToast(
                                            msg: "enterWeight".tr(),
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            backgroundColor: Colors.redAccent,
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                        return;
                                      }

                                      createProduct(
                                          price: price.text,
                                          unit: cityID,
                                          description:
                                              products[index].description,
                                          name: products[index].name,
                                          weig: weightCont.text +
                                              " " +
                                              _currentWeight.toString(),
                                          amount: amount.text,
                                          imageUrl: products[index].image,
                                          shop: '1');
                                      Navigator.of(context).pop();
                                    },
                                    child: Center(
                                      child: ContainerResponsive(
                                        margin: EdgeInsetsResponsive.only(
                                            right: 15, left: 15, top: 10),
                                        height: 70,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        child: Padding(
                                            padding: EdgeInsetsResponsive.only(
                                              right: 0,
                                            ),
                                            child: Center(
                                              child: TextResponsive(
                                                'add'.tr(),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 27,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            )),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      );
                    });
              },
              child: ContainerResponsive(
                margin: EdgeInsetsResponsive.only(top: 10),
                height: 65,
                width: 270,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10))),
                child: Center(
                  child: TextResponsive(
                    'showInStore'.tr(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  _getProducts(var id) async {
    try {
      setState(() {
        loading = true;
      });

      var response =
          await dioClient.get(baseURL + 'getProductsTemplets/$id/id');

      products = [];

      var data = response.data['data'];
      nextPage = response.data['next_page_url'];
      var category = data as List;
      print('DATA $category');

      category.forEach((v) {
        products.add(Product.fromJson(v));
      });
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

  homeLoad() {
    return Column(
      children: <Widget>[
        SizedBoxResponsive(
          height: 70,
        ),
        SizedBoxResponsive(
          height: 80,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    ContainerResponsive(
                      margin: EdgeInsetsResponsive.fromLTRB(0, 15, 35, 0),
                      child: TextResponsive(
                        category?.name != null ? category?.name : '',
                        style: TextStyle(
                            fontSize: 48, fontWeight: FontWeight.w300),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NotificationPage()));
                },
                child: ContainerResponsive(
                    width: 100,
                    height: 100,
                    child: FlatButton(
                        onPressed: null,
                        child: Icon(
                          Icons.notifications_none,
                          size: ScreenUtil().setSp(50).toDouble(),
                          color: Theme.of(context).accentColor,
                        ))),
              ),
            ],
          ),
        ),
        SizedBoxResponsive(
          height: 40,
        ),
        Center(child: Load(150.0))
      ],
    );
  }

  String _currentCities;
  String _currentWeight;
  List uns = [];

  List<DropdownMenuItem<String>> getDropCatsSub(List _cats) {
    List<DropdownMenuItem<String>> items = [];
    for (int i = 0; i < _cats.length; i++) {
      String a = context.locale == Locale('ar')
          ? _cats[i]['name_ar']
          : _cats[i]["name"];
      uns.add(a);

      items.add(new DropdownMenuItem(
        value: a,
        child: ContainerResponsive(
            width: 100,
            child: TextResponsive(a,
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: a.length > 9 ? 22 : 25))),
      ));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getWe(List _cats) {
    List<DropdownMenuItem<String>> items = [];
    for (int i = 0; i < _cats.length; i++) {
      String a = _cats[i];

      items.add(new DropdownMenuItem(
        value: a,
        child: ContainerResponsive(
            width: 100,
            child: TextResponsive(a,
                textAlign: TextAlign.right, style: TextStyle(fontSize: 25))),
      ));
    }
    return items;
  }

  getMoreProducts() async {
    if (nextPage != null) {
      var response = await Dio().get(nextPage);
      var data = response.data['data'];
      nextPage = response.data['next_page_url'];
      var newProducts = data as List;
      newProducts.forEach((v) {
        products.add(Product.fromJson(v));
      });
    }
    setState(() {
      loading2 = false;
    });
  }

  @override
  void initState() {
    List weights = ["gram".tr(), "kg".tr()];

    _dropCity = getDropCatsSub(units);
    _dropWeight = getWe(weights);
    _currentCities = _dropCity[0].value;
    _currentWeight = _dropWeight[0].value;

    getFromSF();
    _getProducts(category?.id);
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          loading2 != true) {
        print('end');
        setState(() {
          loading2 = true;
        });
        getMoreProducts();
      }
    });
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
        body: loading
            ? homeLoad()
            : Stack(
                children: [
                  CustomScrollView(
                    controller: scrollController,
                    slivers: <Widget>[
                      /*** Header One ***/
                      SliverPadding(
                        padding: EdgeInsetsResponsive.all(0.0),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate(
                            [
                              SizedBoxResponsive(
                                height: 70,
                              ),
                              SizedBoxResponsive(
                                height: 80,
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
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
                                            category?.name != null
                                                ? category?.name
                                                : '',
                                            style: TextStyle(
                                                fontSize: 48,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                    ),
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
                                            child: Icon(
                                              Icons.notifications_none,
                                              size: ScreenUtil()
                                                  .setSp(50)
                                                  .toDouble(),
                                              color:
                                                  Theme.of(context).accentColor,
                                            ))),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      ///*** Header Two ***/
                      SliverPadding(
                        padding: EdgeInsets.all(0.0),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate(
                            [
                              SizedBoxResponsive(
                                height: 30,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  ContainerResponsive(
                                    child: Row(
                                      children: <Widget>[
                                        ContainerResponsive(
                                          width: 630,
                                          height: 75,
                                          decoration: BoxDecoration(
                                              color: Color(0xffF9F9F9),
                                              borderRadius:
                                                  BorderRadius.circular(2)),
                                          child: TextField(
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: 'productSearch'.tr(),
                                              contentPadding:
                                                  EdgeInsetsResponsive.only(
                                                      right: 15, top: 17),
                                              hintStyle: TextStyle(
                                                  fontSize: ScreenUtil()
                                                      .setSp(22)
                                                      .toDouble()),
                                              prefixIcon: Icon(
                                                Icons.search,
                                                size: 20,
                                              ),
                                            ),
                                            textAlign: TextAlign.right,
                                            keyboardType:
                                                TextInputType.visiblePassword,
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
                              SizedBoxResponsive(
                                height: 40,
                              ),
                            ],
                          ),
                        ),
                      ),

                      SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) =>
                              _categoryCard(context, index, 185.0),
                          childCount: products.length,
                        ),
                      ),
                      SliverPadding(
                        padding: EdgeInsets.all(0.0),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate(
                            [
                              SizedBoxResponsive(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  loading2 == true
                      ? Positioned(
                          bottom: 10,
                          child: ContainerResponsive(
                              width: 720,
                              child:
                                  Center(child: CupertinoActivityIndicator())),
                        )
                      : ContainerResponsive(),
                ],
              ),
      ),
    );
  }
}

class AddExsisitProductDialog extends StatefulWidget {
  @override
  _AddExsisitDialogState createState() => _AddExsisitDialogState();
}

class _AddExsisitDialogState extends State<AddExsisitProductDialog> {
  var width, height;
  var loading;
  String _value;

  var price = TextEditingController();
  var amount = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ResponsiveWidgets.init(context,
        height: 1560, width: 720, allowFontScaling: true);

    return ResponsiveWidgets.builder(
      height: 1560,
      width: 720,
      allowFontScaling: true,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
              height: height * 43,
              width: width * 78,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      width: width * 78,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Color(0xff34C961),
                      ),
                      child: Center(
                        child: Text(
                          'addProduct'.tr(),
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'JF-Flat',
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: width * 35,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(right: 10),
                              child: Text(
                                'type'.tr(),
                                style: TextStyle(
                                    color: Color(0xff111111),
                                    fontFamily: 'JF-Flat',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500),
                                textAlign: TextAlign.right,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              margin:
                                  EdgeInsets.only(right: 7, left: 10, top: 5),
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Color(0xffF8F8F8),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: DropdownButton<String>(
                                    isDense: true,
                                    isExpanded: true,
                                    iconEnabledColor: Color(0xffF8F8F8),
                                    items: [
                                      DropdownMenuItem<String>(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Text('kg'.tr()),
                                          ],
                                        ),
                                        value: '1',
                                      ),
                                      DropdownMenuItem<String>(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Text('كيس'),
                                          ],
                                        ),
                                        value: '2',
                                      ),
                                      DropdownMenuItem<String>(
                                        child: Center(
                                            child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Text('صندوق'),
                                          ],
                                        )),
                                        value: '3',
                                      ),
                                    ],
                                    onChanged: (String value) {
                                      setState(() {
                                        _value = value;
                                        print(_value);
                                      });
                                    },
                                    hint: Container(
                                        margin:
                                            EdgeInsets.only(top: 5, left: 5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(Icons.arrow_drop_down),
                                            Text('unit'.tr()),
                                          ],
                                        )),
                                    value: _value,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: width * 42,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(right: 10),
                              child: Text(
                                'unitPrice'.tr(),
                                style: TextStyle(
                                    color: Color(0xff111111),
                                    fontFamily: 'JF-Flat',
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500),
                                textAlign: TextAlign.right,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              margin:
                                  EdgeInsets.only(right: 7, left: 20, top: 5),
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Color(0xffF8F8F8),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: TextField(
                                  controller: price,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'enterUnitPrice'.tr(),
                                      hintStyle: TextStyle(
                                          fontSize: 13, fontFamily: 'JF-Flat')),
                                  textAlign: TextAlign.right,
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(
                                    color: Color(0xff111111),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Text(
                      'availableQuantity'.tr(),
                      style: TextStyle(
                          color: Color(0xff111111),
                          fontFamily: 'JF-Flat',
                          fontSize: 13,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 7, left: 10, top: 5),
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Color(0xffF8F8F8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: TextField(
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'enterAvailableQuantity'.tr(),
                            hintStyle: TextStyle(
                              fontSize: 13,
                              fontFamily: 'JF-Flat',
                            )),
                        textAlign: TextAlign.right,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          color: Color(0xff111111),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      print('LENGTH ${price.text.length}');
                      if (price.text.trim().length < 0) {
                        Fluttertoast.showToast(
                            msg: "enterProductName".tr(),
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.redAccent,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        return;
                      } else if (_value == null) {
                        Fluttertoast.showToast(
                            msg: "enterUnitPrice".tr(),
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.redAccent,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        return;
                      } else if (amount.text.trim().length < 0) {
                        Fluttertoast.showToast(
                            msg: "enterQuantity".tr(),
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.redAccent,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        return;
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 7, left: 10, top: 5),
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color(0xff34C961),
                      ),
                      child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Center(
                            child: Text(
                              'add'.tr(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600),
                            ),
                          )),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
