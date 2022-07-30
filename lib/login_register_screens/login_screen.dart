import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mplus_provider/login_register_screens/CodeValidation.dart';
import 'package:mplus_provider/login_register_screens/register_screen.dart';
import 'package:mplus_provider/models/shops.dart';
import 'package:mplus_provider/models/user.dart';
import 'package:mplus_provider/password_reset_screens/request_reset.dart';
import 'package:mplus_provider/ui/widgets/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import '../globals.dart';

/*
import 'package:kdar_app/home.dart';
import 'package:kdar_app/login_register_screens/register_screen.dart';
import 'package:kdar_app/models/user.dart';
import 'package:kdar_app/password_reset_screens/request_reset.dart';
import 'package:shared_preferences/shared_preferences.dart';
*/

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var name = TextEditingController();
  var phone = TextEditingController();
  var email = TextEditingController();
  var password = TextEditingController();
  var prefs;

  var hidePass = true;
  var acceptRules = false;

  var loading = false;

  var phoneIsoCode;

  var _name, _password, _email, _phone;

  Future getUserData(var phone) async {
    try {
      prefs = await SharedPreferences.getInstance();

      var response = await dioClient.get(baseURL + 'getUserinfo/$phone');
      var data = response.data;
      print('RESPONSE $data');
      user = User.fromJson(response.data);
      // prefs.setString('user_phone', '${response.data['login_phone']}');
      // prefs.setString('user_id', '${response.data['id']}');
      // prefs.setString('user_name', response.data['first_name']);
      // prefs.setString('user_email', response.data['email']);
      // prefs.setString('password', response.data['password']);
      // prefs.setBool('IS_LOGIN', true);

      getShopData('${response.data['id']}');

      print('BEFOR');

      print("AFTER");

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

  Future getShopData(var id) async {
    try {
//${prefs.getString('user_id')}
      var response =
          await dioClient.get(baseURL + 'getMyShops/OrderBy&iddealerId&$id');
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
            msg: "loggedin".tr(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.white,
            textColor: Color(0xff34C961),
            fontSize: 15.0);
        print("BEFORE");
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => CodeValidation(
                      phoneNumber: _phone,
                    )));
      } else {
        setState(() {
          loading = false;
        });

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => CodeValidation(
                      phoneNumber: _phone,
                      // customerId: id,
                    )));

        // Fluttertoast.showToast(
        //     msg: "قم إنشاء المتجر اولا",
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.BOTTOM,
        //     timeInSecForIos: 1,
        //     backgroundColor: Colors.redAccent,
        //     textColor: Colors.white,
        //     fontSize: 16.0);
      }
      print("AFTER");
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

//   login(String password, String phone) async {
//     try {
//       setState(() {
//         loading = true;
//       });
//       FormData data = new FormData.fromMap({
//         'login_phone': '$_phone',
//         'password': '$password',
//       });
// print('RESPONSE123 ${data.fields}');
//       var response = await Dio().post(baseURL + 'login', data: data);
//       print('RESPONSE123 ${response.statusCode}');

//       if (response.data['Data'] == "true") {
//         getUserData(phone);
//       } else {
//         Fluttertoast.showToast(
//             msg: response.data['Data'],
//             toastLength: Toast.LENGTH_SHORT,
//             gravity: ToastGravity.BOTTOM,
//             backgroundColor: Colors.red,
//             textColor: Colors.white,
//             fontSize: 16.0);
//       }

//       setState(() {
//         loading = false;
//       });
//     } on DioError catch (error) {
//       setState(() {
//         loading = false;
//       });
//       print(error);
//       switch (error.type) {
//         case DioErrorType.connectTimeout:
//         case DioErrorType.sendTimeout:
//         case DioErrorType.cancel:
//           throw error;
//           break;
//         default:
//           print('RESPONSE123 ${error.response.data}');
//           throw error;
//       }
//     } catch (error) {
//       print('RESPONSE123 ${error.toString()}');
//       throw error;
//     }
//   }

login(String password, String phone) async {
    try {
      setState(() {
        loading = true;
      });
      FormData data = new FormData.fromMap({
        'login_phone': '$_phone',
        'password': '$password',
      });
// print('RESPONSE123 ${data.fields}');
      var response = await Dio().post(baseURL + 'login', data: data);
      // print('RESPONSE123 ${response.statusCode}');

      if (response.data['Data'] == "true") {
        getUserData(phone);
      } else {
        Fluttertoast.showToast(
            msg: response.data['Data'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }

      setState(() {
        loading = false;
      });
    } on DioError catch (error) {
      setState(() {
        loading = false;
      });
      print(error);
      switch (error.type) {
        case DioErrorType.connectTimeout:
        case DioErrorType.sendTimeout:
        case DioErrorType.cancel:
          throw error;
          break;
        default:
          print('RESPONSE123 ${error.response.data}');
          throw error;
      }
    } catch (error) {
      print('RESPONSE123 ${error.toString()}');
      throw error;
    }
  }

  var iosSubscription;
  FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    // Firebase.initializeApp();
    phoneIsoCode = '+968';
    if (Platform.isIOS) {
      _fcm.requestPermission();
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("onMessage: $message");
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: ListTile(
            title: Text(message.notification.title),
            subtitle: Text(message.notification.body),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveWidgets.init(
      context,
      height: 1560,
      width: 720,
      allowFontScaling: true,
    );
    Size size = MediaQuery.of(context).size;
    print(size);
    return ResponsiveWidgets.builder(
      height: 1560,
      width: 720,
      allowFontScaling: true,
      child: Scaffold(
        body: SingleChildScrollView(
          child: ContainerResponsive(
            heightResponsive: true,
            widthResponsive: true,
            height: 1560,
            width: 720,
            // decoration: BoxDecoration(
            //     image: DecorationImage(
            //         image: AssetImage(
            //           "images/background.png",
            //         ),
            //         fit: BoxFit.fill)),
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
                    margin: EdgeInsetsResponsive.only(top: 0, left: 0),
                    child: TextResponsive(
                      'login'.tr(),
                      style: TextStyle(
                          color: Theme.of(context).accentColor, fontSize: 47),
                    ),
                  ),
                ),
                SizedBoxResponsive(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    ContainerResponsive(
                      heightResponsive: true,
                      widthResponsive: true,
                      margin: EdgeInsetsResponsive.fromLTRB(35, 0, 35, 0),
                      child: TextResponsive(
                        'phoneNumber'.tr(),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Theme.of(context).accentColor, fontSize: 28),
                      ),
                    ),
                  ],
                ),
                Center(
                  child: ContainerResponsive(
                    heightResponsive: true,
                    widthResponsive: true,
                    margin: EdgeInsetsResponsive.fromLTRB(30, 5, 30, 0),
                    height: 75,
                    width: 660,
                    decoration: BoxDecoration(
                        color: Color(0xffF8F8F8),
                        borderRadius: BorderRadius.circular(10)),
                    child: ContainerResponsive(
                      heightResponsive: true,
                      widthResponsive: true,
                      margin: EdgeInsetsResponsive.fromLTRB(0, 0, 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Icon(
                            Icons.edit,
                            color: Theme.of(context).primaryColor,
                            size: 15,
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
                                phoneIsoCode = v;
                                setState(() {});
                              },
                            ),
                          ),
                          ContainerResponsive(
                            padding: EdgeInsetsResponsive.symmetric(
                                horizontal: 0, vertical: 10),
                            width: 370,
                            child: TextField(
                              maxLength: phoneIsoCode == '+968' ? 8 : 9,
                              controller: phone,
                              enabled: true,
                              decoration: InputDecoration(
                                  counterText: '',
                                  border: InputBorder.none,
                                  labelStyle: TextStyle(
                                      fontSize:
                                          ScreenUtil().setSp(22).toDouble()),
                                  alignLabelWithHint: true),
                              keyboardType: TextInputType.phone,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBoxResponsive(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    ContainerResponsive(
                        heightResponsive: true,
                        widthResponsive: true,
                        margin: EdgeInsetsResponsive.fromLTRB(35, 0, 35, 0),
                        child: TextResponsive(
                          'password'.tr(),
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 28),
                        )),
                  ],
                ),
                Center(
                  child: ContainerResponsive(
                      heightResponsive: true,
                      widthResponsive: true,
                      margin: EdgeInsetsResponsive.only(
                          left: 30, top: 5, right: 30),
                      height: 75,
                      width: 660,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xffF8F8F8),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                            padding: EdgeInsetsResponsive.symmetric(
                                horizontal: 15, vertical: 10),
                            width: 550,
                            child: TextField(
                              textAlignVertical: TextAlignVertical.center,
                              controller: password,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'enterPassword'.tr(),
                                hintStyle: TextStyle(
                                    fontSize:
                                        ScreenUtil().setSp(25).toDouble()),
                              ),
                              obscureText: hidePass ? true : false,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: ScreenUtil().setSp(30).toDouble()),
                            ),
                          ),
                        ],
                      )),
                ),
                Visibility(
                  visible: loading ? true : false,
                  child: ContainerResponsive(
                    heightResponsive: true,
                    widthResponsive: true,
                    margin: EdgeInsetsResponsive.fromLTRB(0, 20, 0, 0),
                    height: 100,
                    child: ImageLoad(50.0),
                  ),
                ),
                Visibility(
                  visible: loading ? true : false,
                  child: ContainerResponsive(
                    margin: EdgeInsetsResponsive.only(top: 5),
                    heightResponsive: true,
                    widthResponsive: true,
                    height: 50,
                    child: Center(
                      child: TextResponsive('loggingIn'.tr(),
                          style: TextStyle(fontSize: 22)),
                    ),
                  ),
                ),
                ContainerResponsive(
                  heightResponsive: true,
                  widthResponsive: true,
                  child: GestureDetector(
                    onTap: () {
                      _phone = phoneIsoCode.toString() + phone.text;
                      _password = password.text;
                      if (phoneIsoCode == '+968' && phone.text.length != 8) {
                        Fluttertoast.showToast(
                            msg: "wrongPhone".tr(),
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.redAccent,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        return;
                      } else if (phoneIsoCode != '+968' &&
                          phone.text.length != 9) {
                        Fluttertoast.showToast(
                            msg: "wrongPhone".tr(),
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.redAccent,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        return;
                      } else if (_password.trim().length == 0) {
                        Fluttertoast.showToast(
                            msg: "writePassword".tr(),
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.redAccent,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        return;
                      }
                      login(
                        _password,
                        _phone,
                      );
                    },
                    child: ContainerResponsive(
                      heightResponsive: true,
                      widthResponsive: true,
                      margin: EdgeInsetsResponsive.fromLTRB(50, 20, 50, 0),
                      width: 620,
                      height: 75,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Center(
                        child: TextResponsive(
                          'login'.tr(),
                          style: TextStyle(color: Colors.white, fontSize: 28),
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: false,
                  child: Positioned(
                    top: loading ? 545 : 454, //545
                    right: 25,
                    left: 25,
                    child: Container(
                      width: 320,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xffF6F6F6),
                      ),
                      child: GestureDetector(
                        onTap: () {
//                          Navigator.push(context,
//                              MaterialPageRoute(builder: (context) => Home()));
                        },
                        child: Center(
                          child: Text(
                            'visitor'.tr(),
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                ContainerResponsive(
                  heightResponsive: true,
                  widthResponsive: true,
                  margin: EdgeInsetsResponsive.only(top: 20),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RequestReset()));
                    },
                    child: ContainerResponsive(
                      heightResponsive: true,
                      widthResponsive: true,
                      child: Center(
                          child: TextResponsive(
                        'forgetPassword'.tr(),
                        style: TextStyle(color: Colors.black, fontSize: 22),
                      )),
                    ),
                  ),
                ),
                Visibility(
                  visible: false,
                  child: Positioned(
                    top: 545,
                    left: 45,
                    right: 10,
                    child: Row(
                      children: <Widget>[
                        Container(
                          height: 1,
                          width: 100,
                          color: Colors.black,
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
                Visibility(
                  visible: false,
                  child: Positioned(
                    top: 565,
                    left: 10,
                    right: 10,
                    child: Container(
                      margin: EdgeInsets.only(left: 60, right: 60, bottom: 5),
                      child: Image.asset(
                        'images/social.PNG',
                        height: 40,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: ContainerResponsive(
                    heightResponsive: true,
                    widthResponsive: true,
                    margin: EdgeInsetsResponsive.only(left: 0, top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextResponsive(
                          'dontHaveAccount'.tr(),
                          style: TextStyle(color: Colors.black, fontSize: 27),
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RegisterScreen()));
                            },
                            child: TextResponsive(
                              'pressHere'.tr(),
                              style: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontSize: 27,
                                decoration: TextDecoration.underline,
                              ),
                              textAlign: TextAlign.center,
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
/*
'images/background.png',
Stack(
                children: <Widget>[
                  Positioned(
                    top: 66,
                    left: 50,
                    right: 50,
                    child: Container(
                        child: Image.asset(
                          'images/logo.png',
                          width: 188,
                          height: 107,
                        )
                    ),
                  ),
                  Positioned(
                    top: 165,
                    left: 50,
                    right: 50,
                    child: Center(child: Text('تسجيل الدخول',style: TextStyle(color: Color(0xff34C961),fontSize: 25),)),
                  ),
                  Positioned(
                    top: 195,
                    left: 5,
                    right: 5,
                    child: Center(child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text('إذا كنت تحتاج إلى عدد أكبر من الفقرات يتيح لك مولد النص العربى زيادة عدد الفقرات كما تريد، النص لن  يبدو مقسما ولا يحوي أخطاء لغوية،',style: TextStyle(color: Color(0xff8D8D8D),fontSize: 15),textAlign: TextAlign.center,),
                    )),

                  )
                ],
              ),

 */
