import 'package:flutter/material.dart';
import '../services/ScreenAdapter.dart';
import '../Widget/jdText.dart';
import '../Widget/CustomizeButton.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../config/Config.dart';
import 'package:dio/dio.dart';

class RegisterFirst extends StatefulWidget {
  @override
  _RegisterFirstState createState() => _RegisterFirstState();
}

class _RegisterFirstState extends State<RegisterFirst> {
  String tel = "";

  _sendCode() async {
    RegExp reg = RegExp(r"^1\d{10}$");
    bool result = reg.hasMatch(this.tel);
    print('结果$result');
    if (!result) {
      _toastText("手机号输入有误");
    } else {
      var api = Config.sendCodeApi;
      var result = await Dio().post(api, data: {'tel': this.tel});
      print(result.data);
      if (result.data["success"]) {
        Navigator.pushNamed(context, '/registerSecond',
            arguments: {'tel': this.tel});
      } else {
        _toastText(result.data["message"]);
      }
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('用户注册-第一步'),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: [
            JdText(
              holderText: "请输入手机号",
              onChangeValue: (value) {
                this.tel = value;
              },
            ),
            Container(
              height: ScreenAdapter.height(120),
              child: CustomizeButton(
                callback: _sendCode,
                text: "下一步",
                bgColor: Colors.red,
              ),
            )
          ],
        ),
      ),
    );
  }
}
