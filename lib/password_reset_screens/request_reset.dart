import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:mplus_provider/ui/widgets/loading.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:dio/dio.dart';
import '../globals.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mplus_provider/login_register_screens/login_screen.dart';

class RequestReset extends StatefulWidget {
  @override
  _RequestResetState createState() => _RequestResetState();
}

class _RequestResetState extends State<RequestReset> {
  var phoneIsoCode;

  @override
  void initState() {
    phoneIsoCode = '+968';

    super.initState();
  }

  @override
  var loading = false;
  var phone = TextEditingController();

  var _phone;

  requestReset(String phone) async {
    try {
      setState(() {
        loading = true;
      });
      FormData data = new FormData.fromMap({
        'login_phone': phone.toString(),
      });

      var response =
          await dioClient.post(baseURL + 'resetPassword', data: data);
      // print('RESPONSE ${response.data['Data']}');

      setState(() {
        loading = false;
      });
      print(response.data);
      if (response.data != '0') {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
        Fluttertoast.showToast(
            msg: "allDonePleaseEnterNewPassword".tr(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        // getUserData(phone);
      } else {
        Fluttertoast.showToast(
            msg: "noAccountIsRegisteredWithThisNumber".tr(),
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

  Widget build(BuildContext context) {
    ResponsiveWidgets.init(context,
        height: 1560, width: 720, allowFontScaling: true);

    return ResponsiveWidgets.builder(
      height: 1560,
      width: 720,
      allowFontScaling: true,
      child: Scaffold(
          backgroundColor: Color(0xffFFFFFF),
          body: ContainerResponsive(
            child: Column(children: [
              Expanded(
                child: ListView(
                  children: <Widget>[
                    SizedBoxResponsive(
                      height: 60,
                    ),
                    // Image.asset('images/cloud.png',height: 70,width:100,fit: BoxFit.cover,),
                    Center(
                      child: Container(
                          child: Image.asset(
                        'images/logo.png',
                        width: 200,
                        height: 200,
                        fit: BoxFit.fill,
                      )),
                    ),
                    SizedBoxResponsive(
                      height: 30,
                    ),
                    Visibility(
                      visible: loading ? true : false,
                      child: ContainerResponsive(
                        height: 100,
                        child: ImageLoad(100.0),
                      ),
                    ),
                    Visibility(
                      visible: loading ? true : false,
                      child: ContainerResponsive(
                        height: 100,
                        child: Center(
                          child: TextResponsive(
                              'passwordIsBeingResettingPleaseWait'.tr(),
                              style: TextStyle(fontSize: 25)),
                        ),
                      ),
                    ),

                    Center(
                        child: TextResponsive(
                      'forgetPassword'.tr(),
                      style: TextStyle(
                          color: Theme.of(context).accentColor, fontSize: 45),
                    )),
                    SizedBoxResponsive(
                      height: 40,
                    ),
                    ContainerResponsive(
                      margin: EdgeInsetsResponsive.only(left: 40, right: 40),
                      child: TextResponsive(
                        'pleaseEnterYourNumberToReceiveTheNewPassword'.tr(),
                        style:
                            TextStyle(color: Color(0xff8D8D8D), fontSize: 24),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    SizedBoxResponsive(
                      height: 10,
                    ),
                    ContainerResponsive(
                      margin: EdgeInsetsResponsive.only(right: 35, top: 10),
                      child: TextResponsive(
                        'phoneNumber'.tr(),
                        style: TextStyle(
                            color: Theme.of(context).accentColor, fontSize: 27),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    SizedBoxResponsive(
                      height: 5,
                    ),
                    Center(
                      child: ContainerResponsive(
                        margin: EdgeInsetsResponsive.only(right: 30, left: 30),
                        height: 75,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 5,
                                  offset: Offset.fromDirection(1.5, 5),
                                  color: Colors.white54)
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: EdgeInsetsResponsive.only(right: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBoxResponsive(width: 40),
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
                                  phoneIsoCode = v;
                                  // dateTypeBorder = Color(0xffFE9E9E9);
                                  setState(() {});
                                },
                              ),
                              SizedBoxResponsive(width: 20),
                              Expanded(
                                child: ContainerResponsive(
                                  padding: EdgeInsetsResponsive.symmetric(
                                      horizontal: 15, vertical: 10),
                                  child: TextField(
                                    textAlignVertical: TextAlignVertical.center,
                                    maxLength: phoneIsoCode == '+968' ? 8 : 9,
                                    controller: phone,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        counterText: '',
                                        hintText: '',
                                        hintStyle: TextStyle(fontSize: 10)),
                                    textAlign: TextAlign.left,
                                    keyboardType: TextInputType.phone,
                                    style: TextStyle(
                                      color: Color(0xff111111),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBoxResponsive(
                      height: 50,
                    ),

                    GestureDetector(
                      onTap: () {
                        _phone = phoneIsoCode.toString() + phone.text;
                        if (phone.text.length != 9 && phone.text.length != 8) {
                          Fluttertoast.showToast(
                              msg: "phoneNumberIsIncorrect".tr(),
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.redAccent,
                              textColor: Colors.white,
                              fontSize: 16.0);
                          return;
                        }
                        requestReset(_phone);
                      },
                      child: Center(
                        child: ContainerResponsive(
                          margin: EdgeInsetsResponsive.only(
                              left: 30, right: 30, top: 5, bottom: 5),
                          height: 70,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context).primaryColor),
                          child: Center(
                            child: TextResponsive(
                              'confirm'.tr(),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 27),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Image.asset('images/bottom_town.png')
            ]),
          )),
    );
  }
}
