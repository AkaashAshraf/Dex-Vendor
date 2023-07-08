import 'dart:math';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mplus_provider/ui/widgets/loading.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mplus_provider/models/user.dart';
import 'package:responsive_widgets/responsive_widgets.dart';

import '../globals.dart';
import '../main.dart';

class CodeValidation extends StatefulWidget {
  final String phoneNumber;

  const CodeValidation({Key key, this.phoneNumber}) : super(key: key);
  @override
  _CodeValidationState createState() => _CodeValidationState();
}

class _CodeValidationState extends State<CodeValidation> {
  var _pin;
  var _isLoading;
  var prefs;

  Future resendCode(String number) async {
    try {
      setState(() {
        _isLoading = true;
      });
      var _phoneNumber = number;
      print(_phoneNumber);
      var response = await dioClient
          .get(baseURL + 'sendVerificationCode/login&$_phoneNumber');
      print('RESPONSE IS $response');
      if (response.data != null) {
        await Fluttertoast.showToast(
            msg: "done".tr(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        setState(() {
          _isLoading = false;
        });
      }
    } on DioError catch (error) {
      setState(() {
        _isLoading = false;
      });
      await Fluttertoast.showToast(
          msg: "tryAgain".tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      switch (error.type) {
        case DioErrorType.connectTimeout:
        case DioErrorType.sendTimeout:
        case DioErrorType.cancel:
          rethrow;
          break;
        default:
          rethrow;
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      await Fluttertoast.showToast(
          msg: "tryAgain".tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      rethrow;
    }
  }

  Future _verifyUser(String smsCode) async {
    try {
      prefs = await SharedPreferences.getInstance();
      setState(() {
        _isLoading = true;
      });
      var response = await dioClient.post(baseURL + "verfiyCode",
          data: FormData.fromMap(
              {"login_phone": widget.phoneNumber, "smsCode": _pin}));
      if (response.data.toString() != null) {
        if (response.data['State'] == 1) {
          var isVerified = response.data['Data']['isVerified'];
          if (isVerified == 1) {
            prefs.setString('user_phone', user.loginPhone.toString());
            prefs.setString('user_image', user.image.toString());
            prefs.setString('user_id', user.id.toString());
            prefs.setString('user_name', user.firstName.toString());
            prefs.setString('user_email', user.email.toString());
            prefs.setString('password', user.password.toString());
            prefs.setString('IS_LOGIN', 'true');
            await _getUserData(widget.phoneNumber);

            Navigator.pushReplacementNamed(context, 'home');
          } else {
            Fluttertoast.showToast(
                msg: "tryAgain".tr(),
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.white,
                textColor: Color(0xff34C961),
                fontSize: 15.0);
          }
        } else {
          Fluttertoast.showToast(
              msg: "errorRetry".tr(),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.white,
              textColor: Color(0xff34C961),
              fontSize: 15.0);
        }
      } else {}
      setState(() {
        _isLoading = false;
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

  Future _getUserData(String phoneNumber) async {
    try {
      var response = await dioClient.get(baseURL + 'getUserinfo/$phoneNumber');

      var data = response.data;

      prefs.setString('userId', '${data['id']}');
      prefs.setString('userImage', '${data['image']}');
      prefs.setString('userName', '${data['first_name']}');

      sendToken('${data['id']}');
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

  Future sendToken(var usrId) async {
    try {
      var token = await FirebaseMessaging.instance.getToken();
      var userId = prefs.getString('userId');
      print('TOKEN $token');

      var response = await dioClient
          .get(baseURL + 'sendToken/Userid=$usrId&token=$token&appId=3');

      print('TOKEN RESPONSE $response');

      Fluttertoast.showToast(
          msg: "loggedin".tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.white,
          textColor: Color(0xff34C961),
          fontSize: 15.0);
    } on DioError catch (error) {
      switch (error.type) {
        case DioErrorType.cancel:
        case DioErrorType.sendTimeout:
        case DioErrorType.connectTimeout:
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
    Size size = MediaQuery.of(context).size;

    return ResponsiveWidgets.builder(
      height: 1560,
      width: 720,
      allowFontScaling: true,
      child: Scaffold(
          backgroundColor: Color(0xffFFFFFF),
          body: Container(
            // decoration: BoxDecoration(
            //   image: DecorationImage(
            //     image: AssetImage('images/background.png'),
            //     fit: BoxFit.cover,
            //   ),
            // ),
            child: Column(children: [
              Expanded(
                child: ListView(
                  children: <Widget>[
                    SizedBoxResponsive(height: 300),
                    Center(
                      child: ContainerResponsive(
                          width: 200,
                          height: 200,
                          margin: EdgeInsetsResponsive.fromLTRB(0, 0, 0, 5),
                          child: Image.asset(
                            'images/logo.png',
                            fit: BoxFit.fill,
                          )),
                    ),
                    SizedBoxResponsive(height: 15),
                    ContainerResponsive(
                        heightResponsive: true,
                        widthResponsive: true,
                        child: Center(
                          child: TextResponsive(
                            'activateAccount'.tr(),
                            style: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontSize: 45),
                          ),
                        )),
                    SizedBoxResponsive(height: 40),
                    // ContainerResponsive(
                    //   heightResponsive: true,
                    //   widthResponsive: true,
                    //   margin: EdgeInsetsResponsive.only(left: 65, right: 65),
                    //   child: TextResponsive(
                    //     'إذا كنت تحتاج إلى عدد أكبر من الفقرات يتيح لك مولد النص العربى زيادة عدد الفقرات كما تريد، النص لن  يبدو مقسما ولا يحوي أخطاء لغوية،',
                    //     style: TextStyle(color: Color(0xff8D8D8D), fontSize: 25),
                    //     textAlign: TextAlign.center,
                    //   ),
                    // // ),
                    // SizedBoxResponsive(
                    //   height: 20,
                    // ),
                    ContainerResponsive(
                      margin: EdgeInsetsResponsive.only(right: 35, top: 5),
                      child: TextResponsive(
                        'code'.tr(),
                        style:
                            TextStyle(color: Color(0xff111111), fontSize: 28),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    _isLoading == true
                        ? Center(
                            child: ContainerResponsive(
                              heightResponsive: true,
                              widthResponsive: true,
                              height: 100,
                              child: Center(
                                child: ImageLoad(100.0),
                              ),
                            ),
                          )
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Center(
                                  child: ContainerResponsive(
                                    heightResponsive: true,
                                    widthResponsive: true,
                                    margin: EdgeInsetsResponsive.symmetric(
                                        horizontal: 20, vertical: 30),
                                    width: 420,
                                    height: 90,
                                    child: Center(
                                        child: PinInputTextField(
                                      pinLength: 4,
                                      keyboardType: TextInputType.phone,
                                      decoration: BoxLooseDecoration(
                                          strokeColorBuilder:
                                              PinListenColorBuilder(
                                                  Theme.of(context)
                                                      .primaryColor,
                                                  Theme.of(context)
                                                      .accentColor),
                                          textStyle: TextStyle(
                                            fontSize: ScreenUtil()
                                                .setSp(40)
                                                .toDouble(),
                                            color: Colors.black,
                                          )),
                                      onChanged: (pin) {
                                        setState(() {
                                          _pin = pin;
                                        });
                                      },
                                      onSubmit: (pin) {
                                        setState(() {
                                          _pin = pin;
                                        });
                                      },
                                    )),
                                  ),
                                ),
                                SizedBoxResponsive(
                                  height: 20,
                                ),
                                Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      resendCode(widget.phoneNumber);
                                    },
                                    child: ContainerResponsive(
                                      margin: EdgeInsetsResponsive.only(
                                          right: 20, top: 10),
                                      child: TextResponsive(
                                        'resendCode'.tr(),
                                        style: TextStyle(
                                            color: Color(0xff111111),
                                            fontSize: 26),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBoxResponsive(
                                  height: 20,
                                ),
                                Center(
                                  child: GestureDetector(
                                    onTap: () => _verifyUser(_pin),
                                    child: ContainerResponsive(
                                      heightResponsive: true,
                                      widthResponsive: true,
                                      margin: EdgeInsetsResponsive.only(
                                          left: 30,
                                          right: 30,
                                          top: 10,
                                          bottom: 10),
                                      height: 75,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      child: Center(
                                        child: TextResponsive(
                                          'verify'.tr(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 26),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ],
                ),
              ),
              // Image.asset(
              //   'images/bottom_town.png',
              //   height: 150,
              //   fit: BoxFit.fitWidth,
              // )
            ]),
          )),
    );
  }
}
