import 'dart:io' as io;

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mplus_provider/login_register_screens/CodeValidation.dart';
import 'package:mplus_provider/login_register_screens/register_shop.dart';
import 'package:mplus_provider/setting_pages/rules_page.dart';
import 'package:mplus_provider/ui/widgets/loading.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:mplus_provider/models/cities.dart';
import 'package:mplus_provider/models/user.dart';
import 'package:easy_localization/easy_localization.dart';
import '../globals.dart';
import '../media_pick.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var _profileImage;
  var name = TextEditingController();
  var phone = TextEditingController();
  var email = TextEditingController();
  var password = TextEditingController();

  var hidePass = true;
  var acceptRules = false;
  var loading = false;
  // User user;
  var selectedCountry;
  var cityId;
  List<String> citiesIds = [];
  List<String> item = [];

  onChangeDropdownItem(String selectedCity) {
    print(selectedCity);
    setState(() {
      selectedCountry = selectedCity;
      cityId = citiesIds[item.indexOf(selectedCity)];

      print('CityId is $cityId');
    });
  }

  List<DropdownMenuItem<String>> _dropdownMenuItems = [];

  var _name, _password, _email, _phone;

  var phoneIsoCode;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      phoneIsoCode = '+968';
      _dropdownMenuItems = buildDropdownMenuItems(cities);
      selectedCountry =
          context.locale == Locale('ar') ? cities[0].nameAr : cities[0].name;
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
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 25, color: Colors.black),
          ),
        ),
      );
      item.add(context.locale == Locale('ar') ? city.nameAr : city.name);
      citiesIds.add('${city.id}');
    }
    return items;
  }

  Future createUser(String name, String password, String email, String phone,
      io.File image) async {
    try {
      setState(() {
        loading = true;
      });
      var data = FormData.fromMap({
        'login_phone': _phone,
        'password': '$password',
        'first_name': name,
        'customer_type': '3',
        'email': email,
        'userCity': '$cityId',
      });
      var response = await dioClient.post(baseURL + 'creatUser', data: data);
      setState(() {
        loading = false;
      });
      print('REGISTER New $response');

      if (response.data['State'] == 'sucess') {
        dynamic data = response.data['Data'];
        user = User.fromJson(data);
        Fluttertoast.showToast(
            msg: "registered".tr(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.white,
            textColor: Color(0xff34C961),
            fontSize: 16.0);
        Fluttertoast.showToast(
            msg: "enterStoreDetails".tr(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.white,
            textColor: Color(0xff34C961),
            fontSize: 16.0);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => CodeValidation(
                      phoneNumber: _phone,
                    )));
      } else {
        Fluttertoast.showToast(
            msg: response.data['Data'],
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
      child: Scaffold(
          backgroundColor: Color(0xffFFFFFF),
          body: Container(
            child: ListView(
              children: <Widget>[
                SizedBoxResponsive(height: 150),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      // Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (context) => RegisterShopScreen(
                      //           customerId: '0',
                      //         )));
                    },
                    child: ContainerResponsive(
                        width: 250,
                        height: 250,
                        margin: EdgeInsetsResponsive.fromLTRB(0, 0, 0, 5),
                        child: Image.asset(
                          'images/logo.png',
                          fit: BoxFit.fill,
                        )),
                  ),
                ),
                ContainerResponsive(
                  heightResponsive: true,
                  widthResponsive: true,
                  padding: EdgeInsetsResponsive.only(right: 25),
                  child: Center(
                      child: TextResponsive(
                    'createAccount'.tr(),
                    style: TextStyle(
                        color: Theme.of(context).accentColor, fontSize: 40),
                  )),
                ),
                SizedBoxResponsive(
                  height: 20,
                ),
                Visibility(
                  visible: false,
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(width: 1, color: Colors.black26),
//                      shape: BoxShape.circle,
                          ),
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
                          child: Container(
                            margin: EdgeInsets.only(top: 5),
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(color: Colors.black45),
                            child: _profileImage == null
                                ? Center(
                                    child: Icon(
                                      Icons.add_a_photo,
                                      size: 55,
                                      color: Colors.white,
                                    ),
                                  )
                                : Image.file(
                                    _profileImage,
                                    fit: BoxFit.fill,
                                  ),
                          ),
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
                  height: 10,
                ),
                ContainerResponsive(
                  heightResponsive: true,
                  widthResponsive: true,
                  margin:
                      EdgeInsetsResponsive.only(left: 35, top: 10, right: 35),
                  child: TextResponsive(
                    'userName'.tr(),
                    style: TextStyle(
                        color: Theme.of(context).accentColor, fontSize: 28),
                    // textAlign: TextAlign.left,
                  ),
                ),
                Center(
                  child: ContainerResponsive(
                    heightResponsive: true,
                    widthResponsive: true,
                    margin:
                        EdgeInsetsResponsive.only(right: 30, left: 30, top: 10),
                    padding: EdgeInsetsResponsive.symmetric(
                        horizontal: 15, vertical: 7),
                    height: 75,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xffF8F8F8),
                    ),
                    child: TextField(
                      textAlignVertical: TextAlignVertical.center,
                      controller: name,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'enterUsername'.tr(),
                          hintStyle: TextStyle(
                              fontSize: ScreenUtil().setSp(25).toDouble())),
                      // textAlign: TextAlign.left,
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
                  margin:
                      EdgeInsetsResponsive.only(left: 35, right: 35, top: 10),
                  child: TextResponsive(
                    'phoneNumber'.tr(),
                    style: TextStyle(
                        color: Theme.of(context).accentColor, fontSize: 28),
                    // textAlign: TextAlign.left,
                  ),
                ),
                Center(
                  child: ContainerResponsive(
                    margin:
                        EdgeInsetsResponsive.only(right: 30, left: 30, top: 10),
                    padding: EdgeInsetsResponsive.symmetric(horizontal: 15),
                    height: 75,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xffF8F8F8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        SizedBoxResponsive(
                          width: 10,
                        ),
                        Icon(
                          Icons.edit,
                          color: Theme.of(context).primaryColor,
                          size: 15,
                        ),
                        SizedBoxResponsive(
                          width: 20,
                        ),
                        ContainerResponsive(
                          height: 75,
                          child: DropdownButton<String>(
                            items: <String>[
                              '+968',
                              '+249',
                              '‎+966',
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: TextResponsive(
                                  value,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "CoconNextArabic",
                                      fontSize: 22),
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
                                  fontSize: 22),
                            ),
                            onChanged: (v) {
                              phoneIsoCode = v;
                              setState(() {});
                            },
                          ),
                        ),
                        SizedBoxResponsive(width: 20),
                        Expanded(
                          child: ContainerResponsive(
                            padding: EdgeInsetsResponsive.symmetric(
                                horizontal: 15, vertical: 10),
                            child: TextField(
                              onEditingComplete: () {
                                setState(() {});
                              },
                              maxLength: phoneIsoCode == '+968' ? 8 : 9,
                              controller: phone,
                              enabled: true,
                              decoration: InputDecoration(
                                  counterText: '',
                                  border: InputBorder.none,
                                  labelStyle: TextStyle(fontSize: 13),
                                  alignLabelWithHint: true),
                              keyboardType: TextInputType.phone,
                              // textAlign: TextAlign.left,
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
                  height: 10,
                ),
                ContainerResponsive(
                  heightResponsive: true,
                  widthResponsive: true,
                  margin:
                      EdgeInsetsResponsive.only(left: 35, right: 35, top: 10),
                  child: TextResponsive(
                    'email'.tr(),
                    style: TextStyle(
                        color: Theme.of(context).accentColor, fontSize: 28),
                    // textAlign: TextAlign.left,
                  ),
                ),
                Center(
                  child: ContainerResponsive(
                    heightResponsive: true,
                    widthResponsive: true,
                    margin:
                        EdgeInsetsResponsive.only(right: 30, left: 30, top: 10),
                    padding: EdgeInsetsResponsive.symmetric(
                        horizontal: 15, vertical: 10),
                    height: 75,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xffF8F8F8),
                    ),
                    child: TextField(
                      textAlignVertical: TextAlignVertical.center,
                      controller: email,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'enterEmail'.tr(),
                          hintStyle: TextStyle(
                              fontSize: ScreenUtil().setSp(25).toDouble())),
                      // textAlign: TextAlign.left,
                      keyboardType: TextInputType.emailAddress,
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
                  margin:
                      EdgeInsetsResponsive.only(left: 35, right: 35, top: 10),
                  child: TextResponsive(
                    'city'.tr(),
                    style: TextStyle(
                        color: Theme.of(context).accentColor, fontSize: 28),
                    // textAlign: TextAlign.left,
                  ),
                ),
                SizedBoxResponsive(
                  height: 0,
                ),
                Center(
                  child: ContainerResponsive(
                    heightResponsive: true,
                    widthResponsive: true,
                    margin:
                        EdgeInsetsResponsive.only(right: 30, left: 30, top: 10),
                    height: 75,
                    width: 655,
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
                          style:
                              TextStyle(fontSize: 25, color: Colors.grey[500]),
                        ),
                        style: TextStyle(fontSize: 25, color: Colors.grey[500]),
                        value: selectedCountry,
                        items: _dropdownMenuItems,
                        onChanged: (value) {
                          setState(() {
                            selectedCountry = value;
                            cityId = citiesIds[item.indexOf(value)];
                          });
                        },
                      ),
                    ),
                  ),
                ),
                SizedBoxResponsive(
                  height: 10,
                ),
                ContainerResponsive(
                  margin:
                      EdgeInsetsResponsive.only(left: 35, right: 35, top: 10),
                  child: TextResponsive(
                    'password'.tr(),
                    style: TextStyle(
                        color: Theme.of(context).accentColor, fontSize: 28),
                    // textAlign: TextAlign.left,
                  ),
                ),
                ContainerResponsive(
                    heightResponsive: true,
                    widthResponsive: true,
                    margin:
                        EdgeInsetsResponsive.only(right: 30, left: 30, top: 10),
                    height: 75,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xffF8F8F8),
                    ),
                    child: Row(
                      children: <Widget>[
                        ContainerResponsive(
                            heightResponsive: true,
                            widthResponsive: true,
                            width: 100,
                            child: FlatButton(
                                onPressed: () {
                                  setState(() {
                                    hidePass
                                        ? hidePass = false
                                        : hidePass = true;
                                    print(hidePass);
                                  });
                                },
                                child: Image.asset(
                                  hidePass
                                      ? 'images/closeeye.png'
                                      : 'images/openeye.png',
                                  width: 40,
                                  height: 40,
                                ))),
                        ContainerResponsive(
                          heightResponsive: true,
                          widthResponsive: true,
                          width: 540,
                          height: 70,
                          padding: EdgeInsetsResponsive.symmetric(
                              horizontal: 15, vertical: 10),
                          child: TextField(
                            controller: password,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'enterPassword'.tr(),
                              hintStyle: TextStyle(
                                  fontSize: ScreenUtil().setSp(25).toDouble()),
                            ),
                            // textAlign: TextAlign.left,
                            obscureText: hidePass ? true : false,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil().setSp(30).toDouble()),
                          ),
                        ),
                      ],
                    )),
                Center(
                  child: ContainerResponsive(
                    heightResponsive: true,
                    widthResponsive: true,
                    margin: EdgeInsetsResponsive.all(0),
                    child: Padding(
                      padding: EdgeInsetsResponsive.only(left: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      RulesPage(from: 'logIn')));
                            },
                            child: TextResponsive(
                              'terms'.tr(),
                              style: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontSize: 20,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          TextResponsive(
                            'accept'.tr(),
                            style: TextStyle(color: Colors.black, fontSize: 20),
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
                        child: ImageLoad(50.0),
                      ),
                      ContainerResponsive(
                        height: 50,
                        child: Center(
                          child: TextResponsive('creatingAccount'.tr(),
                              style: TextStyle(fontSize: 25)),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBoxResponsive(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    _name = name.text;
                    _phone = phoneIsoCode.toString() + phone.text;
                    _password = password.text;
                    _email = email.text;

                    if (_name.length < 5) {
                      Fluttertoast.showToast(
                          msg: "shortName".tr(),
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.redAccent,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      return;
                    } else if (phoneIsoCode == '+968' &&
                        phone.text.length != 8) {
                      Fluttertoast.showToast(
                          msg: "shortPhone8".tr(),
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.redAccent,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      return;
                    } else if (phoneIsoCode != '+968' &&
                        phone.text.length != 9) {
                      Fluttertoast.showToast(
                          msg: "shortPhone9",
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
                    }
                    // else if (_email.contains("@") == false) {
                    //   Fluttertoast.showToast(
                    //       msg: "قم بكتابة بريدك الالكتروني اولا",
                    //       toastLength: Toast.LENGTH_SHORT,
                    //       gravity: ToastGravity.BOTTOM,
                    //       timeInSecForIos: 1,
                    //       backgroundColor: Colors.redAccent,
                    //       textColor: Colors.white,
                    //       fontSize: 16.0);
                    //   return;
                    // }
                    else if (_password.length < 6) {
                      Fluttertoast.showToast(
                          msg: "shortPassword".tr(),
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
                    }

                    createUser(_name, _password, _email, _phone, _profileImage);
                  },
                  child: Center(
                    child: ContainerResponsive(
                      heightResponsive: true,
                      widthResponsive: true,
                      margin: EdgeInsetsResponsive.only(
                          left: 30, right: 30, top: 10, bottom: 0),
                      padding: EdgeInsetsResponsive.only(right: 15),
                      height: 75,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Center(
                        child: TextResponsive(
                          'createAccount'.tr(),
                          style: TextStyle(color: Colors.white, fontSize: 28),
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
                    ContainerResponsive(
                      heightResponsive: true,
                      widthResponsive: true,
                      margin: EdgeInsetsResponsive.only(top: 20),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TextResponsive(
                              'alreadyHaveAccount'.tr(),
                              style:
                                  TextStyle(color: Colors.black, fontSize: 28),
                            ),
                            GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginScreen()));
                                },
                                child: TextResponsive(
                                  'pressHere'.tr(),
                                  style: TextStyle(
                                    color: Theme.of(context).accentColor,
                                    fontSize: 28,
                                    decoration: TextDecoration.underline,
                                  ),
                                  textAlign: TextAlign.center,
                                )),
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
}
