import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mplus_provider/home.dart';
import 'package:mplus_provider/location_screen.dart';
import 'package:mplus_provider/models/cities.dart';
import 'package:mplus_provider/models/shops.dart';
import 'package:mplus_provider/setting_pages/rules_page.dart';
import 'package:mplus_provider/ui/widgets/loading.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:responsive_widgets/responsive_widgets.dart';

import '../globals.dart';
import '../media_pick.dart';
import 'login_screen.dart';

class RegisterShopScreen extends StatefulWidget {
  final String customerId;
  RegisterShopScreen({this.customerId});

  @override
  _RegisterShopScreenState createState() =>
      _RegisterShopScreenState(this.customerId);
}

class _RegisterShopScreenState extends State<RegisterShopScreen> {
  String customerId;
  _RegisterShopScreenState(this.customerId);

  var _profileImage;
  var licenseImage;
  var licenseImageName;
  var selectedDate;
  var pr;
  var name = TextEditingController();
  var nameAr = TextEditingController();
  var phone = TextEditingController();
  var shopSerialNumber = TextEditingController();
  var details = TextEditingController();
  var address = TextEditingController();
  var fieldId = TextEditingController();
  var isStore;
  var isResturants;
  var selectedColor;
  var hidePass = true;
  var acceptRules = false;
  var loading = false;

  var phoneIsoCode;

  var _name, _nameAr, _address, _details, _phone, _fieldId, _shopSerialNumber;

  List<DropdownMenuItem<String>> _dropdownMenuItems = [];
  var selectedCountry;
  List<String> citiesIds = [];
  List<String> item = [];
  var cityId;

  onChangeDropdownItem(String selectedCity) {
    print(selectedCity);
    setState(() {
      selectedCountry = selectedCity;
      cityId = citiesIds[item.indexOf(selectedCity)];

      print('CityID is $cityId');
    });
  }

  @override
  void initState() {
    phoneIsoCode = '+968';
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _dropdownMenuItems = buildDropdownMenuItems(cities);
      setState(() {});
    });
  }

  List<DropdownMenuItem<String>> buildDropdownMenuItems(List countries) {
    List<DropdownMenuItem<String>> items = [];
    for (City city in cities) {
      items.add(
        DropdownMenuItem(
          value: context.locale == Locale('ar') ? city.nameAr : city.name,
          child: TextResponsive(
            context.locale == Locale('ar') ? city.nameAr : city.name,
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 20, color: Colors.grey[500]),
          ),
        ),
      );
      item.add(context.locale == Locale('ar') ? city.nameAr : city.name);
      citiesIds.add('${city.id}');
    }
    selectedCountry = item[0];
    return items;
  }

  Future<Null> selectDate(BuildContext context) async {
    final picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        initialDatePickerMode: DatePickerMode.year,
        firstDate: DateTime.now(),
        lastDate: DateTime(2050));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future getShopData(var id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
//${prefs.getString('user_id')}
      log(baseURL + 'getMyShops/OrderBy&iddealerId&$id');
      var response = await dioClient
          .get(baseURL + 'getMyShops/OrderBy&iddealerId&22'); //!add id

      print('RESPONSE Shop  ${response.data}');
      if (response.data != '') {
        print('RESPONSE MESSAGE ${response.data}');
        var data = response.data;
        print("BEFORE");
        shop = Shop.fromJson(response.data);
        prefs.setString('shop_id', '${shop.id}');

        setState(() {
          loading = false;
        });
        Fluttertoast.showToast(
            msg: "تم إنشاء المتجر بنجاح",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.white,
            textColor: Color(0xff34C961),
            fontSize: 16.0);
        setState(() {
          bottomSelectedIndex = 3;
        });
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
      } else {
        setState(() {
          loading = false;
        });
        Fluttertoast.showToast(
            msg: "حاول مره اخرى",
            toastLength: Toast.LENGTH_SHORT,
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

  Future createShop(
      {String name,
      String nameAr,
      String details,
      String city,
      String shopSerialNumber,
      String address,
      String lat,
      String long,
      String phone,
      String fieldId,
      String customerId,
      int isResturant,
      int isStore}) async {
    try {
      setState(() {
        loading = true;
      });

      FormData data;

      if (_profileImage != null) {
        data = new FormData.fromMap({
          'name': '$name',
          'name_ar': '$nameAr',
          'phone': '$phone',
          'description': '$details',
          'dealer_id': '$customerId',
          'address': '$address',
          'shopSerialNumber': '$shopSerialNumber',
          'longitude': long ?? '',
          'Latitude': lat ?? '',
          'shopCity': '$cityId',
          'isStore': isStore,
          'isRestrunent': isResturant,
          'licenseEndDate': selectedDate.year.toString() +
              '/' +
              selectedDate.month.toString() +
              "/" +
              selectedDate.day.toString(),
          'licenseImage': licenseImageName,
          'Img': await MultipartFile.fromFile(_profileImage.path,
              filename: 'basha_$customerId'),
        });
      } else {
        data = new FormData.fromMap({
          'name': '$name',
          'phone': '$phone',
          'shopSerialNumber': '$shopSerialNumber',
          'description': '$details',
          'dealer_id': '$customerId',
          'address': '$address',
          'longitude': long ?? '',
          'Latitude': lat ?? '',
          'shopCity': '$cityId',
          'isStore': isStore,
          'isRestrunent': isResturant,
          'licenseEndDate': selectedDate.year.toString() +
              '/' +
              selectedDate.month.toString() +
              "/" +
              selectedDate.day.toString(),
          'licenseImage': licenseImageName
        });
      }

      log(data.fields.toString());

      var response = await dioClient.post(baseURL + 'creatShop', data: data);
      print('RESPONSE Create ${response.data}');

      if (response.toString() == "1") {
        getShopData(customerId);
      } else {
        setState(() {
          loading = false;
        });

        Fluttertoast.showToast(
            msg: response.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } on DioError catch (error) {
      loading = false;
      setState(() {});
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
      loading = false;
      setState(() {});
      throw error;
    }
  }

  void deleteImg(img) {
    if (img == licenseImageName) {
      licenseImage = File('');
    }
  }

  void changeImg(img, imgName) {
    if (img == licenseImage) {
      licenseImageName = imgName;
    }
  }

  Future getImgUrl(File image, imgName) async {
    try {
      await pr.show();
      FormData data = FormData.fromMap({
        'img': await MultipartFile.fromFile(image.path),
      });

      var response = await Dio().post(
        baseURL + 'uploadimage',
        data: data,
      );
      print('REGISTER  $response');
      await pr.hide();
      if (response != null) {
        imgName = response.data;

        changeImg(image, imgName);
      } else {
        deleteImg(image);

        setState(() {});
        await Fluttertoast.showToast(
            msg: 'tryAgain'.tr(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            //timeInSecForIos: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        return response;
      }
    } on DioError catch (error) {
      deleteImg(image);

      setState(() {});
      await Fluttertoast.showToast(
          msg: 'tryAgain'.tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          //timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      await pr.hide();

      switch (error.type) {
        case DioErrorType.connectTimeout:
        case DioErrorType.sendTimeout:
        case DioErrorType.cancel:

          // rethrow;
          return error;

          break;
        default:
          rethrow;
      }
    } catch (error) {
      deleteImg(image);

      setState(() {});
      await Fluttertoast.showToast(
          msg: "error",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          //timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      await pr.hide();
      return error;
    }
  }

  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context, isDismissible: false);
    pr.style(
        message: '...الرجاء الانتظار',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        // progress: 0,
        // maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
    ResponsiveWidgets.init(context,
        height: 1560, width: 720, allowFontScaling: true);
//    Size size = MediaQuery.of(context).size;
    return ResponsiveWidgets.builder(
      height: 1560,
      width: 720,
      child: Scaffold(
          backgroundColor: Color(0xffFFFFFF),
          body: Container(
            // decoration: BoxDecoration(
            //   image: DecorationImage(
            //     image: AssetImage('images/background.png'),
            //     fit: BoxFit.cover,
            //   ),
            // ),
            child: ListView(
              children: <Widget>[
                Center(
                  child: ContainerResponsive(
                      width: 200,
                      height: 200,
                      margin: EdgeInsetsResponsive.fromLTRB(0, 150, 0, 5),
                      child: Image.asset(
                        'images/logo.png',
                        fit: BoxFit.fill,
                      )),
                ),
                Center(
                    child: ContainerResponsive(
                  heightResponsive: true,
                  widthResponsive: true,
                  margin: EdgeInsetsResponsive.only(right: 10),
                  child: TextResponsive(
                    'createAccount'.tr(),
                    style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 35,
                        fontWeight: FontWeight.w600),
                  ),
                )),
                SizedBoxResponsive(
                  height: 20,
                ),
                Visibility(
                  visible: true,
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.center,
                        child: ContainerResponsive(
                          heightResponsive: true,
                          widthResponsive: true,
                          width: 190,
                          height: 198,
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              border:
                                  Border.all(width: 1, color: Colors.black26),
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: GestureDetector(
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
                              margin: EdgeInsetsResponsive.only(top: 5),
                              width: 180,
                              height: 187,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).accentColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: _profileImage == null
                                  ? Center(
                                      child: Icon(
                                        Icons.add_a_photo,
                                        size: 55,
                                        color: Colors.white,
                                      ),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.file(
                                        _profileImage,
                                        fit: BoxFit.fill,
                                      ),
                                    )),
                        ),
                      ),
                      Visibility(
                        visible: false,
                        child: Positioned(
                          left: 0,
                          top: 65,
                          right: 100,
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 5, color: Colors.white),
                                color: Color(0xff34C961),
                                shape: BoxShape.circle),
                            child: Center(
                              child: FlatButton.icon(
                                  onPressed: null,
                                  icon: Icon(
                                    Icons.photo_camera,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  label: Text('')),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBoxResponsive(
                  height: 20,
                ),
                ContainerResponsive(
                  margin: EdgeInsetsResponsive.symmetric(horizontal: 35),
                  child: TextResponsive(
                    'storeName'.tr(),
                    style: TextStyle(
                        color: Theme.of(context).accentColor, fontSize: 26),
                    textAlign: TextAlign.right,
                  ),
                ),
                SizedBoxResponsive(
                  height: 5,
                ),
                ContainerResponsive(
                  margin:
                      EdgeInsetsResponsive.only(right: 30, left: 30, top: 5),
                  height: 75,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xffF8F8F8),
                  ),
                  child: Padding(
                    padding: EdgeInsetsResponsive.symmetric(
                        horizontal: 15, vertical: 10),
                    child: TextField(
                      controller: name,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'enterStoreName'.tr(),
                          hintStyle: TextStyle(
                              fontSize: ScreenUtil().setSp(25).toDouble())),
                      textAlign: TextAlign.right,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: ScreenUtil().setSp(30).toDouble()),
                    ),
                  ),
                ),
                SizedBoxResponsive(
                  height: 20,
                ),
                ContainerResponsive(
                  margin: EdgeInsetsResponsive.symmetric(horizontal: 35),
                  child: TextResponsive(
                    'storeNameAr'.tr(),
                    style: TextStyle(
                        color: Theme.of(context).accentColor, fontSize: 26),
                    textAlign: TextAlign.right,
                  ),
                ),
                SizedBoxResponsive(
                  height: 5,
                ),
                ContainerResponsive(
                  margin:
                      EdgeInsetsResponsive.only(right: 30, left: 30, top: 5),
                  height: 75,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xffF8F8F8),
                  ),
                  child: Padding(
                    padding: EdgeInsetsResponsive.symmetric(
                        horizontal: 15, vertical: 10),
                    child: TextField(
                      controller: nameAr,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'enterStoreNameAr'.tr(),
                          hintStyle: TextStyle(
                              fontSize: ScreenUtil().setSp(25).toDouble())),
                      textAlign: TextAlign.right,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: ScreenUtil().setSp(30).toDouble()),
                    ),
                  ),
                ),
                SizedBoxResponsive(
                  height: 20,
                ),
                ContainerResponsive(
                  heightResponsive: true,
                  widthResponsive: true,
                  margin: EdgeInsetsResponsive.symmetric(horizontal: 35),
                  child: TextResponsive(
                    'storeSerial'.tr(),
                    style: TextStyle(
                        color: Theme.of(context).accentColor, fontSize: 26),
                    textAlign: TextAlign.right,
                  ),
                ),
                SizedBoxResponsive(
                  height: 5,
                ),
                ContainerResponsive(
                  heightResponsive: true,
                  widthResponsive: true,
                  margin:
                      EdgeInsetsResponsive.only(right: 30, left: 30, top: 5),
                  height: 75,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xffF8F8F8),
                  ),
                  child: Padding(
                    padding: EdgeInsetsResponsive.symmetric(
                        horizontal: 15, vertical: 10),
                    child: TextField(
                      controller: shopSerialNumber,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'enterSerialNum'.tr(),
                          hintStyle: TextStyle(
                              fontSize: ScreenUtil().setSp(25).toDouble())),
                      textAlign: TextAlign.right,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: ScreenUtil().setSp(30).toDouble()),
                    ),
                  ),
                ),
                SizedBoxResponsive(
                  height: 20,
                ),
                ContainerResponsive(
                  heightResponsive: true,
                  widthResponsive: true,
                  margin: EdgeInsetsResponsive.symmetric(horizontal: 35),
                  child: TextResponsive(
                    'storeDetails'.tr(),
                    style: TextStyle(
                        color: Theme.of(context).accentColor, fontSize: 26),
                    textAlign: TextAlign.right,
                  ),
                ),
                SizedBoxResponsive(
                  height: 5,
                ),
                ContainerResponsive(
                  heightResponsive: true,
                  widthResponsive: true,
                  margin:
                      EdgeInsetsResponsive.only(right: 30, left: 30, top: 5),
                  height: 75,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xffF8F8F8),
                  ),
                  child: Padding(
                    padding: EdgeInsetsResponsive.symmetric(
                        horizontal: 15, vertical: 10),
                    child: TextField(
                      controller: details,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'enterStoreDetails'.tr(),
                          hintStyle: TextStyle(
                              fontSize: ScreenUtil().setSp(25).toDouble())),
                      textAlign: TextAlign.right,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: ScreenUtil().setSp(30).toDouble()),
                    ),
                  ),
                ),
                SizedBoxResponsive(
                  height: 10,
                ),
                ContainerResponsive(
                  heightResponsive: true,
                  widthResponsive: true,
                  margin: EdgeInsetsResponsive.only(right: 35, top: 10),
                  child: TextResponsive(
                    'phoneNumber'.tr(),
                    style: TextStyle(
                        color: Theme.of(context).accentColor, fontSize: 26),
                    textAlign: TextAlign.right,
                  ),
                ),
                SizedBoxResponsive(
                  height: 5,
                ),
                ContainerResponsive(
                  margin:
                      EdgeInsetsResponsive.only(right: 30, left: 30, top: 5),
                  height: 75,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xffF8F8F8),
                  ),
                  child: Padding(
                    padding: EdgeInsetsResponsive.only(right: 15, top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        SizedBoxResponsive(
                          width: 30,
                        ),
                        Icon(
                          Icons.edit,
                          color: Theme.of(context).primaryColor,
                          size: 15,
                        ),
                        SizedBoxResponsive(width: 20),
                        DropdownButton<String>(
                          items: <String>[
                            '+968',
                            '+249',
                            '‎+966',
                          ].map((String value) {
                            return new DropdownMenuItem<String>(
                              value: value,
                              child: new TextResponsive(
                                value,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: "CoconNextArabic",
                                    fontSize: (22)),
                              ),
                            );
                          }).toList(),
                          underline: ContainerResponsive(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                            ),
                          ),
                          hint: TextResponsive(
                            phoneIsoCode == null ? '+968' : phoneIsoCode,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: "CoconNextArabic",
                                fontSize: (22)),
                          ),
                          onChanged: (v) {
                            phoneIsoCode = v.toString();
                            setState(() {});
                          },
                        ),
                        Expanded(
                          child: ContainerResponsive(
                            heightResponsive: true,
                            widthResponsive: true,
                            padding: EdgeInsetsResponsive.symmetric(
                                horizontal: 15, vertical: 10),
                            child: TextField(
                              maxLength: phoneIsoCode == '+968' ? 8 : 9,
                              enabled: true,
                              controller: phone,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '',
                                  counterText: '',
                                  hintStyle: TextStyle(fontSize: 13)),
                              textAlign: TextAlign.left,
                              keyboardType: TextInputType.phone,
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBoxResponsive(
                  height: 20,
                ),
                ContainerResponsive(
                  margin: EdgeInsetsResponsive.only(right: 35, top: 10),
                  child: TextResponsive(
                    'city'.tr(),
                    style: TextStyle(
                        color: Theme.of(context).accentColor, fontSize: 26),
                    textAlign: TextAlign.right,
                  ),
                ),
                SizedBoxResponsive(
                  height: 5,
                ),
                ContainerResponsive(
                  heightResponsive: true,
                  widthResponsive: true,
                  margin:
                      EdgeInsetsResponsive.only(right: 30, left: 30, top: 5),
                  height: 75,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xffF8F8F8),
                  ),
                  child: ContainerResponsive(
                    heightResponsive: true,
                    widthResponsive: true,
                    height: 48,
                    margin: EdgeInsetsResponsive.only(left: 20, right: 20),
                    child: DropdownButton<String>(
                      hint: TextResponsive(
                        'chooseCity'.tr(),
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 20, color: Colors.grey[500]),
                      ),
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(20).toDouble(),
                          color: Colors.grey[500]),
                      value: selectedCountry,
                      items: _dropdownMenuItems,
                      onChanged: (String value) {
                        setState(() {
                          selectedCountry = value;
                          cityId = citiesIds[item.indexOf(value)];

                          print('CityID is $cityId');
                        });
                      },
                      iconDisabledColor: Colors.white,
                      iconEnabledColor: Colors.white,
                    ),
                  ),
                ),
                SizedBoxResponsive(
                  height: 10,
                ),
                ContainerResponsive(
                  margin: EdgeInsetsResponsive.only(right: 35, top: 10),
                  child: TextResponsive(
                    'storeAddress'.tr(),
                    style: TextStyle(
                        color: Theme.of(context).accentColor, fontSize: 26),
                    textAlign: TextAlign.right,
                  ),
                ),
                SizedBoxResponsive(
                  height: 5,
                ),
                ContainerResponsive(
                  heightResponsive: true,
                  widthResponsive: true,
                  margin:
                      EdgeInsetsResponsive.only(right: 30, left: 30, top: 5),
                  height: 75,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xffF8F8F8),
                  ),
                  child: Padding(
                    padding: EdgeInsetsResponsive.symmetric(
                        horizontal: 15, vertical: 10),
                    child: TextField(
                      controller: address,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'storeAddress'.tr(),
                          hintStyle: TextStyle(
                              fontSize: ScreenUtil().setSp(25).toDouble())),
                      textAlign: TextAlign.right,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: ScreenUtil().setSp(30).toDouble()),
                    ),
                  ),
                ),
                SizedBoxResponsive(
                  height: 10,
                ),
                ContainerResponsive(
                  heightResponsive: true,
                  widthResponsive: true,
                  margin: EdgeInsetsResponsive.only(right: 35, top: 10),
                  child: TextResponsive(
                    'locationMap'.tr(),
                    style: TextStyle(
                        color: Theme.of(context).accentColor, fontSize: 26),
                    textAlign: TextAlign.right,
                  ),
                ),
                SizedBoxResponsive(
                  height: 5,
                ),
                GestureDetector(
                  onTap: () async {
                    locationSelected = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductLocation()));
                  },
                  child: ContainerResponsive(
                      heightResponsive: true,
                      widthResponsive: true,
                      margin: EdgeInsetsResponsive.only(
                          right: 30, left: 30, top: 5),
                      height: 75,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xffF8F8F8),
                      ),
                      child: ContainerResponsive(
                        heightResponsive: true,
                        widthResponsive: true,
                        margin: EdgeInsetsResponsive.only(left: 20, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            locationSelected
                                ? Icon(
                                    Icons.check_circle,
                                    size: 20,
                                    color: Color(0xff34C961),
                                  )
                                : Icon(
                                    Icons.location_on,
                                    size: 16,
                                    color: Theme.of(context).primaryColor,
                                  ),
                            Text(locationSelected
                                ? 'done'.tr()
                                : 'chooseLoc'.tr()),
                          ],
                        ),
                      )),
                ),
                SizedBoxResponsive(
                  height: 10,
                ),
                ContainerResponsive(
                  heightResponsive: true,
                  widthResponsive: true,
                  margin: EdgeInsetsResponsive.only(right: 35, top: 10),
                  child: TextResponsive(
                    'storeLicense'.tr(),
                    style: TextStyle(
                        color: Theme.of(context).accentColor, fontSize: 26),
                    textAlign: TextAlign.right,
                  ),
                ),
                SizedBoxResponsive(
                  height: 5,
                ),
                ContainerResponsive(
                  heightResponsive: true,
                  widthResponsive: true,
                  margin:
                      EdgeInsetsResponsive.only(right: 30, left: 30, top: 5),
                  height: 75,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xffF8F8F8),
                  ),
                  child: Padding(
                    padding: EdgeInsetsResponsive.symmetric(
                        horizontal: 15, vertical: 10),
                    child: TextField(
                      controller: fieldId,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'enterStoreLicenseDate'.tr(),
                          hintStyle: TextStyle(
                              fontSize: ScreenUtil().setSp(25).toDouble())),
                      textAlign: TextAlign.right,
                      keyboardType: TextInputType.phone,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: ScreenUtil().setSp(30).toDouble()),
                    ),
                  ),
                ),
                SizedBoxResponsive(height: 10),
                ContainerResponsive(
                  heightResponsive: true,
                  widthResponsive: true,
                  margin: EdgeInsetsResponsive.only(right: 35, top: 10),
                  child: TextResponsive(
                    'storeLicenseImg'.tr(),
                    style: TextStyle(
                        color: Theme.of(context).accentColor, fontSize: 26),
                    textAlign: TextAlign.right,
                  ),
                ),
                ContainerResponsive(
                    margin:
                        EdgeInsetsResponsive.only(right: 30, left: 30, top: 10),
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xffF8F8F8),
                    ),
                    child: GestureDetector(
                      onTap: () async {
                        var pickedFile = await showDialog(
                            context: context,
                            builder: (context) => MediaPickDialog());
                        if (pickedFile != null)
                          setState(() {
                            licenseImage = pickedFile;
                          });
                        await getImgUrl(licenseImage, licenseImageName);
                      },
                      child: ContainerResponsive(
                        margin: EdgeInsetsResponsive.only(left: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            licenseImage == null
                                ? Icon(Icons.camera_alt,
                                    color: Colors.grey[500],
                                    size: ScreenUtil().setSp(40).toDouble())
                                : Icon(Icons.check,
                                    color: Theme.of(context).accentColor,
                                    size: ScreenUtil().setSp(40).toDouble()),
                            TextResponsive(
                              licenseImage == null
                                  ? 'insertImg'.tr()
                                  : 'photoChoosed'.tr(),
                              style: TextStyle(fontSize: 20),
                            )
                          ],
                        ),
                      ),
                    )),
                SizedBoxResponsive(
                  height: 20,
                ),
                ContainerResponsive(
                  margin: EdgeInsetsResponsive.only(right: 35, top: 5),
                  child: TextResponsive(
                    "enterStoreLicenseDate",
                    style: TextStyle(
                        color: Theme.of(context).accentColor, fontSize: 25),
                    textAlign: TextAlign.right,
                  ),
                ),
                GestureDetector(
                    // color: Colors.white,
                    onTap: () {
                      FocusScope.of(context).unfocus();

                      selectDate(context);
                    },
                    child: ContainerResponsive(
                      alignment: Alignment.centerRight,
                      margin: EdgeInsetsResponsive.only(
                          right: 30, left: 30, top: 5),
                      padding: EdgeInsetsResponsive.only(right: 15, left: 15),
                      height: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xffF8F8F8),
                      ),
                      child: dobDropDown(context),
                    )),
                SizedBoxResponsive(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isStore = 1;
                          isResturants = 0;
                          selectedColor = "store";
                        });
                      },
                      child: ContainerResponsive(
                        padding: EdgeInsetsResponsive.symmetric(
                            vertical: 15, horizontal: 20),
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 2,
                              color: selectedColor == 'store'
                                  ? Theme.of(context).primaryColor
                                  : Colors.white,
                            )),
                        child: Center(
                          child: TextResponsive(
                            'store'.tr(),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBoxResponsive(width: 20),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isStore = 0;
                          isResturants = 1;
                          selectedColor = "resturant";
                        });
                      },
                      child: ContainerResponsive(
                        padding: EdgeInsetsResponsive.symmetric(
                            vertical: 15, horizontal: 20),
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 2,
                              color: selectedColor == 'resturant'
                                  ? Theme.of(context).primaryColor
                                  : Colors.white,
                            )),
                        child: Center(
                          child: TextResponsive(
                            'resturant'.tr(),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                ContainerResponsive(
                  heightResponsive: true,
                  widthResponsive: true,
                  margin: EdgeInsetsResponsive.only(left: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextResponsive(
                        'accept'.tr(),
                        style: TextStyle(color: Colors.black, fontSize: 17),
                      ),
                      SizedBoxResponsive(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => RulesPage(from: 'logIn')));
                        },
                        child: TextResponsive(
                          'terms'.tr(),
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: 17,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      Checkbox(
                        value: acceptRules ? true : false,
                        checkColor: Colors.white,
                        activeColor: Theme.of(context).primaryColor,
                        onChanged: (value) {
                          setState(() {
                            acceptRules
                                ? acceptRules = false
                                : acceptRules = true;
                          });
                          print(value);
                          value = value;
                        },
                      )
                    ],
                  ),
                ),
                SizedBoxResponsive(
                  height: 10,
                ),
                Visibility(
                  visible: loading ? true : false,
                  child: Column(
                    children: <Widget>[
                      ContainerResponsive(
                        heightResponsive: true,
                        widthResponsive: true,
                        height: 100,
                        child: ImageLoad(100.0),
                      ),
                      ContainerResponsive(
                        height: 50,
                        child: Center(
                          child: TextResponsive('creatingAccount'.tr(),
                              style: TextStyle(
                                fontSize: 20,
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBoxResponsive(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    _name = name.text;
                    _nameAr = nameAr.text;
                    _shopSerialNumber = shopSerialNumber.text;

                    _phone = phoneIsoCode.toString() + phone.text;
                    _details = details.text;
                    _address = address.text;
                    _fieldId = fieldId.text;

                    if (_name.length < 3) {
                      Fluttertoast.showToast(
                          msg: "shortName".tr(),
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.redAccent,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      return;
                    }
                    if (_nameAr.length < 3) {
                      Fluttertoast.showToast(
                          msg: "shortName".tr(),
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.redAccent,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      return;
                    }
                    if (_shopSerialNumber.length < 0) {
                      Fluttertoast.showToast(
                          msg: "checkSerial".tr(),
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.redAccent,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      return;
                    } else if (_details.trim().length == 0) {
                      Fluttertoast.showToast(
                          msg: "enterStoreDetails".tr(),
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.redAccent,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      return;
                    } else if (phoneIsoCode == '+968' &&
                        phone.text.length < 8) {
                      Fluttertoast.showToast(
                          msg: "writePhoneNumber".tr(),
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.redAccent,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      return;
                    } else if (selectedCountry == null) {
                      Fluttertoast.showToast(
                          msg: "chooseCity".tr(),
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.redAccent,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      return;
                    } else if (_address.trim().length == 0) {
                      Fluttertoast.showToast(
                          msg: 'writeAddress'.tr(),
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.redAccent,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      return;
                    } else if (locationSelected == null) {
                      Fluttertoast.showToast(
                          msg: "locationMap".tr(),
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.redAccent,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      return;
                    } else if (_fieldId.trim().length == 0) {
                      Fluttertoast.showToast(
                          msg: 'checkLicense'.tr(),
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.redAccent,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      return;
                    } else if (!acceptRules) {
                      Fluttertoast.showToast(
                          msg: "mustAccept".tr(),
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.redAccent,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      return;
                    } else if (licenseImage == null) {
                      Fluttertoast.showToast(
                          msg: "enterStoreLicenseImage".tr(),
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.redAccent,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      return;
                    } else if (selectedDate == null) {
                      Fluttertoast.showToast(
                          msg: "enterStoreLicenseDate".tr(),
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.redAccent,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      return;
                    } else if (selectedColor == null) {
                      Fluttertoast.showToast(
                          msg: "enterStoreType".tr(),
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.redAccent,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      return;
                    }

                    createShop(
                        phone: _phone,
                        name: _name,
                        nameAr: _nameAr,
                        details: _details,
                        address: _address,
                        shopSerialNumber: _shopSerialNumber,
                        city: selectedCountry,
                        customerId: customerId,
                        fieldId: _fieldId,
                        lat: '$lat',
                        long: '$lang',
                        isStore: isStore,
                        isResturant: isResturants);
                  },
                  child: Center(
                    child: ContainerResponsive(
                      heightResponsive: true,
                      widthResponsive: true,
                      margin: EdgeInsetsResponsive.only(
                          left: 30, right: 30, top: 10, bottom: 10),
                      height: 75,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Center(
                        child: TextResponsive(
                          'createAccount'.tr(),
                          style: TextStyle(color: Colors.white, fontSize: 26),
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: false,
                  child: Container(
                    margin: EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 1,
                          width: 100,
                          color: Color(0xffC1C1C1),
                        ),
                        Text('registerThrough'.tr()),
                        Container(
                          height: 1,
                          width: 100,
                          color: Color(0xffC1C1C1),
                        ),
                      ],
                    ),
                  ),
                ),
                Stack(
                  children: <Widget>[
                    Visibility(
                      visible: false,
                      child: Positioned(
                        top: 22,
                        right: 110,
                        child: Row(
                          children: <Widget>[
                            GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginScreen()));
                                },
                                child: Text(
                                  'pressHere'.tr(),
                                  style: TextStyle(
                                    color: Color(0xffFBB746),
                                    fontSize: 17,
                                    decoration: TextDecoration.underline,
                                  ),
                                  textAlign: TextAlign.center,
                                )),
                            Text(
                              ' لديك حساب بالفعل ؟ ',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }

  Text dobDropDown(BuildContext context) {
    if (selectedDate == null) {
      return TextResponsive(
        'enterStoreLicenseDate'.tr(),
        style: TextStyle(
          color: Colors.black45,
          fontSize: 20,
          fontFamily: 'CoconNextArabic',
        ),
      );
    } else {
      return TextResponsive(
        selectedDate.toString()[0] +
            selectedDate.toString()[1] +
            selectedDate.toString()[2] +
            selectedDate.toString()[3] +
            selectedDate.toString()[4] +
            selectedDate.toString()[5] +
            selectedDate.toString()[6] +
            selectedDate.toString()[7] +
            selectedDate.toString()[8] +
            selectedDate.toString()[9] +
            selectedDate.toString()[10],
        style: TextStyle(
          color: Colors.black,
          // fontWeight: FontWeight.bold,
          fontSize: (20),
          fontFamily: 'CoconNextArabic',
        ),
      );
    }
  }
}
