import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mplus_provider/models/categories.dart';
import 'package:mplus_provider/setting_pages/notification_page.dart';
import 'package:mplus_provider/ui/widgets/loading.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

import 'globals.dart';
import 'media_pick.dart';
import 'models/product.dart';

class AddNewProduct extends StatefulWidget {
  final List<Product> products;

  const AddNewProduct({Key key, this.products}) : super(key: key);
  @override
  _AddNewProductState createState() => _AddNewProductState(products);
}

class Statuses {
  String name;
  String nameAr;
  int id;
  Statuses({this.name, this.id, this.nameAr});
}

class _AddNewProductState extends State<AddNewProduct> {
  var width, height;
  String _value;
  var loading = false;
  List<Category> categories = [];
  File _profileImage;
  var name = TextEditingController();
  var nameAr = TextEditingController();
  var description = TextEditingController();
  var descriptionAr = TextEditingController();
  var price = TextEditingController();
  var tag = TextEditingController();
  var sec = TextEditingController();
  var secAr = TextEditingController();
  var weightCont = TextEditingController();

  var shopId;

  _AddNewProductState(List<Product> products);
  List<Product> products;
  getFromSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    shopId = prefs.getString('shop_id');
  }

  int cityID = 1;
  List<DropdownMenuItem<String>> _dropdownMenuItems = [];
  String selectedCategory;
  List<String> categoryIds = [];
  List<String> item = [];
  String selectedCategoryId;

  void onChangeDropdownItem(String selectedCity) {
    print(selectedCity);
    setState(() {
      selectedCategory = selectedCity;
      selectedCategoryId = categoryIds[item.indexOf(selectedCity)];

      print(' Selected Id $selectedCategoryId');
    });
  }

  List<DropdownMenuItem<String>> buildDropdownMenuItems(List countries) {
    List<DropdownMenuItem<String>> items = [];
    for (Category category in categories) {
      items.add(
        DropdownMenuItem(
            value:
                '${context.locale == Locale('ar') ? category.nameAr : category.name}',
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                TextResponsive(
                  context.locale == Locale('ar')
                      ? category.nameAr
                      : category.name,
                  style: TextStyle(fontSize: 25),
                  textAlign: TextAlign.right,
                ),
              ],
            )),
      );
      item.add(
          context.locale == Locale('ar') ? category.nameAr : category.name);
      categoryIds.add('${category.id}');

      print('NAme ${category.name}');
      print('Id ${category.id}');
    }
    return items;
  }

  _getCategories() async {
    try {
      setState(() {
        loading = true;
      });
      var response = await dioClient.get(baseURL + 'getCategories');

      categories = [];

      var data = response.data;
      var category = data as List;
      print('DATA $category');

      category.forEach((v) {
        categories.add(Category.fromJson(v));
      });
      selectedCategory = context.locale == Locale('ar')
          ? categories[0].nameAr.toString()
          : categories[0].name.toString();
      _dropdownMenuItems = buildDropdownMenuItems(categories);

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

  List<Statuses> status = [
    Statuses(id: 0, name: 'optional', nameAr: 'اختياري'),
    Statuses(id: 1, name: 'Required', nameAr: 'يجب اختياره'),
    Statuses(
        id: 2,
        name: 'Choose One from section',
        nameAr: 'اختر واحد من هذه الفئة'),
  ];

  List<DropdownMenuItem<int>> statesItems(List<Statuses> list) {
    List<DropdownMenuItem<int>> items = [];
    list.forEach((item) {
      items.add(
        DropdownMenuItem(
            value: item.id,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  context.locale == Locale('ar') ? item.nameAr : item.name,
                ),
              ],
            )),
      );
    });
    return items;
  }

  int isRequired = 0;
  String hint = 'pickState'.tr();

  homeLoad() {
    return Column(
      children: <Widget>[
        SizedBoxResponsive(
          height: 70,
        ),
        SizedBoxResponsive(
          height: 80,
          child: Stack(
            children: <Widget>[
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
                        child: Icon(Icons.notifications_none,
                            size: ScreenUtil().setSp(50).toDouble(),
                            color: Theme.of(context).accentColor))),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ContainerResponsive(
                    margin: EdgeInsetsResponsive.fromLTRB(35, 15, 35, 0),
                    child: TextResponsive(
                      'addNewProduct'.tr(),
                      style:
                          TextStyle(fontSize: 48, fontWeight: FontWeight.w300),
                    ),
                  ),
                ],
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

  Future createProduct(
      {String name,
      String nameAr,
      String tag,
      String sec,
      String secAr,
      String isReq,
      String description,
      String descriptionAr,
      String price,
      String shop,
      int unit,
      int parent,
      String weig}) async {
    try {
      setState(() {
        loading = true;
      });

      print('SHOP ID $shopId');

      FormData data = FormData.fromMap({
        'name': '$name',
        'name_ar': '$nameAr',
        'tags': '$tag',
        'description': '$description',
        'description_ar': '$descriptionAr',
        'categories': '$selectedCategoryId',
        'price': '$price',
        'shop': '$shopId',
        'weight': '$weig',
        'unit': '$unit',
        'section': '$sec',
        'section_ar': '$secAr',
        'isRequired': '$isRequired',
        'parent': '$parent',
        'img': await MultipartFile.fromFile(_profileImage.path,
            filename: 'basha_$name _ $price'),
      });
      var response = await dioClient.post(baseURL + 'creatProduct', data: data);
      print('RESPONSE ${response.data}');

      setState(() {
        loading = false;
      });
      if (response != null) {
        Fluttertoast.showToast(
            msg: "تم إنشاء المنتج بنجاح",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.white,
            textColor: Color(0xff34C961),
            fontSize: 16.0);
        setState(() {
          bottomSelectedIndex = 0;
        });
        Navigator.of(context).pop();
        Navigator.pushReplacementNamed(context, 'home');
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
      setState(() {
        loading = false;
      });
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
      setState(() {
        loading = false;
      });
      throw error;
    }
  }

  String _currentCities;
  List uns = [];

  List<DropdownMenuItem<String>> getParents(List<Product> products) {
    List<DropdownMenuItem<String>> items = [];
    items.insert(
        0,
        DropdownMenuItem(
          value: 'none',
          child: ContainerResponsive(
              width: 150,
              child: TextResponsive(
                "none",
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 25),
              )),
        ));
    for (int i = 0; i < products.length; i++) {
      String a = products[i].name;
      items.add(DropdownMenuItem(
        value: a,
        child: ContainerResponsive(
            width: 150,
            child: TextResponsive(
              a,
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 25),
            )),
      ));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getDropCatsSub(List _cats) {
    List<DropdownMenuItem<String>> items = [];
    for (int i = 0; i < _cats.length; i++) {
      String a = context.locale == Locale('ar')
          ? _cats[i]['name_ar']
          : _cats[i]["name"];
      uns.add(a);

      items.add(DropdownMenuItem(
        value: a,
        child: ContainerResponsive(
            width: 150,
            child: TextResponsive(
              a,
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 25),
            )),
      ));
    }
    return items;
  }

  List<DropdownMenuItem<String>> _dropCity = [];

  List<DropdownMenuItem<String>> getWe(List _cats) {
    List<DropdownMenuItem<String>> items = [];
    for (int i = 0; i < _cats.length; i++) {
      String a = _cats[i];

      items.add(DropdownMenuItem(
        value: a,
        child: ContainerResponsive(
            width: 150.0,
            child: TextResponsive(
              a,
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 25),
            )),
      ));
    }
    return items;
  }

  List<DropdownMenuItem<String>> _dropParents = [];
  String _currentParent;
  List<Product> _products = [];
  int chosenParent = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var lang = context.locale == Locale('ar') ? 'ar' : 'en';
      _products = widget.products;
      _dropCity = getDropCatsSub(units);
      _dropParents = getParents(_products);
      _currentCities = _dropCity[0].value;
      _currentParent = _dropParents[0].value;
      getFromSF();
      _getCategories();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveWidgets.init(context,
        height: 1560, width: 720, allowFontScaling: true);

    width = MediaQuery.of(context).size.width / 100;
    height = MediaQuery.of(context).size.height / 100;

    return ResponsiveWidgets.builder(
      height: 1560,
      width: 720,
      allowFontScaling: true,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: loading
            ? Center(child: Load(150.0))
            : SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBoxResponsive(
                      height: 70,
                    ),
                    appBar(
                      context: context,
                      backButton: true,
                      title: 'addNewProduct'.tr(),
                    ),
                    SizedBoxResponsive(
                      height: 40,
                    ),
                    ContainerResponsive(
                      width: 720,
                      height: 200,
                      margin: EdgeInsetsResponsive.only(
                          right: 20, top: 20, left: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return ContainerResponsive(
                                    width: 100,
                                    height: 200,
                                    margin: EdgeInsetsResponsive.all(5),
                                    decoration: BoxDecoration(
                                      color: Color(0xffF8F8F8),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Stack(
                                      children: <Widget>[
                                        Center(
                                          child: Container(
                                            width: width * 15,
                                            height: height * 9,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Image.asset(
                                              'images/orange.png',
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin:
                                              EdgeInsets.only(left: 3, top: 0),
                                          width: width * 4.5,
                                          height: height * 3.5,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.green),
                                          child: Center(
                                            child: Icon(
                                              Icons.clear,
                                              color: Colors.white,
                                              size: 15,
                                            ),
                                          ),
                                        )
                                      ],
                                    ));
                              },
                              itemCount: 0,
                            ),
                          ),
                          SizedBoxResponsive(
                            width: 20,
                          ),
                          GestureDetector(
                            onTap: () async {
                              var pickedFile = await showDialog(
                                  context: context,
                                  builder: (context) => MediaPickDialog());
                              if (pickedFile != null)
                                setState(() {
                                  _profileImage = pickedFile;
                                });
                            },
                            child: ContainerResponsive(
                              width: 150,
                              height: 200,
                              margin: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: _profileImage != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.file(
                                        _profileImage,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.camera_alt,
                                          size: 25,
                                          color: Colors.white,
                                        ),
                                        TextResponsive(
                                          'addPhoto'.tr(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 22,
                                              fontWeight: FontWeight.w600),
                                        )
                                      ],
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBoxResponsive(height: 50),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin:
                              EdgeInsetsResponsive.only(right: 35, left: 35),
                          child: TextResponsive(
                            'productName'.tr(),
                            style: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontSize: 26,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        SizedBoxResponsive(height: 10),
                        Center(
                          child: ContainerResponsive(
                            margin: EdgeInsetsResponsive.only(
                                right: 30, left: 30, top: 5),
                            height: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Color(0xffF8F8F8),
                            ),
                            child: Padding(
                              padding: EdgeInsetsResponsive.only(right: 15),
                              child: TextField(
                                controller: name,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'enterProductName'.tr(),
                                    hintStyle: TextStyle(
                                        fontSize:
                                            ScreenUtil().setSp(25).toDouble())),
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                    color: Color(0xff111111),
                                    fontSize:
                                        ScreenUtil().setSp(25).toDouble()),
                              ),
                            ),
                          ),
                        ),
                        SizedBoxResponsive(
                          height: 30,
                        ),
                        Container(
                          margin:
                              EdgeInsetsResponsive.only(right: 35, left: 35),
                          child: TextResponsive(
                            'productNameAr'.tr(),
                            style: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontSize: 26,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        SizedBoxResponsive(height: 10),
                        Center(
                          child: ContainerResponsive(
                            margin: EdgeInsetsResponsive.only(
                                right: 30, left: 30, top: 5),
                            height: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Color(0xffF8F8F8),
                            ),
                            child: Padding(
                              padding: EdgeInsetsResponsive.only(right: 15),
                              child: TextField(
                                controller: nameAr,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'enterProductNameAr'.tr(),
                                    hintStyle: TextStyle(
                                        fontSize:
                                            ScreenUtil().setSp(25).toDouble())),
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                    color: Color(0xff111111),
                                    fontSize:
                                        ScreenUtil().setSp(25).toDouble()),
                              ),
                            ),
                          ),
                        ),
                        SizedBoxResponsive(
                          height: 30,
                        ),
                        ContainerResponsive(
                          padding:
                              EdgeInsetsResponsive.symmetric(horizontal: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ContainerResponsive(
                                width: 300,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: TextResponsive(
                                        'parentsProduct'.tr(),
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).accentColor,
                                            fontSize: 26,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    SizedBoxResponsive(height: 5),
                                    ContainerResponsive(
                                      height: 70,
                                      width: 300,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Color(0xffF8F8F8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          DropdownButton<String>(
                                            hint: ContainerResponsive(
                                                width: 100,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    Icon(Icons.arrow_drop_down,
                                                        color: Colors.black),
                                                    TextResponsive(
                                                        'chooseCategory'.tr(),
                                                        style: TextStyle(
                                                            fontSize: 26)),
                                                  ],
                                                )),
                                            value: _currentParent,
                                            items: _dropParents,
                                            onChanged: (value) {
                                              setState(() {
                                                _currentParent = value;
                                                chosenParent = value == 'none'
                                                    ? 0
                                                    : _products
                                                        .where((product) =>
                                                            value ==
                                                            product.name)
                                                        .first
                                                        .id;
                                                print(chosenParent);
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ContainerResponsive(
                                padding: EdgeInsetsResponsive.symmetric(
                                    horizontal: 30),
                                width: 300,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: TextResponsive(
                                        'categories'.tr(),
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).accentColor,
                                            fontSize: 26,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    SizedBoxResponsive(height: 5),
                                    ContainerResponsive(
                                      margin: EdgeInsetsResponsive.only(
                                          right: 10, left: 10),
                                      height: 70,
                                      width: 300,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Color(0xffF8F8F8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          DropdownButton(
                                              hint: ContainerResponsive(
                                                  width: 100,
                                                  margin:
                                                      EdgeInsetsResponsive.only(
                                                          top: 5,
                                                          left: 10,
                                                          right: 10),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Icon(
                                                          Icons.arrow_drop_down,
                                                          color: Colors.black),
                                                      TextResponsive(
                                                          'chooseCategory'.tr(),
                                                          style: TextStyle(
                                                              fontSize: 26)),
                                                    ],
                                                  )),
                                              // isExpanded: false,
                                              value: selectedCategory,
                                              items: _dropdownMenuItems,
                                              onChanged: (selectedCity) {
                                                print(selectedCity);
                                                setState(() {
                                                  selectedCategory =
                                                      selectedCity;
                                                  selectedCategoryId =
                                                      categoryIds[item.indexOf(
                                                          selectedCity)];

                                                  print(
                                                      ' Selected Id $selectedCategoryId');
                                                });
                                              }),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBoxResponsive(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            ContainerResponsive(
                              width: 360,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  ContainerResponsive(
                                    margin: EdgeInsetsResponsive.only(
                                        right: 35, left: 35),
                                    child: TextResponsive(
                                      'unitPrice'.tr(),
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize: 26,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  SizedBoxResponsive(
                                    height: 10,
                                  ),
                                  ContainerResponsive(
                                    margin: EdgeInsetsResponsive.only(
                                        right: 30, left: 30, top: 5),
                                    height: 70,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Color(0xffF8F8F8),
                                    ),
                                    child: Padding(
                                      padding:
                                          EdgeInsetsResponsive.only(right: 15),
                                      child: TextField(
                                        controller: price,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'enterUnitPrice'.tr(),
                                            hintStyle: TextStyle(
                                                fontSize: ScreenUtil()
                                                    .setSp(25)
                                                    .toDouble())),
                                        keyboardType: TextInputType.number,
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
                            ContainerResponsive(
                              width: 300,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsetsResponsive.only(
                                        right: 20, left: 20),
                                    child: TextResponsive(
                                      'type'.tr(),
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize: 26,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  SizedBoxResponsive(
                                    height: 5,
                                  ),
                                  ContainerResponsive(
                                    width: 300,
                                    margin: EdgeInsetsResponsive.only(
                                        right: 10, left: 10, top: 5),
                                    height: 70,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
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
                                                  .requestFocus(FocusNode());
                                              _currentCities = value.toString();
                                              cityID = uns.indexOf(value) + 1;
                                            });
                                          },
                                          hint: ContainerResponsive(
                                              margin: EdgeInsetsResponsive.only(
                                                  top: 5, left: 10, right: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Icon(Icons.arrow_drop_down),
                                                  TextResponsive('unit'.tr(),
                                                      style: TextStyle(
                                                          fontSize: 26)),
                                                ],
                                              )),
                                        ),
                                      ],
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
                              width: 360,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  ContainerResponsive(
                                    margin: EdgeInsetsResponsive.only(
                                        right: 35, left: 35),
                                    child: TextResponsive(
                                      'weight'.tr(),
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontFamily: 'JF-Flat',
                                          fontSize: 26,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  SizedBoxResponsive(
                                    height: 10,
                                  ),
                                  ContainerResponsive(
                                    margin: EdgeInsetsResponsive.only(
                                        right: 30, left: 30, top: 5),
                                    height: 70,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Color(0xffF8F8F8),
                                    ),
                                    child: Padding(
                                      padding:
                                          EdgeInsetsResponsive.only(right: 15),
                                      child: TextField(
                                        controller: weightCont,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'enterWeight'.tr(),
                                            hintStyle: TextStyle(
                                                fontSize: ScreenUtil()
                                                    .setSp(25)
                                                    .toDouble(),
                                                fontFamily: 'JF-Flat')),
                                        keyboardType: TextInputType.number,
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
                          height: 30,
                        ),
                        Padding(
                          padding:
                              EdgeInsetsResponsive.symmetric(horizontal: 35.0),
                          child: TextResponsive(
                            'tag'.tr(),
                            style: TextStyle(fontSize: 26, color: Colors.black),
                          ),
                        ),
                        SizedBoxResponsive(height: 10),
                        ContainerResponsive(
                          margin: EdgeInsetsResponsive.only(
                              right: 30, left: 30, top: 5),
                          height: 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Color(0xffF8F8F8),
                          ),
                          child: Padding(
                            padding: EdgeInsetsResponsive.only(left: 15),
                            child: TextField(
                              controller: tag,
                              decoration: InputDecoration(
                                  prefixText: ' # ',
                                  prefixStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize:
                                          ScreenUtil().setSp(25).toDouble()),
                                  border: InputBorder.none,
                                  hintText: 'enterTag'.tr(),
                                  hintStyle: TextStyle(
                                      fontSize:
                                          ScreenUtil().setSp(25).toDouble())),
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                  color: Color(0xff111111),
                                  fontSize: ScreenUtil().setSp(25).toDouble()),
                            ),
                          ),
                        ),
                        SizedBoxResponsive(
                          height: 30,
                        ),
                        chosenParent == 0
                            ? Container()
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ContainerResponsive(
                                    margin: EdgeInsetsResponsive.only(
                                        right: 35, left: 35),
                                    child: TextResponsive(
                                      'section'.tr(),
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize: 26,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  SizedBoxResponsive(height: 10),
                                  ContainerResponsive(
                                    margin: EdgeInsetsResponsive.only(
                                        right: 30, left: 30, top: 5),
                                    height: 70,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Color(0xffF8F8F8),
                                    ),
                                    child: Padding(
                                      padding:
                                          EdgeInsetsResponsive.only(left: 15),
                                      child: TextField(
                                        controller: sec,
                                        decoration: InputDecoration(
                                            prefixStyle: TextStyle(
                                                fontSize:
                                                    ScreenUtil().setSp(25)),
                                            border: InputBorder.none,
                                            hintText: 'enterSec'.tr(),
                                            hintStyle: TextStyle(
                                                fontSize:
                                                    ScreenUtil().setSp(25))),
                                        keyboardType: TextInputType.text,
                                        style: TextStyle(
                                            color: Color(0xff111111),
                                            fontSize: ScreenUtil().setSp(25)),
                                      ),
                                    ),
                                  ),
                                  SizedBoxResponsive(height: 30),
                                  ContainerResponsive(
                                    margin: EdgeInsetsResponsive.only(
                                        right: 35, left: 35),
                                    child: TextResponsive(
                                      'sectionAr'.tr(),
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize: 26,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  SizedBoxResponsive(height: 10),
                                  ContainerResponsive(
                                    margin: EdgeInsetsResponsive.only(
                                        right: 30, left: 30, top: 5),
                                    height: 70,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Color(0xffF8F8F8),
                                    ),
                                    child: Padding(
                                      padding:
                                          EdgeInsetsResponsive.only(left: 15),
                                      child: TextField(
                                        controller: secAr,
                                        decoration: InputDecoration(
                                            prefixStyle: TextStyle(
                                                fontSize:
                                                    ScreenUtil().setSp(25)),
                                            border: InputBorder.none,
                                            hintText: 'enterSecAr'.tr(),
                                            hintStyle: TextStyle(
                                                fontSize:
                                                    ScreenUtil().setSp(25))),
                                        keyboardType: TextInputType.text,
                                        style: TextStyle(
                                            color: Color(0xff111111),
                                            fontSize: ScreenUtil().setSp(25)),
                                      ),
                                    ),
                                  ),
                                  SizedBoxResponsive(height: 20),
                                  ContainerResponsive(
                                    margin: EdgeInsetsResponsive.only(
                                        right: 35, left: 35),
                                    child: TextResponsive(
                                      'state'.tr(),
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize: 26,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsResponsive.only(
                                        right: 30, left: 30, top: 5),
                                    child: DropdownButton(
                                      items: statesItems(status),
                                      onChanged: (int value) {
                                        setState(() {
                                          isRequired = value;
                                          hint = context.locale == Locale('ar')
                                              ? status[value].nameAr
                                              : status[value].name;
                                        });
                                      },
                                      hint: ContainerResponsive(
                                          margin: EdgeInsetsResponsive.only(
                                              top: 5, left: 5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              TextResponsive(
                                                hint,
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          )),
                                    ),
                                  ),
                                  SizedBoxResponsive(
                                    height: 40,
                                  ),
                                ],
                              ),
                        ContainerResponsive(
                          margin:
                              EdgeInsetsResponsive.only(left: 35, right: 35),
                          child: TextResponsive(
                            'productDescription'.tr(),
                            style: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontSize: 26,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        SizedBoxResponsive(height: 5),
                        ContainerResponsive(
                          margin: EdgeInsetsResponsive.only(
                              left: 20, right: 20, top: 5),
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Color(0xffF8F8F8),
                          ),
                          child: Padding(
                            padding: EdgeInsetsResponsive.only(left: 15),
                            child: TextField(
                              controller: description,
                              maxLines: null,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'enterProductDescription'.tr(),
                                  hintStyle: TextStyle(
                                      fontSize:
                                          ScreenUtil().setSp(25).toDouble())),
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                  color: Color(0xff111111),
                                  fontSize: ScreenUtil().setSp(25).toDouble()),
                            ),
                          ),
                        ),
                        SizedBoxResponsive(height: 20),
                        ContainerResponsive(
                          margin:
                              EdgeInsetsResponsive.only(left: 35, right: 35),
                          child: TextResponsive(
                            'productDescriptionAr'.tr(),
                            style: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontSize: 26,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        SizedBoxResponsive(height: 5),
                        ContainerResponsive(
                          margin: EdgeInsetsResponsive.only(
                              left: 20, right: 20, top: 5),
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Color(0xffF8F8F8),
                          ),
                          child: Padding(
                            padding: EdgeInsetsResponsive.only(left: 15),
                            child: TextField(
                              controller: descriptionAr,
                              maxLines: null,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'enterProductDescriptionAr'.tr(),
                                  hintStyle: TextStyle(
                                      fontSize:
                                          ScreenUtil().setSp(25).toDouble())),
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                  color: Color(0xff111111),
                                  fontSize: ScreenUtil().setSp(25).toDouble()),
                            ),
                          ),
                        ),
                        SizedBoxResponsive(height: 20),
                        GestureDetector(
                          onTap: () {
                            if (_profileImage == null) {
                              Fluttertoast.showToast(
                                  msg: "enterPhoto".tr(),
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.redAccent,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                              return;
                            } else if (name.text.trim().length < 0) {
                              Fluttertoast.showToast(
                                  msg: "enterProductName".tr(),
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.redAccent,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                              return;
                            } else if (nameAr.text.trim().length < 0) {
                              Fluttertoast.showToast(
                                  msg: "enterProductNameAr".tr(),
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.redAccent,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                              return;
                            } else if (selectedCategoryId == null) {
                              Fluttertoast.showToast(
                                  msg: "chooseCategory".tr(),
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.redAccent,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                              return;
                            } else if (price.text.trim().length < 0) {
                              Fluttertoast.showToast(
                                  msg: "enterUnitPrice".tr(),
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.redAccent,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                              return;
                            } else if (description.text.trim().length <= 0) {
                              Fluttertoast.showToast(
                                  msg: "enterProductDescription".tr(),
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.redAccent,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                              return;
                            } else if (descriptionAr.text.trim().length <= 0) {
                              Fluttertoast.showToast(
                                  msg: "enterProductDescriptionAr".tr(),
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.redAccent,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                              return;
                            } else if (weightCont.text.trim().length == 0) {
                              Fluttertoast.showToast(
                                  msg: "enterWeight".tr(),
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.redAccent,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                              return;
                            } else if (sec.text.trim().length == 0 &&
                                chosenParent != 0) {
                              Fluttertoast.showToast(
                                  msg: "enterSec".tr(),
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.redAccent,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                              return;
                            } else if (secAr.text.trim().length == 0 &&
                                chosenParent != 0) {
                              Fluttertoast.showToast(
                                  msg: "enterSecAr".tr(),
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.redAccent,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                              return;
                            }

                            createProduct(
                                tag: tag.text,
                                sec: sec.text,
                                isReq: isRequired.toString(),
                                secAr: secAr.text,
                                parent: chosenParent,
                                name: name.text,
                                nameAr: nameAr.text,
                                description: description.text,
                                descriptionAr: descriptionAr.text,
                                price: price.text,
                                unit: cityID,
                                weig: weightCont.text,
                                shop: '1');
                          },
                          child: ContainerResponsive(
                            margin: EdgeInsetsResponsive.only(
                                right: 30, left: 30, top: 5),
                            height: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Theme.of(context).primaryColor,
                            ),
                            child: Padding(
                                padding: EdgeInsetsResponsive.only(left: 0),
                                child: Center(
                                  child: TextResponsive(
                                    'add'.tr(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 26,
                                        fontWeight: FontWeight.w600),
                                  ),
                                )),
                          ),
                        ),
                        SizedBoxResponsive(height: 20),
                      ],
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
