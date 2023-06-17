import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:mplus_provider/models/delivery_history.dart';
import 'package:mplus_provider/models/message.dart';
import 'package:mplus_provider/models/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'globals.dart';

class Recipt extends StatefulWidget {
  final String from;
  final int orderId;
  final String peerId;

  Recipt({
    this.orderId,
    this.peerId,
    this.from,
  });
  @override
  _ReciptState createState() => _ReciptState(orderId, peerId);
}

class _ReciptState extends State<Recipt> {
  bool loading = false;
  DeliveryHistory deliveryOrder;
  _ReciptState(this.orderId, this.peerId);
  var _price = TextEditingController();
  final int orderId;
  final String peerId;
  SharedPreferences prefs;
  String id;
  File reciprtimg;
  bool isLoading;
  double price;

  Future<void> getOrderDetails({int deliveryId}) async {
    try {
      setState(() {
        loading = true;
      });
      var response =
          await Dio().get(baseURL + 'DeliveryInfo/deliveryId&$deliveryId');
      var data = response.data;
      deliveryOrder = DeliveryHistory.fromJson(data);
      price = deliveryOrder.deliveryPrice + deliveryOrder.orderInfo.totalValue;
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

  @override
  void initState() {
    super.initState();
    getOrderDetails(deliveryId: orderId);
    reciprtimg = null;
    isLoading = false;
    _price.clear();
  }

  String imageUrl;

  Widget buildLoading() {
    return Positioned(
      child: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).accentColor)),
              ),
              color: Colors.white.withOpacity(0.8),
            )
          : Container(),
    );
  }

  void sendText(type) async {
    try {
      if (type == 'img') {
        FormData data = FormData.fromMap({
          'thread_id': '${widget.orderId}',
          'sender_id': user.id,
          'target': widget.peerId,
          'title': type,
          'image': await MultipartFile.fromFile(reciprtimg.path,
              filename: DateTime.now().millisecondsSinceEpoch.toString()),
        });
        var response = await Dio().post(baseURL + "addChatMessage", data: data);
        print(response.data);
        print(response.data);
        messages = Messages.fromJson(response.data);
        messages.message = messages.message.toSet().toList();
        nesxtPage = messages.nextPageUrl;
        messages.message = messages.message.reversed.toList();
        messages.message = messages.message.toSet().toList();
      } else {
        var content;
        content = "  تكلفة البضاعة " + ":" + "${_price.text} ر.س \n ";
        content = content +
            " " +
            " تكلفة التوصيل " +
            ":" +
            "${price.toStringAsFixed(2)} ر.س \n";
        content = content +
            "      " +
            " الاجمالي  " +
            ":" +
            "${(price + int.parse(_price.text)).toString()} ر.س ";
        FormData data = FormData.fromMap({
          'thread_id': '${widget.orderId}',
          'sender_id': user.id,
          'target': widget.peerId,
          'title': type,
          'body': content,
        });
        var response = await Dio().post(baseURL + "addChatMessage", data: data);
        print(response.data);
        messages = Messages.fromJson(response.data);
        messages.message = messages.message.toSet().toList();
        nesxtPage = messages.nextPageUrl;
        messages.message = messages.message.reversed.toList();
      }
      if (this.mounted) {
        setState(() {});
      }
    } catch (_) {
      await Fluttertoast.showToast(
          msg: "error",
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.redAccent,
          textColor: Colors.green,
          fontSize: 15.0);
      if (this.mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void onSendMessage(type) {
    setState(() {
      isLoading = true;
    });
    if (type == 0) {
      sendText(' text');
    } else {
      sendText('img');
    }
    if (type == 1) {
      sendRecipt();
    } else {
      onSendMessage(1);
    }
  }

  getOrder(deliveryId) async {
    try {
      print(baseURL + '/DeliveryInfo/deliveryId&$deliveryId');
      var response =
          await Dio().get(baseURL + 'DeliveryInfo/deliveryId&$deliveryId');
      var data = response.data;
      if (data != null) {
        isLoading = false;

        deliveryOrder = DeliveryHistory.fromJson(data);
        price =
            deliveryOrder.deliveryPrice + deliveryOrder.orderInfo.totalValue;
        sendNoti('msg', user.firstName);
        await Fluttertoast.showToast(
            msg: "reciptSent",
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.white,
            textColor: Colors.green,
            fontSize: 15.0);
        Navigator.pop(context);
        // mainPage = HomePage();
        // await Navigator.pushReplacement(
        //     context, MaterialPageRoute(builder: (context) => Home()));
      } else {
        await Fluttertoast.showToast(
            msg: "error",
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.redAccent,
            textColor: Colors.green,
            fontSize: 15.0);
        setState(() {
          isLoading = false;
        });
      }
    } on DioError catch (error) {
      await Fluttertoast.showToast(
          msg: "error",
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.redAccent,
          textColor: Colors.green,
          fontSize: 15.0);
      setState(() {
        isLoading = false;
      });
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
      await Fluttertoast.showToast(
          msg: "error",
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.redAccent,
          textColor: Colors.green,
          fontSize: 15.0);
      if (this.mounted) {
        setState(() {
          isLoading = false;
        });
      }
      rethrow;
    }
  }

  sendRecipt() async {
    try {
      var response = await Dio().get(baseURL +
          'addOrderBill/orderId&${widget.orderId}billValue&${(price + int.parse(_price.text)).toString()}');
      var data = response.data;
      if (data['State'] == 'sucess') {
        getOrder(deliveryOrder.id);
      } else {
        await Fluttertoast.showToast(
            msg: "error",
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.redAccent,
            textColor: Colors.green,
            fontSize: 15.0);
        setState(() {
          isLoading = false;
        });
      }
      if (this.mounted) {
        setState(() {});
      }
    } on DioError catch (error) {
      await Fluttertoast.showToast(
          msg: "error",
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.redAccent,
          textColor: Colors.green,
          fontSize: 15.0);
      setState(() {
        isLoading = false;
      });
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
      await Fluttertoast.showToast(
          msg: "error",
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.redAccent,
          textColor: Colors.green,
          fontSize: 15.0);
      if (this.mounted) {
        setState(() {
          isLoading = false;
        });
      }
      rethrow;
    }
  }

  void sendNoti(dataTit, notiTit) async {
    try {
      var reciver = widget.from == 'customer' ? '1' : '2';
      var response = await Dio().get(
          '${baseNotificationURL}userId=$peerId/userTypeId=$reciver/title=$notiTit/body=فاتورةdatatitle=$dataTit/databody=فاتورة');

      print(response.data);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).accentColor,
            title: Text(
              'Recipt',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    if (_price.text == "") {
                      Fluttertoast.showToast(msg: 'enterGoodsPrice');
                    } else if (reciprtimg == null) {
                      Fluttertoast.showToast(msg: 'insertReciptImg');
                    } else {
                      isLoading = true;
                      setState(() {});
                      onSendMessage(0);
                    }
                  },
                  child: Text(
                    'send',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ))
            ]),
        body: Center(
          child: isLoading
              ? Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                  color: Colors.white.withOpacity(0.8),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Container(
                        child: TextField(
                            decoration: InputDecoration(
                              enabledBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 0.0),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              hintText: 'enterGoodsPrice',
                              labelText: 'goodsPrice',
                              alignLabelWithHint: true,
                            ),
                            textAlignVertical: TextAlignVertical.center,
                            focusNode: null,
                            textInputAction: TextInputAction.done,
                            controller: _price,
                            keyboardType: TextInputType.number),
                      ),
                    ),
                    Container(
                      height: 50,
                      margin: const EdgeInsets.all(18.0),
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white,
                              blurRadius: 3,
                              offset: Offset(0, 2),
                            ),
                          ],
                          border: Border.all(
                              color: Colors.grey.withOpacity(.25), width: 2)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'currentPrice',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontFamily: null,
                                fontWeight: FontWeight.normal),
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                deliveryOrder.deliveryPrice.toString(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontFamily: null,
                                    fontWeight: FontWeight.normal),
                              ),
                              SizedBox(width: 5),
                              Text(
                                "sar",
                                style: TextStyle(
                                    color: Theme.of(context).accentColor,
                                    fontSize: 12,
                                    fontFamily: null,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white,
                              blurRadius: 3,
                              offset: Offset(0, 2),
                            ),
                          ],
                          border: Border.all(
                              color: Colors.grey.withOpacity(.25), width: 2)),
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "total" + " : ",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontFamily: null,
                                fontWeight: FontWeight.normal),
                          ),
                          Text(
                            _price.text != ""
                                ? (price + int.parse(_price.text.toString()))
                                    .toString()
                                : price.toStringAsFixed(2),
                            style: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontSize: 13,
                                fontFamily: null,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () async {
                        if (reciprtimg == null) {
                          var pickedfile = await ImagePicker().getImage(
                              source: ImageSource.camera, imageQuality: 50);
                          var result = File(pickedfile.path);
                          var lostData = await ImagePicker().getLostData();
                          if (lostData.file != null) {
                            result = File(lostData.file.path);
                          }
                          reciprtimg = result;
                          if (this.mounted) {
                            setState(() {});
                          }
                        }
                      },
                      child: Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              padding: EdgeInsets.all(0),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey, width: 3),
                                // shape: BoxShape.circle,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20.0),
                                ),
                                child: Container(

                                    // margin: EdgeInsets.only(left: 0, top: 8),
                                    width: 300,
                                    height: 100,
                                    padding: EdgeInsets.all(0),
                                    decoration: BoxDecoration(
                                      // border: Border.all(color: Colors.grey),
                                      // shape: BoxShape.circle,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: reciprtimg == null
                                        ? Icon(Icons.camera)
                                        : Image.file(
                                            reciprtimg,
                                            fit: BoxFit.fill,
                                          )),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 20,
                            top: 70,
                            // right: ,
                            child: reciprtimg != null
                                ? GestureDetector(
                                    onTap: () async {
                                      var pickedfile = await ImagePicker()
                                          .getImage(
                                              source: ImageSource.camera,
                                              imageQuality: 50);
                                      var result = File(pickedfile.path);
                                      var lostData =
                                          await ImagePicker().getLostData();
                                      if (lostData.file != null) {
                                        result = File(lostData.file.path);
                                      }
                                      reciprtimg = result;
                                      setState(() {});
                                    },
                                    child: Container(
                                      width: 35,
                                      height: 35,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 5, color: Colors.white),
                                          color: Theme.of(context).primaryColor,
                                          shape: BoxShape.circle),
                                      child: Center(
                                        child: Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
        ));
  }
}
