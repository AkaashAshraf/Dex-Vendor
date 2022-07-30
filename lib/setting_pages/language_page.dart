import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';

import 'notification_page.dart';

class LanguagePage extends StatefulWidget {
  @override
  _LanguagePageState createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  @override
  Widget build(BuildContext context) {
    int activeLanguaue = 0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),

                /////////// Header
                SizedBox(
                  height: 40,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                          left: 70,
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
                          right: 55,
                          top: 5,
                          child: Text(
                            'لغة التطبيق',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w300),
                          )),
                      Positioned(
                          right: 5,
                          top: 3,
                          child: IconButton(
                              icon: Icon(
                                Icons.arrow_forward,
                                color: Color(0xff575757),
                                size: 28,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              })),
                    ],
                  ),
                ),

                SizedBox(
                  height: 40,
                ),
                Container(
                    height: 50,
                    color: Color(0xffF8F8F8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 30.0),
                          child: Text(
                            'لغة التطبيق',
                            style: TextStyle(fontSize: 18),
                          ),
                        )
                      ],
                    )),

                //Radio Groups
                Container(
                  margin: EdgeInsets.only(right: 20, top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        'اللغة العربيه',
                        style: TextStyle(fontSize: 18),
                      ),
                      new Radio<int>(
                          value: 1,
                          activeColor: Color(0xff34C961),
                          groupValue: 1,
                          onChanged: (int value) {
                            setState(() {
                              activeLanguaue = 1;
                              print(activeLanguaue);
                            });
                          })
                    ],
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        'English',
                        style: TextStyle(fontSize: 18),
                      ),
                      new Radio<int>(
                          value: 2,
                          activeColor: Color(0xff34C961),
                          groupValue: 1,
                          onChanged: (int value) {
                            setState(() {
                              activeLanguaue = 2;
                              print(activeLanguaue);
                            });
                          })
                    ],
                  ),
                ),
              ],
            ),
          ),
          Image.asset('images/bottom_town.png')
        ],
      ),
    );
  }
}
