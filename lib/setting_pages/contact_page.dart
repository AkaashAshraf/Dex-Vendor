import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mplus_provider/globals.dart';
import 'package:mplus_provider/ui/widgets/loading.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:mplus_provider/media_pick.dart';
import 'package:mplus_provider/models/user.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

class ContactPage extends StatefulWidget {
  final User user;

  const ContactPage({Key key, this.user}) : super(key: key);
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  var _isLoading;

  TextEditingController customerName = TextEditingController();
  TextEditingController customerEmail = TextEditingController();
  var customerId;

  TextEditingController feedBackTitle = TextEditingController();
  TextEditingController feedBackBody = TextEditingController();
  File _feedBackImage;

  var _name, _email, _feedBackTitle, _feedBackBody;

  Future contactUs(String name, String email, String id, String feedBackBody,
      String feedBackTitle, File feedBackImage) async {
    setState(() {
      _isLoading = true;
    });
    print(
        '${name + '\t' + email + '\t' + id + '\t' + feedBackBody + '\t' + feedBackImage.toString()}');

    var response = await dioClient.post(baseURL + 'sendFeedback',
        data: FormData.fromMap({
          "customerName": name,
          "feedbackTitle": feedBackTitle,
          "feedbackBody": _feedBackBody,
          "customerEmail": email,
          "customerId": customerId,
          "feedBackImg": await MultipartFile.fromFile(feedBackImage.path),
        }));

    setState(() {
      _isLoading = false;
    });
    print(response.data);
    if (response.data != null) {
      Fluttertoast.showToast(
          msg: "sent".tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.white,
          textColor: Color(0xff34C961),
          fontSize: 16.0);
      // Fluttertoast.showToast(
      //     msg: "   ستتم مراجعتها قريبا",
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.BOTTOM,
      //     timeInSecForIos: 1,
      //     backgroundColor: Colors.white,
      //     textColor: Color(0xff34C961),
      //     fontSize: 16.0);
    }
  }
//  void whatsAppOpen() async {
//    await FlutterLaunch.launchWathsApp(phone: appInfo.whatsApp.replaceFirst('00', '+'), message: "مرحبأ بك في اهلأوسهلأ ");
//  }

  void _onLink(String ur) async {
    final url = '$ur';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchWhatsApp(String ur) async {
    String phoneNumber = ur;
    String message = 'مرحبا';
    var whatsappUrl = "whatsapp://send?phone=$phoneNumber&text=$message";
    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      throw 'Could not launch $whatsappUrl';
    }
  }

  @override
  void initState() {
    var user = widget.user;
    customerName.text = user.firstName.toString();
    customerEmail.text = user.email.toString();
    customerId = user.id;
    super.initState();
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
        body: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: <Widget>[
                    SizedBoxResponsive(
                      height: 10,
                    ),
                    /////////// Header
                    appBar(
                      context: context,
                      backButton: true,
                      title: 'contactUs'.tr(),
                    ),
                    SizedBoxResponsive(
                      height: 20,
                    ),
                    ContainerResponsive(
                        heightResponsive: true,
                        widthResponsive: true,
                        child: Center(
                          child: Image.asset(
                            'images/logo.png',
                            width: 100,
                            height: 100,
                            fit: BoxFit.fill,
                          ),
                        )),

                    SizedBoxResponsive(
                      height: 12,
                    ),
                    Row(
                      children: [
                        ContainerResponsive(
                          padding:
                              EdgeInsetsResponsive.symmetric(horizontal: 70),
                          heightResponsive: true,
                          widthResponsive: true,
                          child: TextResponsive(
                            'userName'.tr(),
                            style: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontSize: 26),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                    SizedBoxResponsive(
                      height: 10,
                    ),
                    ContainerResponsive(
                      margin: EdgeInsetsResponsive.only(
                          left: 65, right: 65, top: 5),
                      height: 70,
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xffFBB746)),
                        borderRadius: BorderRadius.circular(5),
                        color: Color(0xffFFFFFF),
                      ),
                      child: Padding(
                        padding: EdgeInsetsResponsive.symmetric(
                            horizontal: 15, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ContainerResponsive(
                              width: 500,
                              child: TextField(
                                textAlignVertical: TextAlignVertical.center,
                                enabled: true,
                                controller: customerName,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'enterUsername'.tr(),
                                    hintStyle: TextStyle(
                                        fontSize:
                                            ScreenUtil().setSp(25).toDouble())),
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                    color: Color(0xff111111),
                                    fontSize:
                                        ScreenUtil().setSp(30).toDouble()),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsResponsive.only(top: 10),
                              child: Icon(
                                Icons.edit,
                                color: Color(0xffFBB746),
                                size: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBoxResponsive(
                      height: 20,
                    ),

                    Row(
                      children: [
                        ContainerResponsive(
                          heightResponsive: true,
                          widthResponsive: true,
                          padding:
                              EdgeInsetsResponsive.symmetric(horizontal: 70),
                          child: TextResponsive(
                            'email'.tr(),
                            style: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontSize: 26),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                    SizedBoxResponsive(
                      height: 10,
                    ),
                    ContainerResponsive(
                      margin: EdgeInsetsResponsive.only(
                          left: 65, right: 65, top: 5),
                      height: 70,
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xffF1F1F1)),
                        borderRadius: BorderRadius.circular(5),
                        color: Color(0xffF1F1F1),
                      ),
                      child: Padding(
                        padding: EdgeInsetsResponsive.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ContainerResponsive(
                              width: 500,
                              child: TextField(
                                controller: customerEmail,
                                enabled: true,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'enterEmail'.tr(),
                                    hintStyle: TextStyle(
                                        fontSize:
                                            ScreenUtil().setSp(25).toDouble())),
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                    color: Color(0xff111111),
                                    fontSize:
                                        ScreenUtil().setSp(30).toDouble()),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsResponsive.only(top: 10),
                              child: Icon(
                                Icons.edit,
                                color: Color(0xffFBB746),
                                size: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBoxResponsive(
                      height: 10,
                    ),
                    Row(
                      children: [
                        ContainerResponsive(
                          heightResponsive: true,
                          widthResponsive: true,
                          padding:
                              EdgeInsetsResponsive.symmetric(horizontal: 70),
                          child: TextResponsive(
                            'messageTitle'.tr(),
                            style: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontSize: 26),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                    SizedBoxResponsive(
                      height: 10,
                    ),
                    ContainerResponsive(
                      margin: EdgeInsetsResponsive.only(
                          left: 65, right: 65, top: 5),
                      height: 70,
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xffF1F1F1)),
                        borderRadius: BorderRadius.circular(5),
                        color: Color(0xffF1F1F1),
                      ),
                      child: Padding(
                        padding: EdgeInsetsResponsive.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ContainerResponsive(
                              width: 500,
                              child: TextField(
                                controller: feedBackTitle,
                                enabled: true,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'enterTitle'.tr(),
                                    hintStyle: TextStyle(
                                        fontSize:
                                            ScreenUtil().setSp(25).toDouble())),
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                    color: Color(0xff111111),
                                    fontSize:
                                        ScreenUtil().setSp(30).toDouble()),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsResponsive.only(top: 10),
                              child: Icon(
                                Icons.edit,
                                color: Color(0xffFBB746),
                                size: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBoxResponsive(
                      height: 20,
                    ),

                    Row(
                      children: [
                        ContainerResponsive(
                          heightResponsive: true,
                          widthResponsive: true,
                          padding:
                              EdgeInsetsResponsive.symmetric(horizontal: 70),
                          child: TextResponsive(
                            'writeMessage'.tr(),
                            style: TextStyle(
                                color: Color(0xff111111), fontSize: 26),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                    SizedBoxResponsive(
                      height: 10,
                    ),
                    SizedBoxResponsive(
                      height: 160,
                      child: ContainerResponsive(
                        margin: EdgeInsetsResponsive.only(
                            left: 65, right: 65, top: 5),
                        height: 70,
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xffF1F1F1)),
                          borderRadius: BorderRadius.circular(5),
                          color: Color(0xffF1F1F1),
                        ),
                        child: Padding(
                          padding: EdgeInsetsResponsive.symmetric(
                              horizontal: 15, vertical: 10),
                          child: TextField(
                            maxLines: null,
                            controller: feedBackBody,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'writeMessage'.tr(),
                                hintStyle: TextStyle(
                                    fontSize:
                                        ScreenUtil().setSp(25).toDouble())),
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                                color: Color(0xff111111),
                                fontSize: ScreenUtil().setSp(30).toDouble()),
                          ),
                        ),
                      ),
                    ),

                    SizedBoxResponsive(
                      height: 40,
                    ),
                    Row(
                      children: [
                        ContainerResponsive(
                          heightResponsive: true,
                          widthResponsive: true,
                          padding: EdgeInsetsResponsive.symmetric(
                              horizontal: 70, vertical: 0),
                          child: TextResponsive(
                            'attachImage'.tr(),
                            style: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontSize: 26),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Visibility(
                      visible: true,
                      child: Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.center,
                            child: ContainerResponsive(
                              width: 190,
                              height: 200,
                              decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border.all(
                                      width: 1, color: Colors.black26),
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
                                    _feedBackImage = pickedFile;
                                  });
                              },
                              child: ContainerResponsive(
                                  margin: EdgeInsetsResponsive.only(top: 5),
                                  width: 180,
                                  height: 190,
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: _feedBackImage == null
                                      ? Center(
                                          child: Icon(
                                            Icons.add_a_photo,
                                            size: 55,
                                            color: Colors.white,
                                          ),
                                        )
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.file(
                                            _feedBackImage,
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
                                    border: Border.all(
                                        width: 5, color: Colors.white),
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

                    _isLoading == true
                        ? Center(
                            child: ContainerResponsive(
                              height: 100,
                              child: ImageLoad(100.0),
                            ),
                          )
                        : SizedBox(),
                    SizedBoxResponsive(
                      height: 20,
                    ),

                    GestureDetector(
                      onTap: () {
                        _name = customerName.text;
                        _email = customerEmail.text;
                        _feedBackTitle = feedBackTitle.text;
                        _feedBackBody = feedBackBody.text;
                        contactUs(_name, _name, customerId.toString(),
                            _feedBackBody, _feedBackTitle, _feedBackImage);
                      },
                      child: ContainerResponsive(
                          //width: MediaQuery.of(context).size.width / 100 * 91,
                          margin: EdgeInsetsResponsive.only(
                              left: 40, right: 40, top: 5),
                          height: 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Theme.of(context).primaryColor,
                          ),
                          child: Center(
                            child: TextResponsive(
                              'send'.tr(),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 30),
                            ),
                          )),
                    ),

                    SizedBoxResponsive(
                      height: 40,
                    ),
                    Center(
                        child: TextResponsive(
                      'throughSocial'.tr(),
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 23,
                      ),
                    )),
                    SizedBoxResponsive(
                      height: 10,
                    ),
                    Stack(
                      children: <Widget>[
                        ContainerResponsive(
                          margin: EdgeInsetsResponsive.only(
                              left: 40, right: 40, top: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              GestureDetector(
                                  onTap: () {
                                    print('whatsapp');
                                    _launchWhatsApp(appInfo.whatsApp);
//                                whatsAppOpen();
                                  },
                                  child: Image.asset(
                                    'images/whats.PNG',
                                    width: 50,
                                    height: 50,
                                  )),
                              GestureDetector(
                                  onTap: () {
                                    print('instegram');
                                    _onLink(appInfo.insta);
//                                    AppAvailability.launchApp('www.instegram.com');
                                  },
                                  child: Image.asset(
                                    'images/insta.PNG',
                                    width: 50,
                                    height: 50,
                                  )),
                              GestureDetector(
                                  onTap: () {
                                    print('twitter');
                                    _onLink(appInfo.twitter);
//                                    AppAvailability.launchApp('www.twitter.com');
                                  },
                                  child: Image.asset(
                                    'images/twitter.PNG',
                                    width: 50,
                                    height: 50,
                                  )),
                              GestureDetector(
                                  onTap: () {
                                    print('facebook');
                                    _onLink(appInfo.facebook);
//                                    AppAvailability.launchApp('www.facebook.com');
                                  },
                                  child: Image.asset(
                                    'images/facebook.PNG',
                                    width: 50,
                                    height: 50,
                                  )),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
