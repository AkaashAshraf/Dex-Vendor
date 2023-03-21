import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mplus_provider/models/cities.dart';
import 'package:mplus_provider/ui/widgets/loading.dart';
import 'package:progress_dialog/progress_dialog.dart';
import '../../media_pick.dart';
import '../../models/user.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../globals.dart';
import '../notification_page.dart';

class Profile extends StatefulWidget {
  User user;

  Profile(this.user);

  @override
  _ProfileState createState() => _ProfileState(user);
}

class _ProfileState extends State<Profile> {
  List<DropdownMenuItem<String>> buildDropdownMenuItems(List countries) {
    List<DropdownMenuItem<String>> items = [];
    for (City city in cities) {
      items.add(
        DropdownMenuItem(
          value: context.locale == Locale('ar') ? city.nameAr : city.name,
          child: Text(
            context.locale == Locale('ar') ? city.nameAr : city.name,
            textAlign: TextAlign.right,
          ),
        ),
      );
      item.add(context.locale == Locale('ar') ? city.nameAr : city.name);
      citiesIds.add('${city.id}');
    }
    return items;
  }

  TextEditingController name = new TextEditingController();
  TextEditingController phone = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController address = new TextEditingController();
  TextEditingController pass1 = new TextEditingController();
  TextEditingController pass2 = new TextEditingController();
  TextEditingController oldPass = new TextEditingController();
  String cityId;
  List<DropdownMenuItem<String>> _dropdownMenuItems = [];
  String selectedCountry;
  List<String> item = [];
  List<String> citiesIds = [];
  onChangeDropdownItem(String selectedCity) {
    print(selectedCity);
    setState(() {
      selectedCountry = selectedCity;
      cityId = citiesIds[item.indexOf(selectedCity)];

      print('$cityId');
    });
  }

  Future updateUser() async {
    try {
      _pr.show();
      FormData data = new FormData.fromMap({
        'uid': user.id,
        'first_name': name.text,
        'last_name': '',
        'email': email.text,
        'address': address.text,
        'userCity': '$cityId',
      });
      var response =
          await dioClient.post(baseURL + 'updateUserInfo', data: data);
      print('RESPONSE ${response.data}');

      _pr.hide();
      if (response.data.toString().contains("sucess")) {
        Fluttertoast.showToast(
            msg: "doneSuccessfully".tr(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.of(context).popUntil(ModalRoute.withName('home'));
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

  Future updatePassword() async {
    try {
      _pr.show();
      FormData data = new FormData.fromMap({
        'uid': user.id,
        'old_password': oldPass.text,
        'password': pass2.text,
      });
      var response =
          await dioClient.post(baseURL + 'updateUserPassword', data: data);
      print('RESPONSE ${response.data}');

      _pr.hide();
      if (response.data["Response"] == "1") {
        Fluttertoast.showToast(
            msg: "doneSuccessfully".tr(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: response.data["Data"],
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

  File _profileImage = File('');

  Future updateImage() async {
    try {
      _pr.show();
      FormData data = new FormData.fromMap({
        'uid': user.id,
        'img':
            await MultipartFile.fromFile(_profileImage.path, filename: 'basha'),
      });
      var response =
          await dioClient.post(baseURL + 'updateUserProfileImg', data: data);
      print('RESPONSE ${response.data}');

      _pr.hide();
      if (response.data.toString().contains("sucess")) {
        Fluttertoast.showToast(
            msg: "doneSuccessfully".tr(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: response.data["Data"],
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

  User user;
  _ProfileState(this.user);

  var width;

  var _pr;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _dropdownMenuItems = buildDropdownMenuItems(cities);

      _pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal,
          isDismissible: false,
          showLogs: true);
      _pr.style(
          message: 'editingProfile'.tr(),
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
              color: Colors.black,
              fontSize: 19.0,
              fontWeight: FontWeight.w600));
      name.text = user.firstName.toString();
      phone.text = user.loginPhone.toString();
      email.text = user.email.toString();
      address.text = user.address.toString();
      if (user.city == '4' ||
          user.city == '5' ||
          user.city == '6' ||
          user.city == '7' ||
          user.city == '3') {
        selectedCountry =
            cities[citiesIds.indexOf(user.city.toString())] != null
                ? context.locale == Locale('ar')
                    ? cities[citiesIds.indexOf(user.city.toString())].nameAr
                    : cities[citiesIds.indexOf(user.city.toString())].name
                : context.locale == Locale('ar')
                    ? cities[0].nameAr
                    : cities[0].name;
      } else {
        selectedCountry =
            context.locale == Locale('ar') ? cities[0].nameAr : cities[0].name;
      }
      cityId = user.city.toString() != null ? user.city.toString() : 3;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width / 100;

    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: EdgeInsets.only(top: 25),
                height: 40,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                        right: 15,
                        top: 5,
                        child: Container(
                            width: 55,
                            height: 35,
                            child: FlatButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              NotificationPage()));
                                },
                                child: Image.asset(
                                  'images/ring.PNG',
                                  fit: BoxFit.contain,
                                )))),
                    Positioned(
                        left: 45,
                        top: 12,
                        child: Text(
                          'personalData'.tr(),
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w600),
                        )),
                    Positioned(
                        left: 5,
                        top: 0,
                        child: IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: Color(0xff575757),
                              size: 28,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            })),
                  ],
                ),
              ),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    child: Image.asset('images/bottom_town.png',
                        fit: BoxFit.cover, height: 175))),
            Container(
              margin: EdgeInsets.only(top: 60),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 50,
                    ),
                    Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: 115,
                            height: 115,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(width: 1, color: Colors.grey),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                              margin: EdgeInsets.only(left: 0, top: 8),
                              width: 100,
                              height: 100,
                              padding: EdgeInsets.all(0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: CachedNetworkImage(
                                width: 100,
                                height: 100,
                                imageUrl: baseImageURL + user.image.toString(),
                                fit: BoxFit.contain,
                                placeholder: (context, url) => ImageLoad(100.0),
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                  'images/image404.png',
                                  width: 55,
                                  height: 55,
                                ),
                              )
                              /*CachedNetworkImage(
                                      imageUrl: baseImageURL+user.image,
                                      fit: BoxFit.contain,
                                      placeholder: (context, url) => Center(child: Image.ass width: 55,height: 55,)),
                                      errorWidget: (context, url, error) => Image.asset('images/image404.png',width: 20,height: 20,),
                                    )*/
                              ),
                        ),
                        Positioned(
                          left: 0,
                          top: 70,
                          right: 100,
                          child: GestureDetector(
                            onTap: () async {
                              var pickedFile = await showDialog(
                                  context: context,
                                  builder: (context) => MediaPickDialog());
                              if (pickedFile != null) {
                                setState(() {
                                  _profileImage = pickedFile;
                                });

                                updateImage();
                              }
                            },
                            child: Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 5, color: Colors.white),
                                  color: Color(0xff34C961),
                                  shape: BoxShape.circle),
                              child: Center(
                                child: Icon(
                                  Icons.photo_camera,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Text(user.firstName.toString(),
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey,
                          )),
                    ),

                    SizedBox(
                      height: 10,
                    ),

                    Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Text(
                        'userName'.tr(),
                        style: TextStyle(
                            color: Theme.of(context).accentColor, fontSize: 15),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 17, left: 20, top: 5),
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xffF1F1F1)),
                        borderRadius: BorderRadius.circular(5),
                        color: Color(0xffF1F1F1),
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                        child: TextField(
                          controller: name,
                          enabled: true,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.edit,
                                color: Theme.of(context).primaryColor,
                                size: 15,
                              ),
                              labelStyle: TextStyle(fontSize: 13),
                              alignLabelWithHint: true),
                          keyboardType: TextInputType.text,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Color(0xff111111),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 5,
                    ),

                    Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Text(
                        'phoneNumber'.tr(),
                        style: TextStyle(
                            color: Theme.of(context).accentColor, fontSize: 15),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 17, left: 20, top: 5),
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xffF1F1F1)),
                        borderRadius: BorderRadius.circular(5),
                        color: Color(0xffF1F1F1),
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                        child: TextField(
                          enabled: true,
                          controller: phone,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.phone_iphone,
                                color: Theme.of(context).primaryColor,
                                size: 15,
                              ),
                              hintStyle: TextStyle(fontSize: 13)),
                          textAlign: TextAlign.left,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                            color: Color(0xff111111),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 5,
                    ),

                    Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Text(
                        'email'.tr(),
                        style: TextStyle(
                            color: Theme.of(context).accentColor, fontSize: 15),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 17, left: 20, top: 5),
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xffF1F1F1)),
                        borderRadius: BorderRadius.circular(5),
                        color: Color(0xffF1F1F1),
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                        child: TextField(
                          controller: email,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.email,
                                color: Theme.of(context).primaryColor,
                                size: 15,
                              ),
                              labelStyle: TextStyle(fontSize: 13)),
                          keyboardType: TextInputType.text,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Color(0xff111111),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20, top: 5),
                      child: Text(
                        'city'.tr(),
                        style: TextStyle(
                            color: Theme.of(context).accentColor, fontSize: 16),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 17, right: 20, top: 5),
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xffF8F8F8),
                      ),
                      child: Container(
                        height: 48,
                        margin: EdgeInsets.only(left: 10, right: 10),
                        child: DropdownButton<String>(
                          hint: Text(
                            'chooseCity'.tr(),
                            textAlign: TextAlign.left,
                          ),
                          style:
                              TextStyle(fontSize: 13, color: Colors.grey[500]),
                          value: selectedCountry,
                          items: _dropdownMenuItems,
                          onChanged: (String value) {
                            setState(() {
                              selectedCountry = value;
                              cityId = citiesIds[item.indexOf(value)];
                            });
                          },
                          iconDisabledColor: Colors.white,
                          iconEnabledColor: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    // SizedBox(height: 5,),
                    // Container(
                    //   margin: EdgeInsets.only(left: 20),
                    //   child: Text(
                    //     'العنوان',
                    //     style: TextStyle(color: Color(0xff111111), fontSize: 15),
                    //     textAlign: TextAlign.left,
                    //   ),
                    // ),
                    // SizedBox(height: 5,),
                    // Container(
                    //   margin: EdgeInsets.only(left: 17,left: 20,top: 5),
                    //   height: 40,
                    //   decoration: BoxDecoration(
                    //     border: Border.all(color: Color(0xffF1F1F1)),
                    //     borderRadius: BorderRadius.circular(5),
                    //     color:Color(0xffF1F1F1),
                    //   ),
                    //   child: Padding(
                    //     padding: const EdgeInsets.only(left: 8.0),
                    //     child: TextField(
                    //       enabled: true,
                    //       controller: address,
                    //       decoration: InputDecoration(
                    //           border: InputBorder.none,
                    //           prefixIcon: Icon(
                    //             Icons.place,
                    //             color: Color(0xffFBB746),
                    //             size: 15,

                    //           ),
                    //           hintStyle: TextStyle(fontSize: 13)),
                    //       textAlign: TextAlign.left,
                    //       keyboardType: TextInputType.text,
                    //       style: TextStyle(
                    //         color: Color(0xff111111),
                    //       ),
                    //     ),
                    //   ),
                    // ),

                    SizedBox(
                      height: 20,
                    ),

                    SizedBox(
                      height: 120,
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            top: 60,
                            child: GestureDetector(
                              onTap: () {
                                updateUser();
                              },
                              child: Container(
                                  width: MediaQuery.of(context).size.width /
                                      100 *
                                      91,
                                  margin: EdgeInsets.only(
                                      right: 17, left: 20, top: 5),
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  child: Center(
                                    child: Text(
                                      'confirm'.tr(),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 17),
                                    ),
                                  )),
                            ),
                          ),
                          Positioned(
                            top: 10,
                            child: GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      String _value;
                                      return Scaffold(
                                        backgroundColor: Colors.transparent,
                                        body: Center(
                                          child: Container(
                                              height: 380,
                                              width: width * 78,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 10),
                                                    child: Text(
                                                      'oldPassword',
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xff111111),
                                                          fontFamily: 'JF-Flat',
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        right: 7,
                                                        left: 20,
                                                        top: 5),
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      color: Color(0xffF8F8F8),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 8,
                                                              vertical: 7),
                                                      child: TextField(
                                                        controller: oldPass,
                                                        decoration: InputDecoration(
                                                            border: InputBorder
                                                                .none,
                                                            hintText:
                                                                'enterOldPassword'
                                                                    .tr(),
                                                            hintStyle: TextStyle(
                                                                fontSize: 13,
                                                                fontFamily:
                                                                    'JF-Flat')),
                                                        textAlign:
                                                            TextAlign.left,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xff111111),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Container(
                                                    height: 1,
                                                    color: Colors.grey.shade200,
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 10),
                                                    child: Text(
                                                      'password'.tr(),
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xff111111),
                                                          fontFamily: 'JF-Flat',
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        right: 7,
                                                        left: 20,
                                                        top: 5),
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      color: Color(0xffF8F8F8),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 8,
                                                              vertical: 7),
                                                      child: TextField(
                                                        controller: pass1,
                                                        decoration: InputDecoration(
                                                            border: InputBorder
                                                                .none,
                                                            hintText:
                                                                'enterThePassword'
                                                                    .tr(),
                                                            hintStyle: TextStyle(
                                                                fontSize: 13,
                                                                fontFamily:
                                                                    'JF-Flat')),
                                                        textAlign:
                                                            TextAlign.left,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xff111111),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 10),
                                                    child: Text(
                                                      'reenterPassword'.tr(),
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xff111111),
                                                          fontFamily: 'JF-Flat',
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        right: 7,
                                                        left: 10,
                                                        top: 5),
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      color: Color(0xffF8F8F8),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 8,
                                                              vertical: 7),
                                                      child: TextField(
                                                        controller: pass2,
                                                        decoration:
                                                            InputDecoration(
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                                hintText:
                                                                    'reenterPassword'
                                                                        .tr(),
                                                                hintStyle:
                                                                    TextStyle(
                                                                  fontSize: 13,
                                                                  fontFamily:
                                                                      'JF-Flat',
                                                                )),
                                                        textAlign:
                                                            TextAlign.left,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xff111111),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      if (pass1.text !=
                                                          pass2.text) {
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                "passwordsNotMatched"
                                                                    .tr(),
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                            gravity:
                                                                ToastGravity
                                                                    .BOTTOM,
                                                            backgroundColor:
                                                                Colors.red,
                                                            textColor:
                                                                Colors.white,
                                                            fontSize: 16.0);
                                                      } else {
                                                        Navigator.pop(context);
                                                        updatePassword();
                                                      }
                                                    },
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          right: 7,
                                                          left: 10,
                                                          top: 25),
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        color:
                                                            Color(0xff34C961),
                                                      ),
                                                      child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 8.0),
                                                          child: Center(
                                                            child: Text(
                                                              'confirm'.tr(),
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                          )),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                        ),
                                      );
                                    });
                              },
                              child: Container(
                                  width: MediaQuery.of(context).size.width /
                                      100 *
                                      91,
                                  margin: EdgeInsets.only(
                                      right: 17, left: 20, top: 5),
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Theme.of(context).accentColor,
                                  ),
                                  child: Center(
                                    child: Text(
                                      'changePassword'.tr(),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    ),
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
