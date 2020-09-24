import 'package:flutter/material.dart';
import '../services/ScreenAdapter.dart';
import '../Widget/jdText.dart';
import '../Widget/CustomizeButton.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../config/Config.dart';
import 'package:dio/dio.dart';
import '../services/Storage.dart';
import 'dart:convert';
import '../services/EventBus.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String userName = '';
  String passWord = '';
  // =============================== Action ===============================================
  // 登录
  _doLogin() async {
    RegExp reg = RegExp(r"^1\d{10}$");
    bool result = reg.hasMatch(this.userName);
    print('结果$result');
    if (!result) {
      _toastText("手机号输入有误");
    } else if (passWord.length < 6) {
      _toastText("密码长度不能小于6位");
    } else {
      var api = Config.loginApi;
      var result = await Dio().post(api,
          data: {'username': this.userName, "password": this.passWord});
      print(result.data);
      if (result.data["success"]) {
        // 保存用户信息
        await Storage.setString(
            'userInfo', json.encode(result.data['userinfo']));
        Navigator.pop(context);
      } else {
        _toastText(result.data["message"]);
      }
    }
  }

  // 监听登录页面销毁事件
  dispose() {
    super.dispose();
    eventBus.fire(UserEvent('登录成功'));
  }

  // 提示
  _toastText(content) {
    Fluttertoast.showToast(
        msg: content,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 16.0);
  }
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
          onChangeValue: (value) {
            this.userName = value;
          },
        ),
        JdText(
          holderText: "请输入密码",
          onChangeValue: (value) {
            this.passWord = value;
          },
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
            callback: _doLogin,
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
