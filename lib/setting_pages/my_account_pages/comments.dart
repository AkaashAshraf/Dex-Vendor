import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:mplus_provider/models/shops.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../globals.dart';

class Comments extends StatefulWidget {
  final Shop shop;
  Comments({this.shop});
  @override
  _CommentsState createState() => _CommentsState(this.shop);
}

class _CommentsState extends State<Comments> {
  var shop;
  _CommentsState(this.shop);
  _commentsCard(int index) {
    return GestureDetector(
        child: Stack(
      children: <Widget>[
        Container(
            child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(top: 10, right: 20),
                          child: Text(
                            shop.shopsComments[index]?.username != null
                                ? shop.shopsComments[index]?.username
                                : 'basha',
                            style: TextStyle(fontSize: 13),
                          )),
                      Container(
                        margin: EdgeInsets.only(top: 0, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              '4.8',
                              style: TextStyle(fontSize: 10),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            new StarRating(
                              rating: 4.8,
                              size: 15,
                              color: Color(0xffFAC917),
                            ),
                          ],
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 0, right: 20, left: 10),
                          child: Text(
                            shop.shopsComments[index]?.comment != null
                                ? shop.shopsComments[index]?.comment
                                : '',
                            style: TextStyle(
                                color: Color(0xff8D8D8D), fontSize: 13),
                            textAlign: TextAlign.right,
                          )),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                        width: 60.0,
                        height: 60.0,
                        margin: EdgeInsets.only(right: 15),
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          'images/man1.PNG',
                          width: 60,
                          height: 60,
                          fit: BoxFit.contain,
                        )
                        /*CachedNetworkImage(
                            imageUrl: baseImageURL+comments[index].userimage.replaceAll('\\', '/'),
                            width: 60,
                            height: 60,
                            fit: BoxFit.contain,
                            placeholder: (context, url) => Image.asset ,width: 60,height: 60,),
                            errorWidget: (context, url, error) => Image.asset('images/image404.png',width: 60,height: 60,),
                          ),*/
                        ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 1,
              color: Color(0xff8D8D8D),
            )
          ],
        )),
        Container(
            margin: EdgeInsets.only(left: 20, top: 13),
            child: Icon(
              Icons.assistant_photo,
              color: Colors.grey,
              size: 17,
            ))
      ],
    ));
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
              child: Container(
                child: Column(
                  children: <Widget>[
                    SizedBoxResponsive(
                      height: 70,
                    ),
                    appBar(
                        context: context,
                        backButton: true,
                        title: 'comments'.tr()),
                    SizedBoxResponsive(
                      height: 60,
                    ),
                    Container(
                      width: 350,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          new StarRating(
                            rating: 4.0,
                            size: 15,
                            color: Color(0xffFAC917),
                          ),
                          SizedBoxResponsive(
                            width: 6,
                          ),
                          TextResponsive(
                            '(' + ' ${shop.shopsComments.length} ' + ')',
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBoxResponsive(
                            width: 20,
                          ),
                          TextResponsive(
                            'commentsNumber'.tr(),
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 30,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 130, bottom: 50),
              width: MediaQuery.of(context).size.width / 100 * 100,
              height: MediaQuery.of(context).size.height / 100 * 100,
              child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) => _commentsCard(index),
                itemCount: shop.shopsComments.length,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Card(
                elevation: 0,
                child: ContainerResponsive(
                    heightResponsive: true,
                    widthResponsive: true,
                    color: Colors.white,
                    height: 75,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ContainerResponsive(
                          heightResponsive: true,
                          widthResponsive: true,
                          child: Image.asset(
                            'images/send.PNG',
                          ),
                        ),
                        ContainerResponsive(
                          heightResponsive: true,
                          widthResponsive: true,
                          width: 630,
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xffF1F1F1)),
                            borderRadius: BorderRadius.circular(5),
                            color: Color(0xffF1F1F1),
                          ),
                          child: Padding(
                            padding: EdgeInsetsResponsive.only(
                                right: 8.0, bottom: 15),
                            child: TextField(
                              enabled: true,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'writeYourComment'.tr(),
                                  hintStyle: TextStyle(fontSize: 13),
                                  alignLabelWithHint: true),
                              textAlign: TextAlign.right,
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                color: Color(0xff111111),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
