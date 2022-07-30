import 'package:flutter/material.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          Image.asset(
            'images/cloud.png',
            height: 70,
            width: 100,
            fit: BoxFit.cover,
          ),
          Center(
            child: Container(
                width: 138,
                height: 80,
                child: Image.asset(
                  'images/logo.png',
                  fit: BoxFit.fill,
                )),
          ),
          SizedBox(
            height: 5,
          ),
          Center(
              child: Text(
            ' إستعادة كلمة المرور ',
            style: TextStyle(color: Color(0xff34C961), fontSize: 25),
          )),
          SizedBox(height: 5),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            child: Text(
              'إذا كنت تحتاج إلى عدد أكبر من الفقرات يتيح لك مولد النص العربى زيادة عدد الفقرات كما تريد، النص لن  يبدو مقسما ولا يحوي أخطاء لغوية،',
              style: TextStyle(color: Color(0xff8D8D8D), fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            margin: EdgeInsets.only(right: 20, top: 5),
            child: Text(
              ' كود التحقق',
              style: TextStyle(color: Color(0xff111111), fontSize: 14),
              textAlign: TextAlign.right,
            ),
          ),
          SizedBox(
            height: 2,
          ),
          Container(
            margin: EdgeInsets.only(right: 17, left: 20, top: 5),
            height: 40,
            decoration: BoxDecoration(
                color: Color(0xffF8F8F8),
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0, top: 5),
              child: TextField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    // prefixIcon: IconButton(icon: Icon(Icons.remove_red_eye,size: 20,color: Colors.black26,), onPressed: (){print('hide');}),
                    hintText: 'الرجاء إدخال كود التحقق',
                    hintStyle: TextStyle(fontSize: 12)),
                textAlign: TextAlign.right,
                keyboardType: TextInputType.phone,
                style: TextStyle(
                  color: Color(0xff111111),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            margin: EdgeInsets.only(right: 20, top: 5),
            child: Text(
              ' كلمة المرور الجديدة',
              style: TextStyle(color: Color(0xff111111), fontSize: 14),
              textAlign: TextAlign.right,
            ),
          ),
          SizedBox(
            height: 2,
          ),
          Container(
            margin: EdgeInsets.only(right: 17, left: 20, top: 5),
            height: 40,
            decoration: BoxDecoration(
                color: Color(0xffF8F8F8),
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0, top: 5),
              child: TextField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: IconButton(
                        icon: Icon(
                          Icons.remove_red_eye,
                          size: 20,
                          color: Colors.black26,
                        ),
                        onPressed: () {
                          print('hide');
                        }),
                    hintText: 'الرجاء إدخال كلمة المرور الجديدة',
                    hintStyle: TextStyle(fontSize: 12)),
                textAlign: TextAlign.right,
                keyboardType: TextInputType.phone,
                style: TextStyle(
                  color: Color(0xff111111),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            margin: EdgeInsets.only(right: 20, top: 5),
            child: Text(
              ' تاكيد كلمة المرور الجديدة',
              style: TextStyle(color: Color(0xff111111), fontSize: 14),
              textAlign: TextAlign.right,
            ),
          ),
          SizedBox(
            height: 2,
          ),
          Container(
            margin: EdgeInsets.only(right: 17, left: 20, top: 5),
            height: 40,
            decoration: BoxDecoration(
                color: Color(0xffF8F8F8),
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0, top: 5),
              child: TextField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: IconButton(
                        icon: Icon(
                          Icons.remove_red_eye,
                          size: 20,
                          color: Colors.black26,
                        ),
                        onPressed: () {
                          print('hide');
                        }),
                    hintText: ' تاكيد كلمة المرور الجديدة',
                    hintStyle: TextStyle(fontSize: 12)),
                textAlign: TextAlign.right,
                keyboardType: TextInputType.phone,
                style: TextStyle(
                  color: Color(0xff111111),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Stack(
            children: <Widget>[
              Image.asset('images/bottom_town.png'),
              Container(
                margin: EdgeInsets.only(left: 20, right: 17, top: 5, bottom: 5),
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xff34C961),
                ),
                child: Center(
                  child: Text(
                    'إرسال',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
