import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  _loacalStoray() async {
    // final SharedPreferences prefs = await _prefs;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('666', ['1111']);

    print('====00000=+++++');

    List result = prefs.getStringList('666');
    print('======本地取值结果$result');
  }

  _getLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String result = prefs.getString('key222');
    print('======本地取值结果$result');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('用户'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          RaisedButton(
            onPressed: _loacalStoray,
            child: Text('存储数据'),
          ),
          RaisedButton(
            onPressed: _getLocalData,
            child: Text('获取数据'),
          ),
        ],
      ),
    );
  }
}
