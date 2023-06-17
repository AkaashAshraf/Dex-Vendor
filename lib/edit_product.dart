import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mplus_provider/models/categories.dart';
import 'package:mplus_provider/models/product.dart';
import 'package:mplus_provider/setting_pages/notification_page.dart';
import 'package:mplus_provider/ui/widgets/loading.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

import 'globals.dart';
import 'media_pick.dart';

class EditProduct extends StatefulWidget {
  final Product product;
  final String type;
  EditProduct({this.product, this.type});
  @override
  _EditProductState createState() => _EditProductState(product);
}

class Status {
  String name;
  String nameAr;
  int id;
  Status({this.name, this.id, this.nameAr});
}

class _EditProductState extends State<EditProduct> {
  Product _product;
  _EditProductState(this._product);

  var width, height;
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
  List<Product> parents = [];
  List<DropdownMenuItem<String>> _dropParents = [];
  String _currentParent;
  int chosenParent = 0;
  List<String> values = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      for (int i = 0; i < myProducts.length; i++) {
        if (myProducts[i].parent == 0 &&
            myProducts[i].id != widget.product.id) {
          parents.add(myProducts[i]);
        }
      }
      tag.text = _product.tags.toString();
      name.text = _product.name;
      nameAr.text = _product.nameAr;
      description.text = _product.description;
      descriptionAr.text = _product.descriptionAr;
      price.text = _product.price.toString();
      weightCont.text = _product.weight.toString().split(" ")[0];
      selectedCategoryId = _product.categories.toString();
      _dropCity = getDropCatsSub(units);
      _dropParents = getParents(parents);
      _currentCities =
          context.locale == Locale('ar') ? _product.unitAr : _product.unit;
      _dropParents.forEach((element) => values.add(element.value));
      if (widget.type != 'add') {
        _currentParent = _dropParents[0].value;
      } else {
        for (int i = 0; i < myProducts.length; i++) {
          if (myProducts[i].id == widget.product.parent &&
              values.contains(myProducts[i].name)) {
            _currentParent = myProducts[i].name;
            chosenParent = myProducts[i].id;
            isRequired = int.parse(widget.product.isReq);
            sec.text = widget.product.section;
            secAr.text = widget.product.sectionAr;
            break;
          } else {
            _currentParent = _dropParents[0].value;
          }
        }
      }
      getFromSF();
      _getCategories();
      setState(() {});
    });
  }

  var shopId;

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

  onChangeDropdownItem(String selectedCity) {
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
            value: '${category.id}',
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  category.name,
                ),
              ],
            )),
      );
      item.add(category.id.toString());
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

  List<Status> status = [
    Status(id: 0, name: 'optional', nameAr: 'اختياري'),
    Status(id: 1, name: 'Required', nameAr: 'يجب اختياره'),
    Status(
        id: 2,
        name: 'Choose One from section',
        nameAr: 'اختر واحد من هذه الفئة'),
  ];

  List<DropdownMenuItem<int>> statesItems(List<Status> list) {
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
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  ContainerResponsive(
                    margin: EdgeInsetsResponsive.only(right: 35, top: 15),
                    child: TextResponsive(
                      'editProduct'.tr(),
                      style:
                          TextStyle(fontSize: 48, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBoxResponsive(
          height: 50,
        ),
        Center(child: Load(150.0))
      ],
    );
  }

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

  Future editProduct(
      {String name,
      String nameAr,
      String tag,
      String sec,
      String secAr,
      String isReq,
      int parent,
      String description,
      String descriptionAr,
      String price,
      String shop,
      int unit,
      String weig}) async {
    try {
      setState(() {
        loading = true;
      });

      print('SHOP ID $shopId');

      FormData data = FormData.fromMap({
        'parent': parent,
        'tags': tag,
        'section': '$sec',
        'sectionAr': '$secAr',
        'isRequired': '$isReq',
        'productId': _product.id.toString(),
        'name': '$name',
        'name_ar': '$nameAr',
        'description': '$description',
        'description_ar': '$descriptionAr',
        'categories': '$selectedCategoryId',
        'price': '$price',
        'weight': '$weig',
        'unit': '$unit',
      });
      var response =
          await dioClient.post(baseURL + 'updateProductInfo', data: data);
      print('RESPONSE ${response.data}');

      setState(() {
        loading = false;
      });
      if (response != null) {
        Fluttertoast.showToast(
            msg: "editProductDone".tr(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.white,
            textColor: Color(0xff34C961),
            fontSize: 16.0);
        setState(() {
          bottomSelectedIndex = 0;
        });
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

  Future editImg(
      {String name,
      String nameAr,
      String tag,
      String sec,
      String secAr,
      String isReq,
      int parent,
      String description,
      String descriptionAr,
      String price,
      String shop,
      int unit,
      String weig}) async {
    try {
      setState(() {
        loading = true;
      });

      print('SHOP ID $shopId');

      FormData data = FormData.fromMap({
        'productId': _product.id.toString(),
        'img': await MultipartFile.fromFile(_profileImage.path,
            filename: 'basha_$name _ $price'),
      });
      var response =
          await dioClient.post(baseURL + 'updateProductImg', data: data);
      print('RESPONSE ${response.data}');

      setState(() {
        loading = false;
      });
      if (response != null) {
        Fluttertoast.showToast(
            msg: "editPhotoDone".tr(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.white,
            textColor: Color(0xff34C961),
            fontSize: 16.0);
        setState(() {
          bottomSelectedIndex = 3;
        });
        editProduct(
            tag: tag,
            parent: parent,
            sec: sec,
            secAr: secAr,
            isReq: isReq,
            name: name,
            nameAr: nameAr,
            description: description,
            descriptionAr: descriptionAr,
            price: price,
            unit: unit,
            weig: weig,
            shop: shop);
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

  String _currentCities;
  List uns = [];

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
            child: TextResponsive(a,
                style: TextStyle(
                  fontSize: 25,
                ))),
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
            width: 150,
            child: TextResponsive(a,
                style: TextStyle(
                  fontSize: 25,
                ))),
      ));
    }
    return items;
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
            ? homeLoad()
            : SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBoxResponsive(
                      height: 70,
                    ),
                    appBar(
                        context: context,
                        backButton: true,
                        title: 'editProduct'.tr()),
                    SizedBoxResponsive(
                      height: 40,
                    ),
                    ContainerResponsive(
                      width: 660,
                      height: 190,
                      margin: EdgeInsetsResponsive.only(
                          right: 15, top: 10, left: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return ContainerResponsive(
                                    width: width * 20,
                                    height: height * 14,
                                    margin: EdgeInsetsResponsive.all(5),
                                    decoration: BoxDecoration(
                                      color: Color(0xffF8F8F8),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Stack(
                                      children: <Widget>[
                                        Center(
                                          child: ContainerResponsive(
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
                                        ContainerResponsive(
                                          margin: EdgeInsetsResponsive.only(
                                              right: 3, left: 3, top: 0),
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
                          SizedBox(
                            width: width * 1,
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
                              width: 120,
                              height: 400,
                              margin: EdgeInsetsResponsive.all(2),
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
                    SizedBoxResponsive(
                      height: 30,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ContainerResponsive(
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
                        SizedBoxResponsive(height: 5),
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
                              padding: EdgeInsetsResponsive.only(
                                  right: 10, left: 10),
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
                        SizedBoxResponsive(height: 20),
                        ContainerResponsive(
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
                        SizedBoxResponsive(height: 5),
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
                              padding: EdgeInsetsResponsive.only(
                                  right: 10, left: 10),
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
                        SizedBoxResponsive(height: 20),
                        Row(
                          children: [
                            ContainerResponsive(
                              width: 300,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsetsResponsive.only(
                                        right: 30, left: 30),
                                    child: TextResponsive(
                                      'parentsProduct'.tr(),
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize: 26,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  SizedBoxResponsive(height: 5),
                                  ContainerResponsive(
                                    margin: EdgeInsetsResponsive.only(
                                      right: 30,
                                      left: 30,
                                    ),
                                    height: 70,
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
                                                  : parents
                                                      .where((product) =>
                                                          value == product.name)
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ContainerResponsive(
                                  margin: EdgeInsetsResponsive.only(
                                      right: 30, left: 30),
                                  child: TextResponsive(
                                    'category'.tr(),
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor,
                                        fontSize: 26,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                SizedBoxResponsive(height: 5),
                                ContainerResponsive(
                                  margin: EdgeInsetsResponsive.only(
                                      right: 30, left: 30),
                                  height: 70,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Color(0xffF8F8F8),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      ContainerResponsive(
                                        margin: EdgeInsetsResponsive.symmetric(
                                            horizontal: 15),
                                        child: DropdownButton<String>(
                                          icon: Icon(
                                            Icons.arrow_drop_down,
                                            color: Colors.black,
                                          ),
                                          hint: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              TextResponsive(
                                                  'chooseCategory'.tr(),
                                                  style:
                                                      TextStyle(fontSize: 22)),
                                            ],
                                          ),
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.grey[800]),
                                          value: selectedCategory == null
                                              ? item[categoryIds
                                                  .indexOf(_product.categories)]
                                              : selectedCategory,
                                          items: _dropdownMenuItems,
                                          onChanged: (value) {
                                            selectedCategory = value;
                                            selectedCategoryId = categoryIds[
                                                item.indexOf(value)];
                                            setState(() {});
                                            print(
                                                ' Selected Id $selectedCategoryId');
                                          },
                                          iconDisabledColor: Colors.white,
                                          iconEnabledColor: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBoxResponsive(height: 40),
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
                                  SizedBoxResponsive(height: 5),
                                  ContainerResponsive(
                                    margin: EdgeInsetsResponsive.only(
                                        right: 30, left: 30, top: 5),
                                    height: 65,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Color(0xffF8F8F8),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsetsResponsive.symmetric(
                                          horizontal: 10),
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
                                  ContainerResponsive(
                                    margin: EdgeInsetsResponsive.only(
                                        right: 15, left: 15),
                                    child: TextResponsive(
                                      'type'.tr(),
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize: 26,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  SizedBoxResponsive(height: 5),
                                  ContainerResponsive(
                                    width: 300,
                                    margin: EdgeInsetsResponsive.only(
                                        right: 10, left: 10, top: 5),
                                    height: 65,
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
                                                  top: 5, left: 5),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Icon(Icons.arrow_drop_down),
                                                  TextResponsive('unit'.tr()),
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
                                      'weight'.tr(),
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontFamily: 'JF-Flat',
                                          fontSize: 26,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  SizedBoxResponsive(
                                    height: 5,
                                  ),
                                  ContainerResponsive(
                                    margin: EdgeInsetsResponsive.only(
                                        right: 30, left: 30, top: 5),
                                    height: 65,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Color(0xffF8F8F8),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsetsResponsive.only(
                                          right: 10, left: 10),
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
                        SizedBoxResponsive(height: 30),
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
                                  SizedBoxResponsive(height: 20),
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
                                        right: 30, left: 30),
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
                                    height: 30,
                                  ),
                                ],
                              ),
                        ContainerResponsive(
                          margin:
                              EdgeInsetsResponsive.only(right: 35, left: 35),
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
                              right: 30, left: 30, top: 5),
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Color(0xffF8F8F8),
                          ),
                          child: ContainerResponsive(
                            padding:
                                EdgeInsetsResponsive.symmetric(horizontal: 5),
                            child: TextField(
                              controller: description,
                              maxLines: null,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'enterProductDescription'.tr(),
                                  hintStyle: TextStyle(
                                      fontSize:
                                          ScreenUtil().setSp(22).toDouble())),
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                color: Color(0xff111111),
                              ),
                            ),
                          ),
                        ),
                        SizedBoxResponsive(height: 10),
                        ContainerResponsive(
                          margin:
                              EdgeInsetsResponsive.only(right: 35, left: 35),
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
                              right: 30, left: 30, top: 5),
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Color(0xffF8F8F8),
                          ),
                          child: ContainerResponsive(
                            padding:
                                EdgeInsetsResponsive.symmetric(horizontal: 5),
                            child: TextField(
                              controller: descriptionAr,
                              maxLines: null,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'enterProductDescriptionAr'.tr(),
                                  hintStyle: TextStyle(
                                      fontSize:
                                          ScreenUtil().setSp(22).toDouble())),
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                color: Color(0xff111111),
                              ),
                            ),
                          ),
                        ),
                        SizedBoxResponsive(height: 40),
                        GestureDetector(
                          onTap: () {
                            if (name.text.trim().length < 0) {
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

                            if (_profileImage == null) {
                              editProduct(
                                  tag: tag.text,
                                  sec: sec.text,
                                  secAr: secAr.text,
                                  isReq: isRequired.toString(),
                                  parent: chosenParent,
                                  name: name.text,
                                  nameAr: nameAr.text,
                                  description: description.text,
                                  descriptionAr: descriptionAr.text,
                                  price: price.text,
                                  unit: cityID,
                                  weig: weightCont.text,
                                  shop: '1');
                            } else {
                              editImg(
                                  tag: tag.text,
                                  sec: sec.text,
                                  secAr: secAr.text,
                                  isReq: isRequired.toString(),
                                  parent: chosenParent,
                                  name: name.text,
                                  nameAr: nameAr.text,
                                  description: description.text,
                                  descriptionAr: descriptionAr.text,
                                  price: price.text,
                                  unit: cityID,
                                  weig: weightCont.text,
                                  shop: '1');
                            }
                          },
                          child: Center(
                            child: ContainerResponsive(
                              margin: EdgeInsetsResponsive.only(
                                  right: 30, left: 30, top: 5),
                              height: 90,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Theme.of(context).primaryColor,
                              ),
                              child: Padding(
                                  padding: EdgeInsetsResponsive.only(right: 0),
                                  child: Center(
                                    child: TextResponsive(
                                      'editProduct'.tr(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 26,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  )),
                            ),
                          ),
                        ),
                        SizedBoxResponsive(height: 30),
                      ],
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
