// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:responsive_widgets/responsive_widgets.dart';
// import 'globals.dart';
// import 'media_pick.dart';

// class ChatPage extends StatefulWidget {
//   final String chatId;
//   final String rID;
//   final String rName;
//   final String rImage;
//   final String chatID;
//   ChatPage({this.chatId, this.rID, this.rName, this.rImage, this.chatID});
//   @override
//   ChatPageState createState() {
//     return new ChatPageState();
//   }
// }

// class ChatPageState extends State<ChatPage> {
//   final db = FirebaseFirestore.instance;
//   CollectionReference chatReference;
//   final TextEditingController _textController = new TextEditingController();
//   bool isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     chatReference =
//         db.collection("chats").doc(widget.chatID).collection('messages');
//   }

//   File imageFile;
//   Future<void> getImage() async {
//     var pickedFile = await showDialog(
//         context: context, builder: (context) => MediaPickDialog());
//     if (pickedFile != null)
//       setState(() {
//         imageFile = pickedFile;
//         if (imageFile != null) {
//           setState(() {});
//           uploadFile(imageFile);
//         }
//       });
//   }

//   List<Widget> generateSenderLayout(DocumentSnapshot documentSnapshot) {
//     return <Widget>[
//       new Material(
//         borderRadius: BorderRadius.circular(50),
//         color: Colors.green,
//         child: ContainerResponsive(
//           margin: EdgeInsetsResponsive.only(
//               left: 30, right: 30, top: 10, bottom: 10),
//           child: new Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: <Widget>[
//               new TextResponsive(documentSnapshot.data()['sender_name'],
//                   style: new TextStyle(
//                       fontSize: 25,
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold)),
//               documentSnapshot.data()['image_url'] != ''
//                   ? InkWell(
//                       child: new ContainerResponsive(
//                         child: Image.network(
//                           documentSnapshot.data()['image_url'],
//                           fit: BoxFit.fitWidth,
//                         ),
//                         height: 150,
//                         width: 150.0,
//                         color: Color.fromRGBO(0, 0, 0, 0.2),
//                         padding: EdgeInsetsResponsive.all(5),
//                       ),
//                       onTap: () {},
//                     )
//                   : new TextResponsive(documentSnapshot.data()['text'],
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 25,
//                       )),
//             ],
//           ),
//         ),
//       ),
//       new Column(
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: <Widget>[
//           new ContainerResponsive(
//               margin: EdgeInsetsResponsive.only(left: 8.0),
//               child: new CircleAvatar(
//                 backgroundColor: Colors.grey,
//                 backgroundImage: new NetworkImage(
//                     baseImageURL + documentSnapshot.data()['profile_photo']),
//               )),
//         ],
//       ),
//     ];
//   }

//   List<Widget> generateReceiverLayout(DocumentSnapshot documentSnapshot) {
//     return <Widget>[
//       new Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           new ContainerResponsive(
//               margin: EdgeInsetsResponsive.only(right: 10),
//               child: new CircleAvatar(
//                 backgroundColor: Colors.grey,
//                 backgroundImage: new NetworkImage(
//                     baseImageURL + documentSnapshot.data()['profile_photo']),
//               )),
//         ],
//       ),
//       new Material(
//         borderRadius: BorderRadius.circular(50),
//         color: Colors.grey.shade200,
//         child: Center(
//           child: ContainerResponsive(
//             margin: EdgeInsetsResponsive.only(
//                 left: 30, right: 30, top: 10, bottom: 10),
//             child: new Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: <Widget>[
//                 new TextResponsive(
//                     documentSnapshot.data()['receiver_name'] == ""
//                         ? "Undefined"
//                         : documentSnapshot.data()['receiver_name'],
//                     style: new TextStyle(
//                         fontSize: 25,
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold)),
//                 new ContainerResponsive(
//                   margin: EdgeInsetsResponsive.only(top: 5.0),
//                   child: documentSnapshot.['image_url'] != ''
//                       ? InkWell(
//                           child: new Container(
//                             child: Image.network(
//                               documentSnapshot.data()['image_url'],
//                               fit: BoxFit.fitWidth,
//                             ),
//                             height: 150,
//                             width: 150.0,
//                             color: Color.fromRGBO(0, 0, 0, 0.2),
//                             padding: EdgeInsetsResponsive.all(5),
//                           ),
//                           onTap: () {},
//                         )
//                       : new TextResponsive(documentSnapshot.data()['text'],
//                           style: new TextStyle(
//                             fontSize: 25,
//                           )),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     ];
//   }

//   generateMessages(AsyncSnapshot<QuerySnapshot> snapshot) {
//     return snapshot.data.docs
//         .map<Widget>((doc) => Container(
//             margin: const EdgeInsets.symmetric(vertical: 10.0),
//             child: doc.data() != userId.toString()
//                 ? Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: generateReceiverLayout(doc))
//                 : Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: generateSenderLayout(doc))))
//         .toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     ResponsiveWidgets.init(context,
//         height: 1560, width: 720, allowFontScaling: true);

//     return ResponsiveWidgets.builder(
//       height: 1560,
//       width: 720,
//       allowFontScaling: true,
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.green,
//           title: TextResponsive(widget.rName, style: TextStyle(fontSize: 40)),
//         ),
//         body: GestureDetector(
//           onTap: () {
//             FocusScope.of(context).unfocus();
//           },
//           child: ContainerResponsive(
//             padding: EdgeInsetsResponsive.all(5),
//             child: new Column(
//               children: <Widget>[
//                 StreamBuilder<QuerySnapshot>(
//                   stream: chatReference
//                       .orderBy('time', descending: true)
//                       .snapshots(),
//                   builder: (BuildContext context,
//                       AsyncSnapshot<QuerySnapshot> snapshot) {
//                     if (snapshot.hasData)
//                       return new Expanded(
//                         child: new ListView(
//                           reverse: true,
//                           children: generateMessages(snapshot),
//                         ),
//                       );
//                     return Expanded(
//                       child: new Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: <Widget>[
//                             Icon(
//                               Icons.no_sim,
//                               color: Colors.grey,
//                             ),
//                             SizedBoxResponsive(
//                               height: 60,
//                             ),
//                             TextResponsive("لا توجد رسائل فس هذه المحادثة")
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//                 new Divider(height: 1.0),
//                 new ContainerResponsive(
//                   decoration:
//                       new BoxDecoration(color: Theme.of(context).cardColor),
//                   child: _buildTextComposer(),
//                 ),
//                 new Builder(builder: (BuildContext context) {
//                   return new ContainerResponsive(width: 0.0, height: 0.0);
//                 })
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   IconButton getDefaultSendButton() {
//     return new IconButton(
//         icon: new Icon(
//           Icons.send,
//           color: !isLoading ? Colors.green : Colors.grey,
//         ),
//         onPressed: !isLoading ? () => _sendText(2) : null,
//         color: !isLoading ? Colors.green : Colors.grey);
//   }

//   Widget _buildTextComposer() {
//     return new IconTheme(
//         data: new IconThemeData(
//           color: !isLoading ? Colors.green : Theme.of(context).disabledColor,
//         ),
//         child: new ContainerResponsive(
//           margin: EdgeInsetsResponsive.symmetric(horizontal: 8.0),
//           child: new Row(
//             children: <Widget>[
//               Material(
//                 child: new ContainerResponsive(
//                   margin: new EdgeInsetsResponsive.symmetric(horizontal: 1.0),
//                   child: new IconButton(
//                     icon: new Icon(Icons.image),
//                     onPressed: () async {
//                       isLoading ? null : getImage();
//                     }, // getSticker,
//                     color: !isLoading ? Colors.green : Colors.grey,
//                   ),
//                 ),
//                 color: Colors.white,
//               ),
//               /*new Container(
//                 margin: new EdgeInsets.symmetric(horizontal: 4.0),
//                 child: new IconButton(
//                     icon: new Icon(
//                       Icons.photo_camera,
//                       color: Colors.green,
//                     ),
//                     onPressed: () async {
//                       var image = await ImagePicker.pickImage(
//                           source: ImageSource.gallery);
//                       int timestamp = new DateTime.now().millisecondsSinceEpoch;
//                       StorageReference storageReference = FirebaseStorage
//                           .instance
//                           .ref()
//                           .child('chats/img_' + timestamp.toString() + '.jpg');
//                       StorageUploadTask uploadTask =
//                       storageReference.putFile(image);
//                       await uploadTask.onComplete;
//                       String fileUrl = await storageReference.getDownloadURL();
//                       _sendImage(messageText: null, imageUrl: fileUrl);
//                     }),
//               ),*/
//               new Flexible(
//                 child: new TextField(
//                   textAlign: TextAlign.right,
//                   controller: _textController,
//                   onChanged: (String messageText) {
//                     setState(() {
//                       // isLoading = messageText.length > 0;
//                     });
//                   },
//                   onSubmitted: _sendText,
//                   decoration:
//                       new InputDecoration.collapsed(hintText: "ارسل رسالة"),
//                 ),
//               ),
//               new ContainerResponsive(
//                 margin: EdgeInsetsResponsive.symmetric(horizontal: 4.0),
//                 child: getDefaultSendButton(),
//               ),
//             ],
//           ),
//         ));
//   }

//   String imageUrl;

//   Future uploadFile(image) async {
//     isLoading = true;
//     setState(() {});
//     String fileName = DateTime.now().millisecondsSinceEpoch.toString();
//     var reference = FirebaseStorage.instance.ref().child(fileName);
//     var uploadTask = reference.putFile(image);
//     var storageTaskSnapshot = await uploadTask.whenComplete(() => null);
//     storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
//       imageUrl = downloadUrl;
//       setState(() {
//         // isLoading = false;

//         _sendText(1);
//       });
//     }, onError: (err) {
//       setState(() {
//         // isLoading = false;
//       });
//       Fluttertoast.showToast(msg: 'This file is not an image');
//     });
//   }

//   Future<Null> _sendText(type) async {
//     if (type == 1) {
//       chatReference.add({
//         'text': '',
//         'sender_id': userId.toString(),
//         'sender_name': userName,
//         'receiver_id': widget.rID,
//         'receiver_name': widget.rName,
//         'profile_photo': userImage,
//         'receiver_profile': widget.rImage,
//         'image_url': imageUrl,
//         'time': FieldValue.serverTimestamp(),
//       }).then((documentReference) {
//         sendNoti('  صورة', userName, '  صورة', userName);

//         setState(() {
//           isLoading = false;
//         });
//       }).catchError((e) {});
//     } else {
//       if (_textController.text == "") {
//         FocusScope.of(context).unfocus();
//       } else {
//         chatReference.add({
//           'text': _textController.text,
//           'sender_id': userId.toString(),
//           'sender_name': userName,
//           'receiver_id': widget.rID,
//           'receiver_name': widget.rName,
//           'profile_photo': userImage,
//           'receiver_profile': widget.rImage,
//           'image_url': '',
//           'time': FieldValue.serverTimestamp(),
//         }).then((documentReference) {
//           sendNoti(
//               _textController.text, userName, _textController.text, userName);

//           setState(() {
//             _textController.clear();

//             isLoading = false;
//           });
//         }).catchError((e) {});
//       }
//     }
//   }

//   Future<void> sendNoti(dataBody, dataTit, notiBody, notiTit) async {
//     try {
//       // loadinsg = true;

//       print(
//           'http://www.matajerplus-om.com/api/fire/userId&${widget.rID}/title&$notiTit/body&${notiBody}datatitle&$dataTit/databody&$dataBody');
//       var response = await dioClient.get(
//           'http://www.matajerplus-om.com/api/fire/userId&${widget.rID}/title&$notiTit/body&${notiBody}datatitle&$dataTit/databody&$dataBody');

//       print(response.data);
//     } catch (e) {}
//   }

//   void _sendImage({String messageText, String imageUrl}) {
//     chatReference.add({
//       'text': messageText,
//       'sender_id': "",
//       'sender_name': "",
//       'receiver_id': "",
//       'receiver_name': "",
//       'profile_photo': "",
//       'image_url': imageUrl,
//       'time': FieldValue.serverTimestamp(),
//     });
//   }
// }
