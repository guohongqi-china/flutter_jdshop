import 'package:flutter/material.dart';
import '../services/ScreenAdapter.dart';
import '../Widget/jdText.dart';
import '../Widget/CustomizeButton.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // =============================== Widget ===============================================
  // =============================== Widget ===============================================

  // =============================== Build ================================================
  @override
  Widget build(BuildContext context) {
    Widget body = ListView(
      padding: EdgeInsets.all(10),
      children: [
        Center(
          child: Container(
            margin: EdgeInsets.only(top: 30),
            height: ScreenAdapter.width(160),
            width: ScreenAdapter.width(160),
            child: Image.asset(
              'images/login.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        JdText(
          holderText: "用户名/手机号",
          onChangeValue: (value) {},
        ),
        JdText(
          holderText: "请输入密码",
          onChangeValue: (value) {},
          isSecure: true,
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FlatButton(
              onPressed: () {},
              child: Text('忘记密码'),
            ),
            FlatButton(
              onPressed: () {
                Navigator.pushNamed(context, "/registerFirst");
              },
              child: Text('新用户注册'),
            )
          ],
        ),
        SizedBox(
          height: 50,
        ),
        Container(
          height: ScreenAdapter.height(120),
          child: CustomizeButton(
            callback: () {},
            text: "登录",
            bgColor: Colors.red,
          ),
        )
      ],
    );
    Widget appBar = AppBar(
      backgroundColor: Colors.white,
      shadowColor: Colors.white,
      leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.black45,
          ),
          onPressed: () {
            Navigator.pop(context);
          }),
      actions: [FlatButton(onPressed: () {}, child: Text('客服'))],
    );
    Widget content = Scaffold(
      appBar: appBar,
      body: body,
    );
    return content;
  }
}
