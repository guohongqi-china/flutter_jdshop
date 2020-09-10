import 'package:flutter/material.dart';
import '../services/ScreenAdapter.dart';
import '../services/SearchServices.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var _keywords;
  List _historyListData = [];

  @override
  initState() {
    super.initState();
    _getHistoryData();
  }

  Future _getHistoryData() async {
    var list = await SearchServices.getHistoryList();

    setState(() {
      this._historyListData = list == null ? [] : list;
    });
    return list;
  }

  _showAlertDialog(keywords) {
    var result = showDialog(
        barrierDismissible: false, // 点击灰色背景时是否消失弹出框
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("提示信息"),
            content: Text('你确定要删除吗'),
            actions: [
              FlatButton(
                child: Text("取消"),
                onPressed: () {
                  print("取消");
                  Navigator.pop(context, 'Cancle');
                },
              ),
              FlatButton(
                child: Text("确定"),
                onPressed: () async {
                  //注意异步
                  SearchServices.removeHistoryByKey(keywords).then((value) {
                    return _getHistoryData();
                  }).then((value) => Navigator.pop(context, "Ok"));
                },
              )
            ],
          );
        });
  }

  Widget _historyListWidget() {
    _historyList() {
      this._historyListData.map((e) {
        return Column(
          children: [
            Column(
              children: [
                ListTile(
                  title: Text('3333333'),
                ),
                Divider(),
              ],
            )
          ],
        );
      });
      return this._historyListData.toList();
    }

    if (this._historyListData.length > 0) {
      print(this._historyListData);
      return Column(
        children: [
          Column(
            children: this._historyListData.map((e) {
              return Column(
                children: [
                  ListTile(
                    title: Text("$e"),
                    onLongPress: () {
                      _showAlertDialog(e);
                    },
                  ),
                  Divider()
                ],
              );
            }).toList(),
          ),
          SizedBox(
            height: 100,
          ),
          InkWell(
            onTap: () async {
              SearchServices.removeHistoryList().then((value) {
                return _getHistoryData();
              });
              // Future.value().then((value) {
              //   return SearchServices.removeHistoryList();
              // }).then((value) {
              //   print('回调list$value');
              //   return _getHistoryData();
              // });
            },
            child: Container(
              width: ScreenAdapter.getScreenWidth() * 0.66,
              height: ScreenAdapter.height(64),
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 1, color: Color.fromRGBO(150, 150, 150, 0.9))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.delete,
                    size: 20,
                  ),
                  Text('清空历史记录')
                ],
              ),
            ),
          )
        ],
      );
    } else {
      return Text('');
    }
  }

  // 热搜关键词
  Widget _bodySearch() {
    List<Widget> items() {
      List arr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
      List<Widget> result = arr.map((e) {
        return Container(
          padding: EdgeInsets.fromLTRB(14, 4, 14, 4),
          margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color.fromRGBO(233, 233, 233, 0.9)),
          child: Text(
            '女装',
            style: TextStyle(fontSize: 14),
          ),
        );
      }).toList();
      return result;
    }

    return Container(
      padding: EdgeInsets.all(10),
      child: ListView(
        children: [
          Container(
              child: Text(
            '热搜',
            style: TextStyle(
              fontSize: 16,
            ),
          )),
          Divider(),
          Wrap(
            children: items(),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
              child: Text(
            '历史搜索',
            style: TextStyle(
              fontSize: 16,
            ),
          )),
          Divider(),
          _historyListWidget()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 导航搜索按钮
    Widget searchBtn = Container(
      height: ScreenAdapter.height(68),
      width: ScreenAdapter.width(80),
      child: Row(
        children: [
          InkWell(
            child: Text('搜索'),
            onTap: () async {
              // SharedPreferences prefs = await SharedPreferences.getInstance();
              // List result = prefs.getStringList('searchList');
              // print('=============99$result');

              // if (result == null) {
              //   List<String> temList = List();
              //   temList.add('${this._keywords}');
              //   await prefs.setStringList('searchList', temList);
              //   List list = prefs.getStringList('searchList');
              //   print('77777777=====${list}');
              // } else {
              //   prefs.clear();
              //   print('9999999999');
              // }

              SearchServices.setHistoryList(this._keywords);
              Navigator.pushReplacementNamed(context, '/productlist',
                  arguments: {"keywords": this._keywords});
            },
          )
        ],
      ),
    );
    // 导航搜索输入框
    Widget headSearch = Container(
      padding: EdgeInsets.only(bottom: ScreenAdapter.height(5)),
      height: ScreenAdapter.height(50),
      decoration: BoxDecoration(
          color: Color.fromRGBO(233, 233, 233, 0.8),
          borderRadius: BorderRadius.circular(ScreenAdapter.height(68) / 2)),
      child: TextField(
        textAlignVertical: TextAlignVertical.bottom,
        autofocus: true,
        decoration: InputDecoration(
            hintText: '请输入搜索内容',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ScreenAdapter.height(68) / 2),
              borderSide: BorderSide.none,
            )),
        onChanged: (value) {
          this._keywords = value;
        },
      ),
    );
    // 内容
    Widget body = _bodySearch();
    return Scaffold(
      appBar: AppBar(
        title: headSearch,
        actions: [searchBtn],
      ),
      body: body,
    );
  }
}
