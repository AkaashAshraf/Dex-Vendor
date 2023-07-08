import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mplus_provider/models/categories.dart';
import 'package:mplus_provider/setting_pages/notification_page.dart';
import 'package:mplus_provider/ui/widgets/loading.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:easy_localization/easy_localization.dart';

import 'add_exist_product_two.dart';
import 'globals.dart';

class AddExistProductOne extends StatefulWidget {
  @override
  _AddExistProductOneState createState() => _AddExistProductOneState();
}

class _AddExistProductOneState extends State<AddExistProductOne> {
  var width, height;
  List<Category> categories = [];
  var load = 0;

  _categoryCard(BuildContext context, int index, double _width) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddExistProductTwo(
                      category: categories[index],
                    )));
      },
      child: Center(
        child: ContainerResponsive(
            width: 350,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Color(0xffF8F8F8),
            ),
            margin: EdgeInsetsResponsive.all(5),
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: false,
              children: <Widget>[
                Center(
                  child: ContainerResponsive(
                    width: 140,
                    height: 120,
                    margin:
                        EdgeInsetsResponsive.only(left: 25, right: 25, top: 0),
//                  child: Image.asset('images/orange.png',width: 78,height: 75,fit: BoxFit.contain,)
                    child: CachedNetworkImage(
                      imageUrl: baseImageURL + categories[index].image,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => ImageLoad(70.0),
                      errorWidget: (context, url, error) => Image.asset(
                        'images/image404.png',
                        height: 70,
                      ),
                    ),
                  ),
                ),
                SizedBoxResponsive(
                  height: 10,
                ),
                Center(
                  child: ContainerResponsive(
                      width: 120,
                      margin: EdgeInsetsResponsive.only(
                          left: 25, right: 25, top: 0),
                      child: Image.asset(
                        'images/shadow.png',
                        fit: BoxFit.cover,
                      )),
                ),
                SizedBoxResponsive(
                  height: 20,
                ),
                Center(
                    child: TextResponsive(
                  categories[index].name != null ? categories[index].name : '',
                  style: TextStyle(
                      fontSize: 36,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                )),
                SizedBoxResponsive(
                  height: 20,
                ),
                Center(
                    child: TextResponsive(
                  categories[index].description != null
                      ? categories[index].description
                      : '',
                  style: TextStyle(
                    fontSize: 26,
                    color: Colors.black45,
                  ),
                )),
                SizedBoxResponsive(
                  height: 20,
                ),
              ],
            )),
      ),
    );
  }

  _getCategories() async {
    try {
      var response = await dioClient.get(baseURL + 'getCategories');

      categories = [];

      var data = response.data;
      var category = data as List;
      print('DATA $category');

      category.forEach((v) {
        categories.add(Category.fromJson(v));
      });

      setState(() {
        load = load + 1;
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
    // TODO: implement initState
    _getCategories();
    super.initState();
  }

  homeLoad() {
    return Column(
      children: <Widget>[
        SizedBoxResponsive(
          height: 70,
        ),
        SizedBoxResponsive(
          height: 80,
          child: Stack(
            children: <Widget>[
              ContainerResponsive(
                  width: 100,
                  height: 100,
                  child: FlatButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NotificationPage()));
                      },
                      child: Image.asset(
                        'images/ring.PNG',
                        fit: BoxFit.cover,
                      ))),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextResponsive(
                    'ReadyProduct'.tr(),
                    style: TextStyle(fontSize: 48, fontWeight: FontWeight.w600),
                  ),
                  ContainerResponsive(
                    child: IconButton(
                        icon: Icon(
                          Icons.arrow_forward,
                          color: Color(0xff575757),
                          size: 25,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBoxResponsive(
          height: 40,
        ),
        Center(child: Load(150.0))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveWidgets.init(context,
        height: 1560, width: 720, allowFontScaling: true);

    height = MediaQuery.of(context).size.height / 100;
    width = MediaQuery.of(context).size.width / 100;

    return ResponsiveWidgets.builder(
      height: 1560,
      width: 720,
      allowFontScaling: true,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: load < 1
            ? homeLoad()
            : CustomScrollView(
                slivers: <Widget>[
                  /*** Header One ***/
                  SliverPadding(
                    padding: EdgeInsetsResponsive.all(0.0),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          SizedBoxResponsive(
                            height: 70,
                          ),
                          SizedBoxResponsive(
                            height: 80,
                            child: Stack(
                              children: <Widget>[
                                ContainerResponsive(
                                    width: 100,
                                    height: 100,
                                    child: FlatButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      NotificationPage()));
                                        },
                                        child: Icon(
                                          Icons.notifications_none,
                                          size:
                                              ScreenUtil().setSp(50).toDouble(),
                                          color: Theme.of(context).accentColor,
                                        ))),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    TextResponsive(
                                      'ReadyProduct'.tr(),
                                      style: TextStyle(
                                          fontSize: 48,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    ContainerResponsive(
                                      child: IconButton(
                                          icon: Icon(
                                            Icons.arrow_forward,
                                            color: Color(0xff575757),
                                            size: 25,
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          }),
                                    ),
                                  ],
                                ),
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
                          SizedBoxResponsive(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              ContainerResponsive(
                                child: Row(
                                  children: <Widget>[
                                    ContainerResponsive(
                                      width: 630,
                                      height: 75,
                                      decoration: BoxDecoration(
                                          color: Color(0xffF9F9F9),
                                          borderRadius:
                                              BorderRadius.circular(2)),
                                      child: TextField(
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'productSearch'.tr(),
                                          contentPadding:
                                              EdgeInsetsResponsive.only(
                                                  right: 15, top: 17),
                                          hintStyle: TextStyle(
                                              fontSize: ScreenUtil()
                                                  .setSp(22)
                                                  .toDouble()),
                                          prefixIcon: Icon(
                                            Icons.search,
                                            size: 20,
                                          ),
                                        ),
                                        textAlign: TextAlign.right,
                                        keyboardType:
                                            TextInputType.visiblePassword,
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
                          SizedBoxResponsive(
                            height: 40,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) =>
                          _categoryCard(context, index, 185.0),
                      childCount: categories.length,
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsetsResponsive.all(0.0),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          SizedBoxResponsive(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
