import 'package:flutter/material.dart';
import '../services/ScreenAdapter.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
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
          Column(
            children: [
              ListTile(
                title: Text('女装'),
              ),
              Divider(),
              ListTile(
                title: Text('男装'),
              ),
              Divider(),
              ListTile(
                title: Text('鞋子'),
              ),
              Divider(),
              ListTile(
                title: Text('手机'),
              ),
              Divider(),
              ListTile(
                title: Text('提包'),
              ),
              SizedBox(
                height: 100,
              ),
              InkWell(
                onTap: () {},
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
          )
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
        children: [Text('搜索')],
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
