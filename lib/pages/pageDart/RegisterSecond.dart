import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/ScreenAdapter.dart';
import '../Widget/CustomizeButton.dart';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import '../config/Config.dart';
import 'package:dio/dio.dart';

class RegisterSecond extends StatefulWidget {
  Map arguments;
  RegisterSecond({Key key, this.arguments}) : super(key: key);
  @override
  _RegisterSecondState createState() => _RegisterSecondState();
}

class _RegisterSecondState extends State<RegisterSecond> {
  String _tel;
  bool _sendCodeBtn = false;
  int _seconds = 60;
  Timer timerss;
  String _code;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._tel = widget.arguments["tel"];
    this._showTime();
  }

  dispose() {
    super.dispose();
    timerss.cancel();
  }

  _showTime() {
    timerss = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      setState(() {
        this._seconds--;
      });
      if (this._seconds == 0) {
        timer.cancel(); // 清除定时器
        this._seconds = 60;
        setState(() {
          this._sendCodeBtn = true;
        });
      }
    });
  }

  _tapTimeAction() {
    if (this._sendCodeBtn) {
      this._sendCodeBtn = false;
      this._sendCode();
    }
  }

  _sendCode() async {
    RegExp reg = RegExp(r"^1\d{10}$");
    bool result = reg.hasMatch(this._tel);
    if (!result) {
      _toastText("手机号输入有误");
    } else {
      var api = Config.sendCodeApi;
      var result = await Dio().post(api, data: {'tel': this._tel});
      print(result.data);
      if (result.data["success"]) {
        this._showTime();
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

  // 验证
  _validateCode() async {
    var result = await Dio().post(Config.validateCodeAPi,
        data: {"tel": this._tel, "code": this._code});
    if (result.data["success"]) {
      Navigator.pushNamed(context, '/registerThird',
          arguments: {"tel": this._tel, "code": this._code});
    } else {
      _toastText(result.data["message"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('用户注册-第二步'),
      ),
      body: Container(
        color: Color.fromRGBO(248, 248, 248, 1),
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.only(top: 30),
              child: Text("请输入${this._tel}手机号收到的验证码"),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                    flex: 2,
                    child: Container(
                      margin: EdgeInsets.only(right: 20),
                      height: ScreenAdapter.height(80),
                      child: TextField(
                        textAlignVertical: TextAlignVertical.bottom,
                        onChanged: (value) {
                          this._code = value;
                        },
                        decoration: InputDecoration(
                            hintText: "请输入验证码",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            )),
                      ),
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1,
                              color: Color.fromRGBO(220, 220, 220, 1))),
                    )),
                Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: _tapTimeAction,
                      child: Container(
                        height: ScreenAdapter.height(80),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(237, 237, 237, 1)),
                        child: this._sendCodeBtn
                            ? Text('重新发送')
                            : Text('${this._seconds}s后重发'),
                      ),
                    ))
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: ScreenAdapter.height(80),
              child: CustomizeButton(
                // callback: () {
                //   Navigator.pushNamed(context, '/registerThird');
                // },
                callback: _validateCode,
                text: "下一步",
                bgColor: Colors.red,
                margin: EdgeInsets.all(0),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text('遇到问题？你可以 '),
                InkWell(
                  child: Text(
                    '联系客服',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.black),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
