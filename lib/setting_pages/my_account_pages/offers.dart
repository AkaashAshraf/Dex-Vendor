import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';

import '../notification_page.dart';

class Offers extends StatefulWidget {
  @override
  _OffersState createState() => _OffersState();
}

class _OffersState extends State<Offers> {
  var width, height;
  _orderRow([var context, var index, var height]) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: height,
        margin: EdgeInsets.only(right: 20, left: 20, top: 5, bottom: 5),
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: Color(0xffF2F2F2)),
            borderRadius: BorderRadius.circular(5)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: 95,
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                      right: BorderSide(color: Colors.black12, width: 2))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                      child: Text(
                    'رقم الطلب',
                    style: TextStyle(
                        fontSize: 14,
                        color: Color(0xff34C961),
                        fontWeight: FontWeight.bold),
                  )),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                      child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      '12345',
                      style: TextStyle(fontSize: 13),
                    ),
                  ))
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 5, top: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(right: 8),
                          child: Text(
                            'إسم العميل',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.right,
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              'منذ :  5 دقايق',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                    width: 70,
                    height: 70,
                    margin: EdgeInsets.only(right: 5),
                    child: Image.asset('images/man1.PNG')
                    /*CachedNetworkImage(
                    imageUrl: baseImageURL +
                        '',
                    fit: BoxFit.fill,
                    placeholder: (context, url) => Image.asset(
                     
                      width: 90,
                      height: 90,
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      'images/image404.png',
                      width: 90,
                      height: 90,
                    ),
                  ),*/
                    )
              ],
            )
          ],
        ),
      ),
    );
  }

  _finishOrder(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 60,
        decoration: BoxDecoration(
            border: Border.all(width: .7, color: Color(0xffF2F2F2)),
            borderRadius: BorderRadius.circular(0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(left: 20),
                child: Icon(
                  Icons.cancel,
                  color: Colors.green,
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(right: 15, top: 0),
                    child: Text(
                      'orderHasBeenAccepted'.tr(),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.right,
                    )),
                Container(
                    width: 50,
                    height: 45,
                    margin: EdgeInsets.only(right: 15),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(4)),
                    child: Image.asset(
                      'images/fruit.PNG',
                      fit: BoxFit.contain,
                    )
                    /*CachedNetworkImage(
                    imageUrl: baseImageURL +
                        '',
                    fit: BoxFit.fill,
                    placeholder: (context, url) => Image.asset(
                  
                      width: 90,
                      height: 90,
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      'images/image404.png',
                      width: 90,
                      height: 90,
                    ),
                  ),*/
                    )
              ],
            )
          ],
        ),
      ),
    );
  }

  _newOfferImage(BuildContext context, int index) {
    return Container(
        width: width * 20,
        height: height * 14,
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: <Widget>[
            Center(
              child: Container(
                width: width * 15,
                height: height * 10,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image.asset(
                  'images/fruit.PNG',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 3, top: 0),
              width: width * 4.5,
              height: height * 3.5,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Color(0xff34c961)),
              child: Center(
                child: Icon(
                  Icons.clear,
                  color: Colors.white,
                  size: 15,
                ),
              ),
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height / 100;
    width = MediaQuery.of(context).size.width / 100;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          SizedBox(
            height: height * 4,
          ),
          SizedBox(
            height: height * 6,
            child: Stack(
              children: <Widget>[
                Positioned(
                    left: 25,
                    top: 7,
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
                    right: 45,
                    top: 10,
                    child: Text(
                      ' العروض ',
                      style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff575757)),
                    )),
                Positioned(
                    right: 5,
                    top: 1,
                    child: IconButton(
                        icon: Icon(
                          Icons.arrow_forward,
                          color: Color(0xff575757),
                          size: 25,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        })),
              ],
            ),
          ),
          SizedBox(
            height: height * 3,
          ),
          Flexible(
            child: DefaultTabController(
              initialIndex: 1,
              length: 2,
              child: SizedBox(
                child: Column(
                  children: <Widget>[
                    Container(
                      color: Color(0xffF2F2F2),
                      child: new TabBar(
                        indicatorColor: Color(0xff09C215),
                        indicatorWeight: 2,
                        tabs: <Widget>[
                          Tab(
                            child: Text(
                              'العروض السابقة',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Tab(
                            child: Text(
                              'إضافة عرض',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: height * 79.9,
                      width: MediaQuery.of(context).size.width,
                      child: TabBarView(
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                      child: Image.asset(
                                    'images/bottom_town.png',
                                    fit: BoxFit.contain,
                                  ))),
                              Container(
                                color: Colors.transparent,
                                child: ListView.builder(
                                  itemBuilder: (context, index) =>
                                      _finishOrder(context, index),
                                  itemCount: 8,
                                ),
                              ),
                            ],
                          ),
                          Container(
                              color: Colors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    width: width * 20,
                                    height: height * 12,
                                    margin: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: Color(0xff34c961),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.camera_alt,
                                          size: 25,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          'إضف صوره',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 50,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      _newOfferImage(context, 1),
                                      _newOfferImage(context, 1),
                                      _newOfferImage(context, 1),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 50,
                                  ),
                                  Container(
                                      width: MediaQuery.of(context).size.width /
                                          100 *
                                          91,
                                      margin: EdgeInsets.only(
                                          right: 17, left: 20, top: 5),
                                      height: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Color(0xff34C961),
                                      ),
                                      child: Center(
                                        child: Text(
                                          ' إرسال ',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 17),
                                        ),
                                      )),
                                ],
                              ))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
