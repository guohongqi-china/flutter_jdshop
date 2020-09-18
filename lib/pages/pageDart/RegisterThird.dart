import 'package:flutter/material.dart';
import '../services/ScreenAdapter.dart';
import '../Widget/jdText.dart';
import '../Widget/CustomizeButton.dart';

class RegisterThird extends StatefulWidget {
  @override
  _RegisterThirdState createState() => _RegisterThirdState();
}

class _RegisterThirdState extends State<RegisterThird> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('用户注册-第三步'),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        color: Color.fromRGBO(248, 248, 248, 1),
        child: ListView(
          children: [
            SizedBox(
              height: 20,
            ),
            Text('请设置登录密码'),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.only(right: 20),
              height: ScreenAdapter.height(80),
              child: TextField(
                textAlignVertical: TextAlignVertical.bottom,
                decoration: InputDecoration(
                    hintText: "请设置6-20位字符",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    )),
              ),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      width: 1, color: Color.fromRGBO(220, 220, 220, 1))),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: Container(
                      color: Colors.red,
                      height: 20,
                      width: 20,
                      child: Checkbox(
                        tristate: true,
                        value: true,
                        activeColor: Colors.red,
                        onChanged: (value) {},
                      ),
                    )),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "密码可见",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text('密码由6-20位字母、数字或半角符号组成，不能是10位一下纯数字/字母/半角符号，字母需区分大小写'),
            SizedBox(
              height: 20,
            ),
            Container(
              height: ScreenAdapter.height(80),
              child: CustomizeButton(
                callback: () {
                  Navigator.pushNamed(context, '/registerThird');
                },
                text: "完成",
                bgColor: Colors.red,
                margin: EdgeInsets.all(0),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(children: [
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
            ])
          ],
        ),
      ),
    );
  }
}
