import 'package:flutter/material.dart';
import 'package:mplus_provider/setting_pages/notification_page.dart';

import 'custom_dialog.dart';

class AddExistProductThree extends StatefulWidget {
  @override
  _AddExistProductThreeState createState() => _AddExistProductThreeState();
}

class _AddExistProductThreeState extends State<AddExistProductThree> {
  var width, height;

  _categoryCard(BuildContext context, int index, double _width) {
    return Container(
      width: _width,
      child: Stack(
        children: <Widget>[
          Container(
              width: _width,
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Color(0xffF8F8F8),
              ),
              margin: EdgeInsets.only(right: 5, left: 5, top: 5, bottom: 15),
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(left: 26, right: 25, top: 0),
                      child: Image.asset(
                        'images/orange.png',
                        width: 68,
                        height: 60,
                        fit: BoxFit.contain,
                      )
                      /* CachedNetworkImage(
                  width: 78,
                  height: 75,
                  imageUrl: baseImageURL+categoryList[index].image,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => Center(child: Image.a 
                  errorWidget: (context, url, error) => Image.asset('images/image404.png'),
                ),*/
                      ),
                  SizedBox(
                    height: 4,
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 26, right: 25, top: 0),
                      child: Image.asset(
                        'images/shadow.png',
                        width: 105,
                        height: 8,
                        fit: BoxFit.contain,
                      )),
                  SizedBox(
                    height: 8,
                  ),
                  Center(
                      child: Text(
                    'فواكة طازجة',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                  )),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                      height: 100,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5, left: 5),
                        child: Text(
                          'هذا النص هو مثال لنص اخر يمكن ان يستبدل بنص اخر',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.black45,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )),
                ],
              )),
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => CustomDialog(
                    type: 'addToStore',
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.only(top: 10),
                height: 35,
                width: 140,
                decoration: BoxDecoration(
                    color: Color(0xff34C961),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10))),
                child: Center(
                  child: Text(
                    'عرض في متجري',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height / 100;
    width = MediaQuery.of(context).size.width / 100;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: <Widget>[
          /*** Header One ***/
          SliverPadding(
            padding: EdgeInsets.all(0.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  SizedBox(
                    height: 40,
                  ),
                  SizedBox(
                    height: 40,
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                            left: 25,
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
                            right: 45,
                            top: 2,
                            child: Text(
                              'منتجات جاهزة',
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.w600),
                            )),
                        Positioned(
                            right: 5,
                            top: 0,
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
                ],
              ),
            ),
          ),

          ///*** Header Two ***/
          SliverPadding(
            padding: EdgeInsets.all(0.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            Container(
                              width:
                                  MediaQuery.of(context).size.width / 100 * 85,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: Color(0xffF9F9F9),
                                  borderRadius: BorderRadius.circular(2)),
                              child: TextField(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: ' بحث عن منتج معين ',
                                  contentPadding:
                                      EdgeInsets.only(right: 10, top: 8),
                                  hintStyle: TextStyle(fontSize: 15),
                                  prefixIcon: Icon(
                                    Icons.search,
                                    size: 20,
                                  ),
                                ),
                                textAlign: TextAlign.right,
                                keyboardType: TextInputType.visiblePassword,
                                style: TextStyle(
                                  color: Color(0xff111111),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),

          SliverGrid(
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) =>
                  _categoryCard(context, index, 185.0),
              childCount: 20,
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(0.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
