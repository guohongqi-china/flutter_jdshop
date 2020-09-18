import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../provider/Counter.dart';
import '../services/ScreenAdapter.dart';

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

  // ==================================  widget  =================================================

  List<Widget> _contentBody() {
    List<Widget> list = [
      Container(
        height: ScreenAdapter.height(220),
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/user_bg.jpg"), fit: BoxFit.cover)),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ClipOval(
                child: Image.asset(
                  'images/user.png',
                  fit: BoxFit.cover,
                  width: ScreenAdapter.width(100),
                  height: ScreenAdapter.width(100),
                ),
              ),
            ),
            Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: Text(
                    '登录/注册',
                    style: TextStyle(color: Colors.white),
                  ),
                )),
            // Expanded(
            //     flex: 1,
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text(
            //           '用户名：22222222',
            //           style: TextStyle(
            //               color: Colors.white,
            //               fontSize: ScreenAdapter.fontSize(32)),
            //         ),
            //         Text('普通会员',
            //             style: TextStyle(
            //                 color: Colors.white,
            //                 fontSize: ScreenAdapter.fontSize(24))
            //         )
            //       ],
            //     )
            //   )
          ],
        ),
      ),
      ListTile(
        leading: Icon(Icons.assignment, color: Colors.red),
        title: Text("全部订单"),
      ),
      Divider(),
      ListTile(
        leading: Icon(Icons.payment, color: Colors.green),
        title: Text("待付款"),
      ),
      Divider(),
      ListTile(
        leading: Icon(Icons.local_car_wash, color: Colors.orange),
        title: Text("待收货"),
      ),
      Container(
          width: double.infinity,
          height: 10,
          color: Color.fromRGBO(242, 242, 242, 0.9)),
      ListTile(
        leading: Icon(Icons.favorite, color: Colors.lightGreen),
        title: Text("我的收藏"),
      ),
      Divider(),
      ListTile(
        leading: Icon(Icons.people, color: Colors.black54),
        title: Text("在线客服"),
      ),
      Divider(),
    ];
    return list;
  }

  // ==================================  build  =================================================
  @override
  Widget build(BuildContext context) {
    var counterProvider = Provider.of<Counter>(context);

    // 主体内容
    Widget body = ListView(
      children: _contentBody(),
    );
    // 导航栏
    Widget navBar = AppBar(
      title: Text('用户'),
      centerTitle: true,
    );
    // 内容
    Widget contentWidget = Scaffold(appBar: navBar, body: body);
    return contentWidget;
  }
}
