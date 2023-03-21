import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mplus_provider/models/cities.dart';
import 'package:mplus_provider/models/shops.dart';
import 'package:mplus_provider/ui/widgets/loading.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:progress_dialog/progress_dialog.dart';
import '../../location_screen.dart';
import '../../media_pick.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../globals.dart';

class StoreInfo extends StatefulWidget {
  final Shop shop;

  StoreInfo(this.shop);

  @override
  _StoreInfoState createState() => _StoreInfoState(this.shop);
}

class _StoreInfoState extends State<StoreInfo> {
  File _profileImage;
  File licenseImage;
  File _licenseImage;
  String _licenseImageName;
  String licenseImageName;
  DateTime selectedDate;
  TextEditingController name = new TextEditingController();
  TextEditingController nameAr = new TextEditingController();
  TextEditingController phone = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController website = new TextEditingController();
  TextEditingController shopSerialNumber = new TextEditingController();

  TextEditingController address = new TextEditingController();
  TextEditingController description = new TextEditingController();

  Text dobDropDown() {
    if (selectedDate == null) {
      return TextResponsive(
        'enterStoreLicenseDate'.tr(),
        style: TextStyle(
          color: Colors.black45,
          fontSize: 25,
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
          fontSize: (25),
          fontFamily: 'CoconNextArabic',
        ),
      );
    }
  }

  Future<Null> selectDate(BuildContext context) async {
    final picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime.now(),
        lastDate: DateTime(2050));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future updateShop() async {
    try {
      FormData data = new FormData.fromMap({
        "shopId": shop.id.toString(),
        "description": description.text.toString(),
        "name": name.text.toString(),
        "name_ar": nameAr.text.toString(),
        "phone": phone.text.toString(),
        "website": website.text.toString(),
        "shopSerialNumber": shopSerialNumber.text.toString(),
        "email": email.text.toString(),
        "address": address.text.toString(),
        "longitude": lang.toString(),
        "Latitude": lat.toString(),
        "city": cityId.toString(),
        "licenseImage": _licenseImageName != null
            ? _licenseImageName
            : shop.licenseImage.toString(),
        'licenseEndDate': selectedDate != null
            ? selectedDate.year.toString() +
                '/' +
                selectedDate.month.toString() +
                "/" +
                selectedDate.day.toString()
            : shop.licenseEndDate.toString(),
      });

      var response = await dioClient.post(baseURL + 'editShopInfo', data: data);
      var _data = response.data['Data'];
      shop = Shop.fromJson(_data);

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
      _pr.hide();
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

  Future editImg() async {
    try {
      FormData data = new FormData.fromMap({
        "shopId": shop.id.toString(),
        'img': await MultipartFile.fromFile(_profileImage.path,
            filename: shop.id.toString()),
      });
      var response = await dioClient.post(baseURL + 'editShopImg', data: data);
      print('RESPONSE ${response.data}');

      if (response != null) {
        Fluttertoast.showToast(
            msg: "photoHasBeenChangedSuccessfully".tr(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.white,
            textColor: Color(0xff34C961),
            fontSize: 16.0);

        updateShop();
      } else {
        _pr.hide();
        Fluttertoast.showToast(
            msg: response.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } on DioError catch (error) {
      _pr.hide();
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

  Shop shop;
  _StoreInfoState(this.shop);

  List<DropdownMenuItem<String>> _dropdownMenuItems = [];
  String selectedCountry;
  List<String> citiesIds = [];
  List<String> item = [];
  String cityId;

  onChangeDropdownItem(String selectedCity) {
    print(selectedCity);
    setState(() {
      selectedCountry = selectedCity;
      cityId = citiesIds[item.indexOf(selectedCity)];

      print('$cityId');
    });
  }

  Future getImgUrl(File image, imgName) async {
    try {
      await _pr.show();
      FormData data = FormData.fromMap({
        'img': await MultipartFile.fromFile(image.path),
      });

      var response = await Dio().post(
        baseURL + 'uploadimage',
        data: data,
      );
      print('REGISTER  $response');
      await _pr.hide();
      if (response != null) {
        imgName = response.data;
        _licenseImageName = imgName;
        print(_licenseImageName);
      } else {
        _licenseImage = File('');

        setState(() {});
        await _pr.hide();
        await Fluttertoast.showToast(
            msg: 'pleaseTryAgain'.tr(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            //timeInSecForIos: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        return response;
      }
    } on DioError catch (error) {
      _licenseImage = File('');

      setState(() {});
      await Fluttertoast.showToast(
          msg: 'pleaseTryAgain'.tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          //timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      await _pr.hide();

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
      _licenseImage = File('');

      setState(() {});
      await Fluttertoast.showToast(
          msg: "error",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          //timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      await _pr.hide();
      return error;
    }
  }

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

  ProgressDialog _pr;
  var type;
  bool locationSelected = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _dropdownMenuItems = buildDropdownMenuItems(cities);
      type = shop.isStore == 1 ? "store".tr() : "resturant".tr();

      name.text = shop.name == null ? "" : shop.name;
      nameAr.text = shop.nameAr == null ? "" : shop.nameAr.toString();
      phone.text = shop.Phone == null ? "" : shop.Phone;
      email.text = shop.email == null ? "" : shop.email;
      website.text = shop.website == null ? "" : shop.website;
      shopSerialNumber.text =
          shop.shopSerialNumber == null ? "" : shop.shopSerialNumber;

      description.text = shop.description == null ? "" : shop.description;
      address.text = shop.address == null ? "" : shop.address;
      selectedCountry =
          cities[citiesIds.indexOf(shop.shopCity.id.toString())] != null
              ? context.locale == Locale('ar')
                  ? cities[citiesIds.indexOf(shop.shopCity.id.toString())]
                      .nameAr
                  : cities[citiesIds.indexOf(shop.shopCity.id.toString())].name
              : context.locale == Locale('ar')
                  ? cities[0].nameAr
                  : cities[0].name;
      cityId = shop.shopCity != null ? shop.shopCity?.id.toString() : '3';

      lat = shop.Latitude;
      lang = shop.longitude;
      if (lat != null && lang != null) {
        locationSelected = true;
      }

      _pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal,
          isDismissible: false,
          showLogs: true);
      _pr.style(
          message: 'storDetailsBeingUpdating'.tr(),
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
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveWidgets.init(context,
        height: 1560, width: 720, allowFontScaling: true);

    return ResponsiveWidgets.builder(
      height: 1560,
      width: 720,
      allowFontScaling: true,
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    SizedBoxResponsive(height: 60),
                    appBar(
                      context: context,
                      backButton: true,
                      title: 'storeInfo'.tr(),
                    ),
                  ],
                ),
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      child: Image.asset('images/bottom_town.png',
                          fit: BoxFit.cover, height: 200, width: 720))),
              ContainerResponsive(
                heightResponsive: true,
                widthResponsive: true,
                margin: EdgeInsetsResponsive.only(top: 150),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBoxResponsive(
                        height: 40,
                      ),
                      Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.center,
                            child: ContainerResponsive(
                              heightResponsive: true,
                              widthResponsive: true,
                              width: 170,
                              height: 165,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border:
                                    Border.all(width: 1, color: Colors.grey),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: ContainerResponsive(
                                heightResponsive: true,
                                widthResponsive: true,
                                margin:
                                    EdgeInsetsResponsive.only(left: 0, top: 6),
                                width: 160,
                                height: 155,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
//                                child: Image.asset(
//                                  'images/fruit.PNG',
//                                  fit: BoxFit.contain,
//
//                                )
                                child: _profileImage == null
                                    ? CachedNetworkImage(
                                        imageUrl: baseImageURL + shop.image,
                                        fit: BoxFit.contain,
                                        placeholder: (context, url) =>
                                            ImageLoad(55.0),
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                          'images/image404.png',
                                          width: 20,
                                          height: 20,
                                        ),
                                      )
                                    : Image.file(_profileImage)),
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
                              heightResponsive: true,
                              widthResponsive: true,
                              margin: EdgeInsetsResponsive.only(
                                  right: 275, top: 100, left: 275),
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 5, color: Colors.white),
                                  color: Color(0xff34C961),
                                  shape: BoxShape.circle),
                              child: Center(
                                child: Icon(
                                  Icons.photo_camera,
                                  color: Colors.white,
                                  size: 13,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBoxResponsive(
                        height: 20,
                      ),
                      Center(
                        child: TextResponsive(shop.name.toString(),
                            style: TextStyle(
                              fontSize: 37,
                              color: Colors.grey,
                            )),
                      ),
                      ContainerResponsive(
                        margin: EdgeInsetsResponsive.only(left: 35, right: 35),
                        child: ContainerResponsive(
                            padding: EdgeInsetsResponsive.symmetric(
                                vertical: 15, horizontal: 15),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1,
                                  color: Theme.of(context).primaryColor),
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey[200],
                            ),
                            child: TextResponsive(type.toString(),
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.black,
                                ))),
                      ),

                      SizedBoxResponsive(
                        height: 20,
                      ),

                      ContainerResponsive(
                        margin: EdgeInsetsResponsive.only(left: 35, right: 35),
                        child: TextResponsive(
                          'storeName'.tr(),
                          style:
                              TextStyle(color: Color(0xff111111), fontSize: 26),
                        ),
                      ),
                      SizedBoxResponsive(
                        height: 10,
                      ),
                      Center(
                        child: ContainerResponsive(
                          heightResponsive: true,
                          widthResponsive: true,
                          margin: EdgeInsetsResponsive.only(
                              left: 30, right: 30, top: 10),
                          height: 75,
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xffF1F1F1)),
                            borderRadius: BorderRadius.circular(5),
                            color: Color(0xffF1F1F1),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: TextField(
                              controller: name,
                              enabled: true,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  prefixIcon: Icon(
                                    Icons.edit,
                                    color: Color(0xffFBB746),
                                    size: 15,
                                  ),
                                  labelStyle: TextStyle(
                                      fontSize:
                                          ScreenUtil().setSp(25).toDouble(),
                                      color: Colors.grey[800])),
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                  color: Color(0xff111111),
                                  fontSize: ScreenUtil().setSp(30).toDouble()),
                            ),
                          ),
                        ),
                      ),
                      SizedBoxResponsive(height: 20),
                      ContainerResponsive(
                        margin: EdgeInsetsResponsive.only(left: 35, right: 35),
                        child: TextResponsive(
                          'storeNameAr'.tr(),
                          style:
                              TextStyle(color: Color(0xff111111), fontSize: 26),
                        ),
                      ),
                      SizedBoxResponsive(
                        height: 10,
                      ),
                      Center(
                        child: ContainerResponsive(
                          heightResponsive: true,
                          widthResponsive: true,
                          margin: EdgeInsetsResponsive.only(
                              left: 30, right: 30, top: 10),
                          height: 75,
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xffF1F1F1)),
                            borderRadius: BorderRadius.circular(5),
                            color: Color(0xffF1F1F1),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: TextField(
                              controller: nameAr,
                              enabled: true,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  prefixIcon: Icon(
                                    Icons.edit,
                                    color: Color(0xffFBB746),
                                    size: 15,
                                  ),
                                  labelStyle: TextStyle(
                                      fontSize:
                                          ScreenUtil().setSp(25).toDouble(),
                                      color: Colors.grey[800])),
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                  color: Color(0xff111111),
                                  fontSize: ScreenUtil().setSp(30).toDouble()),
                            ),
                          ),
                        ),
                      ),

                      SizedBoxResponsive(
                        height: 20,
                      ),

                      ContainerResponsive(
                        margin: EdgeInsetsResponsive.only(left: 35, right: 35),
                        child: TextResponsive(
                          'phoneNumber'.tr(),
                          style:
                              TextStyle(color: Color(0xff111111), fontSize: 26),
                        ),
                      ),
                      SizedBoxResponsive(
                        height: 10,
                      ),
                      Center(
                        child: ContainerResponsive(
                          heightResponsive: true,
                          widthResponsive: true,
                          margin: EdgeInsetsResponsive.only(
                              left: 30, right: 30, top: 10),
                          height: 75,
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xffF1F1F1)),
                            borderRadius: BorderRadius.circular(5),
                            color: Color(0xffF1F1F1),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: TextField(
                              controller: phone,
                              enabled: false,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  prefixIcon: Icon(
                                    Icons.phone,
                                    color: Color(0xffFBB746),
                                    size: 15,
                                  ),
                                  labelStyle: TextStyle(
                                      fontSize:
                                          ScreenUtil().setSp(25).toDouble(),
                                      color: Colors.grey[800])),
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                  color: Color(0xff111111),
                                  fontSize: ScreenUtil().setSp(30).toDouble()),
                            ),
                          ),
                        ),
                      ),

                      SizedBoxResponsive(
                        height: 20,
                      ),

                      ContainerResponsive(
                        margin: EdgeInsetsResponsive.only(left: 35, right: 35),
                        child: TextResponsive(
                          'storeSerial'.tr(),
                          style:
                              TextStyle(color: Color(0xff111111), fontSize: 26),
                        ),
                      ),
                      SizedBoxResponsive(
                        height: 10,
                      ),
                      Center(
                        child: ContainerResponsive(
                          heightResponsive: true,
                          widthResponsive: true,
                          margin: EdgeInsetsResponsive.only(
                              left: 30, right: 30, top: 10),
                          height: 75,
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xffF1F1F1)),
                            borderRadius: BorderRadius.circular(5),
                            color: Color(0xffF1F1F1),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: TextField(
                              controller: shopSerialNumber,
                              enabled: true,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  prefixIcon: Icon(
                                    Icons.web,
                                    color: Color(0xffFBB746),
                                    size: 15,
                                  ),
                                  labelStyle: TextStyle(
                                      fontSize:
                                          ScreenUtil().setSp(25).toDouble(),
                                      color: Colors.grey[800])),
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                  color: Color(0xff111111),
                                  fontSize: ScreenUtil().setSp(30).toDouble()),
                            ),
                          ),
                        ),
                      ),

                      SizedBoxResponsive(
                        height: 20,
                      ),

                      ContainerResponsive(
                        margin: EdgeInsetsResponsive.only(left: 35, right: 35),
                        child: TextResponsive(
                          'email'.tr(),
                          style:
                              TextStyle(color: Color(0xff111111), fontSize: 26),
                        ),
                      ),
                      SizedBoxResponsive(
                        height: 10,
                      ),
                      Center(
                        child: ContainerResponsive(
                          heightResponsive: true,
                          widthResponsive: true,
                          margin: EdgeInsetsResponsive.only(
                              left: 30, right: 30, top: 10),
                          height: 75,
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xffF1F1F1)),
                            borderRadius: BorderRadius.circular(5),
                            color: Color(0xffF1F1F1),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: TextField(
                              controller: email,
                              enabled: true,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: Color(0xffFBB746),
                                    size: 15,
                                  ),
                                  labelStyle: TextStyle(
                                      fontSize:
                                          ScreenUtil().setSp(25).toDouble(),
                                      color: Colors.grey[800])),
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                  color: Color(0xff111111),
                                  fontSize: ScreenUtil().setSp(30).toDouble()),
                            ),
                          ),
                        ),
                      ),

                      SizedBoxResponsive(
                        height: 20,
                      ),

                      ContainerResponsive(
                        margin: EdgeInsetsResponsive.only(left: 35, right: 35),
                        child: TextResponsive(
                          'storeAddress'.tr(),
                          style:
                              TextStyle(color: Color(0xff111111), fontSize: 26),
                        ),
                      ),
                      SizedBoxResponsive(
                        height: 10,
                      ),
                      Center(
                        child: ContainerResponsive(
                          heightResponsive: true,
                          widthResponsive: true,
                          margin: EdgeInsetsResponsive.only(
                              left: 30, right: 30, top: 10),
                          height: 75,
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xffF1F1F1)),
                            borderRadius: BorderRadius.circular(5),
                            color: Color(0xffF1F1F1),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: TextField(
                              controller: address,
                              enabled: true,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  prefixIcon: Icon(
                                    Icons.location_city,
                                    color: Color(0xffFBB746),
                                    size: 15,
                                  ),
                                  labelStyle: TextStyle(
                                      fontSize:
                                          ScreenUtil().setSp(25).toDouble(),
                                      color: Colors.grey[800])),
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                  color: Color(0xff111111),
                                  fontSize: ScreenUtil().setSp(30).toDouble()),
                            ),
                          ),
                        ),
                      ),

                      SizedBoxResponsive(
                        height: 20,
                      ),

                      ContainerResponsive(
                        margin: EdgeInsetsResponsive.only(left: 35, right: 35),
                        child: TextResponsive(
                          'city'.tr(),
                          style:
                              TextStyle(color: Color(0xff111111), fontSize: 26),
                        ),
                      ),
                      SizedBoxResponsive(
                        height: 10,
                      ),
                      Center(
                        child: ContainerResponsive(
                          heightResponsive: true,
                          widthResponsive: true,
                          margin: EdgeInsetsResponsive.only(
                              left: 30, right: 30, top: 10),
                          height: 75,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xffF8F8F8),
                          ),
                          child: ContainerResponsive(
                            heightResponsive: true,
                            widthResponsive: true,
                            height: 70,
                            width: 660,
                            margin:
                                EdgeInsetsResponsive.only(left: 20, right: 20),
                            child: DropdownButton<String>(
                              hint: TextResponsive(
                                'chooseCity'.tr(),
                              ),
                              style: TextStyle(
                                  fontSize: 13, color: Colors.grey[500]),
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
                      ),

                      SizedBoxResponsive(
                        height: 20,
                      ),

                      ContainerResponsive(
                        margin: EdgeInsetsResponsive.only(left: 35, right: 35),
                        child: TextResponsive(
                          'storeAddress'.tr(),
                          style:
                              TextStyle(color: Color(0xff111111), fontSize: 26),
                        ),
                      ),
                      SizedBoxResponsive(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () async {
                          locationSelected = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProductLocation(
                                        latLng: LatLng(lat * 1.0, lang * 1.0),
                                      )));
                          setState(() {
                            if (lat != null && lang != null) {
                              locationSelected = true;
                            } else {
                              locationSelected = false;
                            }
                          });
                        },
                        child: Center(
                          child: ContainerResponsive(
                              heightResponsive: true,
                              widthResponsive: true,
                              margin: EdgeInsetsResponsive.only(
                                  left: 30, right: 30, top: 10),
                              height: 75,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color(0xffF8F8F8),
                              ),
                              child: ContainerResponsive(
                                heightResponsive: true,
                                widthResponsive: true,
                                margin: EdgeInsetsResponsive.only(
                                    left: 20, right: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                    TextResponsive(
                                        locationSelected
                                            ? 'locationSelected'.tr()
                                            : "locationMap".tr(),
                                        style: TextStyle(fontSize: 21)),
                                  ],
                                ),
                              )),
                        ),
                      ),
                      SizedBoxResponsive(
                        height: 20,
                      ),
                      ContainerResponsive(
                        margin: EdgeInsetsResponsive.only(left: 35, right: 35),
                        child: TextResponsive(
                          'storeLicenseDate'.tr(),
                          style:
                              TextStyle(color: Color(0xff111111), fontSize: 26),
                        ),
                      ),
                      SizedBoxResponsive(
                        height: 10,
                      ),
                      Center(
                        child: ContainerResponsive(
                            heightResponsive: true,
                            widthResponsive: true,
                            margin: EdgeInsetsResponsive.only(
                                left: 30, right: 30, top: 10),
                            height: 75,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xffF8F8F8),
                            ),
                            child: GestureDetector(
                              // color: Colors.white,
                              onTap: () {
                                selectDate(context);
                              },
                              child: ContainerResponsive(
                                heightResponsive: true,
                                widthResponsive: true,
                                margin: EdgeInsetsResponsive.only(
                                    left: 20, right: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    selectedDate == null
                                        ? shop.licenseEndDate != null
                                            ? TextResponsive(
                                                shop.licenseEndDate.toString(),
                                                style: TextStyle(fontSize: 25))
                                            : dobDropDown()
                                        : dobDropDown()
                                  ],
                                ),
                              ),
                            )),
                      ),
                      SizedBoxResponsive(
                        height: 20,
                      ),
                      ContainerResponsive(
                        margin: EdgeInsetsResponsive.only(left: 35, right: 35),
                        child: TextResponsive(
                          "storeLicense".tr(),
                          style:
                              TextStyle(color: Color(0xff111111), fontSize: 26),
                        ),
                      ),
                      SizedBoxResponsive(
                        height: 10,
                      ),
                      Stack(
                        children: <Widget>[
                          Align(
                              alignment: Alignment.center,
                              child: ContainerResponsive(
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey, width: 3),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20.0),
                                    ),
                                    child: ContainerResponsive(
                                      width: 550,
                                      height: 200,
                                      padding: EdgeInsets.all(0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: _licenseImage == null
                                          ? CachedNetworkImage(
                                              imageUrl:
                                                  shop.licenseImage != null
                                                      ? baseImageURL +
                                                          shop.licenseImage
                                                      : '',
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                                  Center(
                                                      child: ImageLoad(150.0)),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Image.asset(
                                                'images/image404.png',
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : Image.file(_licenseImage,
                                              fit: BoxFit.cover),
                                    )),
                              )),
                          Positioned(
                            left: 10,
                            bottom: 0,
                            child: GestureDetector(
                              onTap: () async {
                                var pickedFile = await showDialog(
                                    context: context,
                                    builder: (context) => MediaPickDialog());
                                if (pickedFile != null)
                                  setState(() {
                                    _licenseImage = pickedFile;
                                  });
                                getImgUrl(_licenseImage, _licenseImageName);
                              },
                              child: Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 5, color: Colors.white),
                                    color: Colors.green,
                                    shape: BoxShape.circle),
                                child: Center(
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),

                      SizedBoxResponsive(
                        height: 20,
                      ),

                      ContainerResponsive(
                        margin: EdgeInsetsResponsive.only(left: 35, right: 35),
                        child: TextResponsive(
                          'storeDescription'.tr(),
                          style:
                              TextStyle(color: Color(0xff111111), fontSize: 26),
                        ),
                      ),
                      SizedBoxResponsive(
                        height: 10,
                      ),
                      ContainerResponsive(
                        heightResponsive: true,
                        widthResponsive: true,
                        margin: EdgeInsetsResponsive.only(
                            left: 30, right: 30, top: 10),
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xffF1F1F1)),
                          borderRadius: BorderRadius.circular(5),
                          color: Color(0xffF1F1F1),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: TextField(
                            controller: description,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                labelStyle: TextStyle(
                                    fontSize: 15, color: Colors.grey[800])),
                            enabled: true,
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                              color: Color(0xff111111),
                            ),
                          ),
                        ),
                      ),

                      //===========data===================

                      SizedBoxResponsive(
                        height: 20,
                      ),

                      ContainerResponsive(
                        margin: EdgeInsetsResponsive.only(left: 35, right: 35),
                        child: TextResponsive(
                          'storeDetails'.tr(),
                          style:
                              TextStyle(color: Color(0xff111111), fontSize: 26),
                        ),
                      ),

                      SizedBoxResponsive(
                        height: 20,
                      ),

                      Row(
                        children: <Widget>[
                          Padding(
                            padding:
                                EdgeInsetsResponsive.only(right: 16, left: 16),
                            child: TextResponsive("productsNumber".tr(),
                                style: TextStyle(fontSize: 23)),
                          ),
                          Expanded(
                            child: ContainerResponsive(
                                heightResponsive: true,
                                widthResponsive: true,
                                margin: EdgeInsetsResponsive.only(
                                    left: 30, right: 30, top: 10),
                                width: 500,
                                height: 75,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xffF1F1F1)),
                                  borderRadius: BorderRadius.circular(5),
                                  color: Color(0xffF1F1F1),
                                ),
                                child: Padding(
                                  padding: EdgeInsetsResponsive.only(left: 8.0),
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: TextResponsive(
                                          shop.ProductCount.toString(),
                                          style: TextStyle(fontSize: 21))),
                                )),
                          ),
                          SizedBoxResponsive(
                            width: 70,
                          ),
                        ],
                      ),

                      SizedBoxResponsive(
                        height: 20,
                      ),

                      Row(
                        children: <Widget>[
                          Padding(
                            padding:
                                EdgeInsetsResponsive.only(right: 16, left: 16),
                            child: TextResponsive("ordersNumber".tr(),
                                style: TextStyle(fontSize: 23)),
                          ),
                          Expanded(
                            child: ContainerResponsive(
                                heightResponsive: true,
                                widthResponsive: true,
                                margin: EdgeInsetsResponsive.only(
                                    left: 30, right: 30, top: 10),
                                width: 500,
                                height: 75,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xffF1F1F1)),
                                  borderRadius: BorderRadius.circular(5),
                                  color: Color(0xffF1F1F1),
                                ),
                                child: Padding(
                                  padding: EdgeInsetsResponsive.only(left: 8.0),
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: TextResponsive(
                                          shop.orderCount.toString(),
                                          style: TextStyle(fontSize: 21))),
                                )),
                          ),
                          SizedBoxResponsive(
                            width: 70,
                          ),
                        ],
                      ),

                      SizedBoxResponsive(
                        height: 20,
                      ),

                      Row(
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsetsResponsive.only(
                                  right: 16, left: 16),
                              child: TextResponsive("salesValue".tr(),
                                  style: TextStyle(fontSize: 23))),
                          Expanded(
                            child: ContainerResponsive(
                                heightResponsive: true,
                                widthResponsive: true,
                                margin: EdgeInsetsResponsive.only(
                                    left: 30, right: 30, top: 10),
                                width: 500,
                                height: 75,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xffF1F1F1)),
                                  borderRadius: BorderRadius.circular(5),
                                  color: Color(0xffF1F1F1),
                                ),
                                child: Padding(
                                  padding: EdgeInsetsResponsive.only(left: 8.0),
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: TextResponsive(
                                          shop.sold_count.toString(),
                                          style: TextStyle(fontSize: 21))),
                                )),
                          ),
                          SizedBoxResponsive(
                            width: 70,
                          ),
                        ],
                      ),

                      SizedBoxResponsive(
                        height: 20,
                      ),

                      Row(
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsetsResponsive.only(
                                  right: 16, left: 16),
                              child: TextResponsive("storeCredit".tr(),
                                  style: TextStyle(fontSize: 23))),
                          Expanded(
                            child: ContainerResponsive(
                                heightResponsive: true,
                                widthResponsive: true,
                                margin: EdgeInsetsResponsive.only(
                                    left: 30, right: 30, top: 10),
                                width: 500,
                                height: 75,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xffF1F1F1)),
                                  borderRadius: BorderRadius.circular(5),
                                  color: Color(0xffF1F1F1),
                                ),
                                child: Padding(
                                  padding: EdgeInsetsResponsive.only(left: 8.0),
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: TextResponsive(
                                          shop.credit.toString(),
                                          style: TextStyle(fontSize: 21))),
                                )),
                          ),
                          SizedBoxResponsive(
                            width: 70,
                          ),
                        ],
                      ),

                      //===================================

                      SizedBox(
                        height: 0,
                      ),

                      SizedBoxResponsive(
                        height: 180,
                        child: Stack(
                          children: <Widget>[
                            Positioned(
                              top: 30,
                              child: GestureDetector(
                                onTap: () {
                                  if (name.text.length < 3) {
                                    Fluttertoast.showToast(
                                        msg:
                                            "الاسم يجب ان يك،ن على الاقل 6 خانات",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        backgroundColor: Colors.redAccent,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                    return;
                                  } else if (nameAr.text.length < 3) {
                                    Fluttertoast.showToast(
                                        msg:
                                            "الاسم يجب ان يك،ن على الاقل 6 خانات",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        backgroundColor: Colors.redAccent,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                    return;
                                  } else if (shopSerialNumber.text.length ==
                                      0) {
                                    Fluttertoast.showToast(
                                        msg:
                                            "قم بكتابة الرقم التسلسلي للمتجر اولا",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        backgroundColor: Colors.redAccent,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                    return;
                                  } else if (description.text.length == 0) {
                                    Fluttertoast.showToast(
                                        msg: "قم بكتابة تفاصيل المتجر اولا",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        backgroundColor: Colors.redAccent,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                    return;
                                  } else if (selectedCountry == null) {
                                    Fluttertoast.showToast(
                                        msg: "قم بكتابة مدينة المتجر اولا",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        backgroundColor: Colors.redAccent,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                    return;
                                  } else if (address.text.length == 0) {
                                    Fluttertoast.showToast(
                                        msg: "قم بكتابة عنوان المتجر اولا",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        backgroundColor: Colors.redAccent,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                    return;
                                  } else if (!email.text.contains("@")) {
                                    Fluttertoast.showToast(
                                        msg: "قم بكتابة البريد الالكتروني اولا",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        backgroundColor: Colors.redAccent,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                    return;
                                  } else if (locationSelected == null) {
                                    Fluttertoast.showToast(
                                        msg:
                                            "قم بتحديد موقع المتجر علي الخريطه اولا",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        backgroundColor: Colors.redAccent,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                    return;
                                  }

                                  _pr.show();

                                  if (_profileImage != null) {
                                    editImg();
                                  } else {
                                    updateShop();
                                  }
                                },
                                child: ContainerResponsive(
                                    heightResponsive: true,
                                    widthResponsive: true,
                                    margin: EdgeInsetsResponsive.only(
                                        left: 30, right: 30, top: 10),
                                    width: 660,
                                    height: 75,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    child: Center(
                                      child: TextResponsive(
                                        'saveChanges'.tr(),
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 27),
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
          )),
    );
  }
}
