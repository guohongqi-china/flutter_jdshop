import 'package:flutter/material.dart';
import 'ProductContentFirst.dart';
import 'ProductContentSecond.dart';
import 'ProductContentThree.dart';
import '../services/ScreenAdapter.dart';
import '../Widget/CustomizeButton.dart';
import 'package:dio/dio.dart';
import '../config/Config.dart';
import '../model/ProductContent.dart';
import '../Widget/LoadingWidget.dart';
import '../services/EventBus.dart';
import '../provider/Cart.dart';
import 'package:provider/provider.dart';

class ProductContentPage extends StatefulWidget {
  final Map arguments;
  ProductContentPage({Key key, this.arguments});
  @override
  _ProductContentPageState createState() => _ProductContentPageState();
}

class _ProductContentPageState extends State<ProductContentPage> {
  //
  ProductContentItem _productContentData;
  List<ProductContentItem> _productContentList = [];

  @override
  initState() {
    super.initState();
    _getContentData();
  }
  // ===============================data==================================

  _getContentData() async {
    var api = Config.productcontentApi + "${widget.arguments['id']}";
    var result = await Dio().get(api);
    var productList = ProductContentModel.fromJson(result.data);
    setState(() {
      this._productContentList.add(productList.result);
    });
  }

  // ===============================Actions==================================

  // 导航右侧按钮事件
  _menuTapAction() {
    AlertMenu.showToastMenu(context);
  }

  // ===============================Widget==================================

  // 底部筛选
  Widget _bottomSelect() {
    return Row(
      children: [
        Container(
            width: ScreenAdapter.width(200),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/cart',
                    arguments: {'isTrue': true});
              },
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: Column(
                  children: [
                    Icon(
                      Icons.shopping_cart,
                      size: 20,
                    ),
                    Text(
                      '购物车',
                      style: TextStyle(fontSize: 10),
                    )
                  ],
                ),
              ),
            )),
        Expanded(
            flex: 1,
            child: CustomizeButton(
              bgColor: Colors.red,
              text: "加入购物车",
              callback: () {
                // 广播
                // eventBus.fire(ProductContentEvent('加入购物车'));
                eventBus.fire(ProductContentEvent("myUser"));
              },
            )),
        Expanded(
            flex: 1,
            child: CustomizeButton(
              bgColor: Colors.orange,
              text: "立即购买",
              callback: () {
                print('====');
              },
            )),
      ],
    );
  }

  // ===============================build==================================
  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    // 底部 悬浮
    Widget bottomToast = Container(
      padding: EdgeInsets.only(bottom: ScreenAdapter.bottomSafeHeight),
      child: _bottomSelect(),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              top: BorderSide(
                  color: Color.fromRGBO(200, 200, 200, 1), width: 1))),
    );
    // 顶部导航
    Widget tabbar = Container(
      width: ScreenAdapter.width(400),
      child: TabBar(
          indicatorColor: Colors.orange,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: <Widget>[
            Tab(
              child: Text('商品'),
            ),
            Tab(
              child: Text('详情'),
            ),
            Tab(
              child: Text('评价'),
            ),
          ]),
    );
    //loading
    Widget loading = LoadingWidget();
    // 底部内容
    Widget tabbarview = Stack(
      children: [
        TabBarView(physics: NeverScrollableScrollPhysics(), //禁止滑动
            children: <Widget>[
              ProductContentFirstPage(this._productContentList),
              ProductContentSecondPage(
                productContentList: this._productContentList,
              ),
              ProductContentThreePage(),
            ]),
        Positioned(
            width: ScreenAdapter.width(750),
            height: ScreenAdapter.height(80) + ScreenAdapter.bottomSafeHeight,
            bottom: 0,
            child: bottomToast)
      ],
    );
    // 主体
    Widget scaffold = Scaffold(
      appBar: AppBar(
        title: tabbar,
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(Icons.more_horiz), onPressed: () => _menuTapAction())
        ],
      ),
      body: this._productContentList.length > 0 ? tabbarview : loading,
    );
    // 内容
    Widget content = DefaultTabController(length: 3, child: scaffold);
    return content;
  }
}

class AlertMenu {
  static showToastMenu(context) {
    showMenu(
        context: context,
        position: RelativeRect.fromLTRB(ScreenAdapter.width(600), 100, 10, 0),
        items: [
          PopupMenuItem(
              child: Row(
            children: <Widget>[
              Icon(Icons.home),
              Container(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Text("首页"),
              )
            ],
          )),
          PopupMenuItem(
              child: Row(
            children: <Widget>[
              Icon(Icons.search),
              Container(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Text("搜索"),
              )
            ],
          )),
        ]);
  }

  static showCustomizeMeun(context) {
    showMenu(
        context: context,
        position: RelativeRect.fromLTRB(ScreenAdapter.width(600), 100, 10, 0),
        items: []);
  }
}
