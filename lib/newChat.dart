import 'dart:io';
import 'package:flare_flutter/flare_actor.dart';
import 'package:mplus_provider/models/message.dart';
import 'package:mplus_provider/recipt.dart';
import 'package:mplus_provider/ui/widgets/loading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import 'globals.dart';
import 'media_pick.dart';

class Chat extends StatefulWidget {
  final String from;
  final String to;
  final String status;
  final String orderId;
  final String targetId;
  final String targetName;
  final String targetImage;
  Chat({
    this.from,
    this.status,
    this.orderId,
    this.targetId,
    this.targetName,
    this.targetImage,
    this.to,
  });
  @override
  ChatState createState() {
    return ChatState();
  }
}

class ChatState extends State<Chat> {
  lilLoad(_height) {
    return SizedBox(
      width: _height - 20,
      height: _height - 20,
      child: FlareActor("assets/flrs/loadingCircles.flr",
          color: Colors.black,
          alignment: Alignment.center,
          fit: BoxFit.cover,
          animation: "Loading"),
    );
  }

  final TextEditingController _textController = TextEditingController();
  bool isLoading = true;
  bool firstLoad = true;
  bool secondLoad = false;
  bool inChatScreen = false;
  var id;
  ScrollController _scrollController = ScrollController();
  File imageFile;
  ProgressDialog pr;

  getFromSP() async {
    var pref = await SharedPreferences.getInstance();
    userId = pref.getString('user_id');
    userName = pref.getString('user_name');
    userImage = pref.getString('user_image');
  }

  @override
  void initState() {
    super.initState();
    widget.from == 'list'
        ? id = widget.orderId
        : id = widget.to == 'customer'
            ? '${widget.orderId}' + '1'
            : '${widget.orderId}' + '2';
    noti();
    getFromSP();
    getMessages();

    inChatScreen = true;
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.minScrollExtent &&
          isLoading != true) {
        getMessages();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    inChatScreen = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).accentColor,
          leading: IconButton(
              color: Colors.white,
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          actionsIconTheme: IconThemeData(color: Colors.white),
          title: Text(
            widget.targetName.toString(),
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: null,
                fontWeight: FontWeight.bold),
          )),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          padding: EdgeInsets.all(5),
          child: Column(
            children: <Widget>[
              firstLoad
                  ? Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Center(
                              child: lilLoad(200.0),
                            )
                          ],
                        ),
                      ),
                    )
                  : messages.message.isNotEmpty ?? false
                      ? Expanded(
                          child: Stack(
                            children: <Widget>[
                              ListView.builder(
                                itemCount: messages.message.length,
                                controller: _scrollController,
                                itemBuilder: (context, index) => Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10.0),
                                    child: messages.message[index].senderId
                                                .toString() !=
                                            userId.toString()
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: generateReceiverLayout(
                                                messages.message[index]))
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: generateSenderLayout(
                                                messages.message[index]))),
                              ),
                              secondLoad
                                  ? Center(child: lilLoad(80.0))
                                  : Container()
                            ],
                          ),
                        )
                      : Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.no_sim,
                                  color: Colors.grey,
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Text("noMessages".tr())
                              ],
                            ),
                          ),
                        ),
              Divider(height: 1.0),
              Container(
                decoration: BoxDecoration(color: Theme.of(context).cardColor),
                child: _buildTextComposer(),
              ),
              Builder(builder: (BuildContext context) {
                return Container(width: 0.0, height: 0.0);
              })
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> generateReceiverLayout(Message message) {
    return <Widget>[
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              margin: const EdgeInsets.only(right: 8.0),
              child: CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage:
                    NetworkImage(baseImageURL + widget.targetImage.toString()),
              )),
        ],
      ),
      Material(
        borderRadius: BorderRadius.circular(50),
        color: Theme.of(context).accentColor,
        child: Center(
          child: Container(
            margin: EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(widget.targetName.toString(),
                    style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: message.title == 'img'
                      ? InkWell(
                          child: Container(
                            child: CachedNetworkImage(
                              imageUrl: message.image != null
                                  ? baseImageURL + message.image.toString()
                                  : baseImageURL + '',
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  Center(child: ImageLoad(150.0)),
                              errorWidget: (context, url, error) => Image.asset(
                                'images/image404.png',
                                width: 20,
                                height: 20,
                              ),
                            ),
                            height: 500,
                            width: 250.0,
                            color: Color.fromRGBO(0, 0, 0, 0.2),
                            padding: EdgeInsets.all(5),
                          ),
                          onTap: () {},
                        )
                      : Container(
                          width: message.body != null
                              ? message.body.length > 50
                                  ? 300
                                  : null
                              : null,
                          child: message.body != null
                              ? Text(message.body.toString(),
                                  maxLines: 3,
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold))
                              : Container(),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    ];
  }

  List<Widget> generateSenderLayout(Message message) {
    return <Widget>[
      Material(
        borderRadius: BorderRadius.circular(50),
        color: Theme.of(context).primaryColor,
        child: Container(
          margin: EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                userName.toString(),
                style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              message.title == 'img'
                  ? InkWell(
                      child: Container(
                        child: CachedNetworkImage(
                          imageUrl: baseImageURL + message.image.toString(),
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              Center(child: ImageLoad(150.0)),
                          errorWidget: (context, url, error) => Image.asset(
                            'images/image404.png',
                            width: 20,
                            height: 20,
                          ),
                        ),
                        height: 500,
                        width: 250.0,
                        color: Color.fromRGBO(0, 0, 0, 0.2),
                        padding: EdgeInsets.all(5),
                      ),
                      onTap: () {},
                    )
                  : Container(
                      width: message.body != null
                          ? message.body.length > 50
                              ? 300
                              : null
                          : null,
                      child: Text(
                        message.body.toString(),
                        maxLines: 4,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
            ],
          ),
        ),
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Container(
              margin: const EdgeInsets.only(left: 8.0),
              child: CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage:
                    NetworkImage(baseImageURL + userImage.toString()),
              )),
        ],
      ),
    ];
  }

  Widget getDefaultSendButton() {
    return IconButton(
        icon: Icon(Icons.send,
            color: !isLoading ? Theme.of(context).primaryColor : Colors.grey),
        onPressed: !isLoading ? () => sendText(' text') : null,
        color: !isLoading
            ? Theme.of(context).primaryColor
            : Theme.of(context).primaryColor);
  }

  Widget _buildTextComposer() {
    return IconTheme(
        data: IconThemeData(
          color: !isLoading ? Theme.of(context).primaryColor : Colors.grey,
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: <Widget>[
              Material(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 1.0),
                  child: IconButton(
                      icon: Icon(
                        Icons.image,
                      ),
                      onPressed: () {
                        if (isLoading == false) {
                          getImage();
                        }
                      },
                      color: !isLoading
                          ? Theme.of(context).primaryColor
                          : Colors.grey),
                ),
                color: Colors.white,
              ),
              int.parse(widget.status) > 2 && int.parse(widget.status) < 5
                  ? Material(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 1.0),
                        child: IconButton(
                            icon: Icon(Icons.receipt),
                            onPressed: !isLoading ? sendRecipt : null,
                            color: !isLoading
                                ? Theme.of(context).primaryColor
                                : Colors.grey),
                      ),
                      color: Colors.white,
                    )
                  : Container(),
              Flexible(
                child: TextField(
                  textAlign: TextAlign.right,
                  controller: _textController,
                  onChanged: (String messageText) {},
                  decoration:
                      InputDecoration.collapsed(hintText: "sendMessage".tr()),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: getDefaultSendButton(),
              ),
            ],
          ),
        ));
  }

  void getImage() async {
    var pickedFile = await showDialog(
        context: context, builder: (context) => MediaPickDialog());
    if (pickedFile != null) {
      if (this.mounted) {
        setState(() {
          imageFile = pickedFile;
          if (imageFile != null) {
            sendText('img');
          }
        });
      }
    }
  }

  void sendRecipt() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Recipt(
                  from: widget.to,
                  orderId: int.parse(id),
                  peerId: widget.targetId,
                )));
  }

  void sendText(type) async {
    if (this.mounted) {
      setState(() {
        isLoading = true;
      });
    }
    try {
      if (type == 'img') {
        SharedPreferences pref = await SharedPreferences.getInstance();
        userId = pref.getString('user_id');
        FormData data = FormData.fromMap({
          'thread_id': id.toString(),
          'sender_id': userId.toString(),
          'target': widget.targetId,
          'title': type,
          'image': await MultipartFile.fromFile(imageFile.path,
              filename: DateTime.now().millisecondsSinceEpoch.toString()),
        });
        var response = await Dio().post(baseURL + "addChatMessage", data: data);
        print(response.data);
        messages = Messages.fromJson(response.data);
        messages.message = messages.message.toSet().toList();
        nesxtPage = messages.nextPageUrl;
        messages.message = messages.message.reversed.toList();
        animateListview();
        sendNoti('Message', userName, 'img'.tr(), userName);
      } else {
        SharedPreferences pref = await SharedPreferences.getInstance();
        userId = pref.getString('user_id');
        FormData data = FormData.fromMap({
          'thread_id': id.toString(),
          'sender_id': userId.toString(),
          'target': widget.targetId,
          'title': type,
          'body': _textController.text.toString(),
        });
        var response = await Dio().post(baseURL + "addChatMessage", data: data);
        print(response.data);
        messages = Messages.fromJson(response.data);
        messages.message = messages.message.toSet().toList();
        nesxtPage = messages.nextPageUrl;
        messages.message = messages.message.reversed.toList();
        animateListview();
        _textController.clear();
        sendNoti('Message', userName, 'message'.tr(), userName);
      }

      if (this.mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (_) {
      if (this.mounted) {
        print(_);
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void sendNoti(dataBody, dataTit, notiBody, notiTit) async {
    try {
      var reciver = widget.to == 'customer' ? '1' : '2';
      print(
          '${baseNotificationURL}userId=${widget.targetId}/userTypeId=$reciver/title=$notiTit/body=${notiBody}datatitle=$dataTit/databody=$dataBody');
      var response = await Dio().get(
          '${baseNotificationURL}userId=${widget.targetId}/userTypeId=$reciver/title=$notiTit/body=${notiBody}datatitle=$dataTit/databody=$dataBody');

      print(response.data);
    } catch (e) {
      print(e);
    }
  }

  Future getMessages() async {
    try {
      if (firstLoad) {
        var response =
            await Dio().get(baseURL + 'getchatmessages&threadId=$id');
        print(response.data);
        messages = Messages.fromJson(response.data);
        messages.message = messages.message.toSet().toList();
        nesxtPage = messages.nextPageUrl;
        messages.message = messages.message.reversed.toList();
        if (widget.from == 'home') {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Recipt(
                        from: widget.to,
                        orderId: int.parse(id),
                        peerId: widget.targetId,
                      )));
        }
        animateListview();

        if (this.mounted) {
          setState(() {
            isLoading = false;
            firstLoad = false;
          });
        }
      } else if (nesxtPage != null) {
        secondLoad = true;
        isLoading = true;
        setState(() {});
        var response = await Dio().get(nesxtPage);
        print(response.data);
        Messages newMessages = Messages.fromJson(response.data);
        nesxtPage = newMessages.nextPageUrl;
        newMessages.message = newMessages.message.reversed.toList();
        messages.message = newMessages.message + messages.message;
        messages.message = messages.message.toSet().toList();
        if (this.mounted) {
          setState(() {
            isLoading = false;
            secondLoad = false;
            firstLoad = false;
          });
        }
      }
      return messages;
    } catch (_) {
      if (this.mounted) {
        setState(() {
          isLoading = false;
          secondLoad = false;
          firstLoad = false;
        });
      }
      print(_);
    }
  }

  animateListview() async {
    try {
      Future.delayed(Duration(milliseconds: 200), () async {
        await _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut);
      });
    } catch (e) {
      print(e);
    }
  }

  void noti() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('on message $message ');
      dynamic data = message.data;
      var msg = data['text'];

      if (msg == 'msg') {
        await getMessages();
      }
    });
  }
}
