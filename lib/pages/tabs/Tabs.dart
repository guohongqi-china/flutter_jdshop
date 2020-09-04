import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Home.dart';
import 'Category.dart';
import 'User.dart';
import 'Cart.dart';

class TabsPage extends StatefulWidget {
  @override
  _TabsPageState createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  var currentIndex = 1;

  var _pageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController(initialPage: this.currentIndex);
  }

  final List<Widget> bodyList = [
    HomePage(),
    Category(),
    CartPage(),
    UserPage()
  ];

  final List<BottomNavigationBarItem> bottomItems = [
    BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("首页")),
    BottomNavigationBarItem(icon: Icon(Icons.category), title: Text("分类")),
    BottomNavigationBarItem(
        icon: Icon(Icons.shopping_cart), title: Text("购物车")),
    BottomNavigationBarItem(icon: Icon(Icons.people), title: Text("我的")),
  ];

  _tapIndex(index) {
    setState(() {
      this.currentIndex = index;
      this._pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget bottomNavBar = BottomNavigationBar(
      type: BottomNavigationBarType.fixed, //配置底部tabs可以有多个按钮
      items: bottomItems,
      onTap: _tapIndex,
      fixedColor: Colors.orange, //选中的颜色
      iconSize: 20.0, // 按钮图标大小尺寸调整
      currentIndex: currentIndex,
    );

    // 保持页面状态
    Widget body = IndexedStack(
      index: this.currentIndex,
      children: bodyList,
    );

    Widget pageView = PageView(
      controller: this._pageController,
      children: bodyList,
      onPageChanged: (index) {
        // 监听页面改动
        setState(() {
          this.currentIndex = index;
        });
        print('当前改变页面下标=====$index');
      },
      physics: NeverScrollableScrollPhysics(), //进制pageView滑动
    );

    return Scaffold(
      body: pageView,
      bottomNavigationBar: bottomNavBar,
    );
  }
}
