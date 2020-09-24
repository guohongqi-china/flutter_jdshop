import 'dart:async';
import 'dart:convert';
import "package:flutter/material.dart";
import 'package:flutter_jdshop/pages/services/CartServices.dart';
import 'package:provider/provider.dart';
import '../services/ScreenAdapter.dart';
import '../provider/CheckOut.dart';
import '../config/Config.dart';
import 'package:dio/dio.dart';
import '../services/UserService.dart';
import '../services/SignService.dart';
import '../services/EventBus.dart';
import '../provider/Cart.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CheckOutPage extends StatefulWidget {
  @override
  _CheckOutPageState createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  double _headHeight;
  var checkOutProvider;
  var _totalPrice;
  List _defaultAddress = [];
  StreamSubscription actionEventBus;
  var cart;

  //===========================Methods==============================
  initState() {
    super.initState();
    _headHeight = ScreenAdapter.height(80);
    _getTotalPrice();
    _getDefaultAddress();
    actionEventBus = eventBus.on<UpdateAddressEvent>().listen((event) {
      _getDefaultAddress();
    });
  }

  dispose() {
    super.dispose();
    this.actionEventBus.cancel();
  }

  _getTotalPrice() async {
    var totalPrice = await CartServices.comptureTotalPrice();
    setState(() {
      this._totalPrice = totalPrice;
    });
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

  _getDefaultAddress() async {
    var userinfo = await UserServices.getUserInfo();

    var temJson = {'uid': userinfo[0]['_id'], 'salt': userinfo[0]['salt']};
    var sign = SignServices.getSign(temJson);

    var api =
        Config.getDefaultAddress + "?uid=${userinfo[0]['_id']}&sign=$sign";
    var response = await Dio().get(api);
    setState(() {
      this._defaultAddress = response.data['result'];
    });
    print(response.data);
  }

  //===========================Widget==============================
  List<Widget> _listWidget() {
    List<Widget> list = [
      Container(
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.add_location),
              title: Center(
                child: Text('请添加收货地址'),
              ),
              trailing: Icon(Icons.navigate_next),
            )
          ],
        ),
      ),
      SizedBox(
        height: 20,
      ),
      Container(
        child: Column(
          children: [],
        ),
      )
    ];
    return list;
  }

  // 头
  Widget _pageHeadWidget() {
    if (this._defaultAddress.length > 0) {
      Widget widgetState = Positioned(
        top: 0,
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, "/addressList");
          },
          child: Container(
            height: this._headHeight,
            width: ScreenAdapter.getScreenWidth(),
            color: Colors.white,
            child: ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${this._defaultAddress[0]['name']}  ${this._defaultAddress[0]['phone']}',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text('${this._defaultAddress[0]['address']}',
                      style: TextStyle(fontSize: 13))
                ],
              ),
              trailing: Icon(Icons.navigate_next),
            ),
          ),
        ),
      );
      return widgetState;
    } else {
      Widget widget = Positioned(
        top: 0,
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, "/addressAdd");
          },
          child: Container(
            height: this._headHeight,
            width: ScreenAdapter.getScreenWidth(),
            color: Colors.white,
            child: ListTile(
              leading: Icon(Icons.add_location),
              title: Center(
                child: Text('请添加收货地址'),
              ),
              trailing: Icon(Icons.navigate_next),
            ),
          ),
        ),
      );
      return widget;
    }
  }

  Widget _contentItem(value) {
    Widget content = Container(
      color: Colors.white,
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
            width: ScreenAdapter.width(150),
            child: Image.network("${value['pic']}", fit: BoxFit.cover),
          ),
          Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.fromLTRB(0, 6, 10, 0),
                height: ScreenAdapter.width(150),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${value['title']}",
                      style: TextStyle(color: Colors.black87),
                    ),
                    Text("${value['selectedAttr']}"),
                    Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("￥${value['price']}",
                              style: TextStyle(color: Colors.red)),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text("x${value['count']}"),
                        )
                      ],
                    ),
                  ],
                ),
              ))
        ],
      ),
    );

    return content;
  }

  List<Widget> _conteList() {
    List temp = checkOutProvider.checkOutListData;
    return temp.map((value) {
      return _contentItem(value);
    }).toList();
  }

  Widget _contentBodyWidget() {
    Widget content = Container(
      margin: EdgeInsets.fromLTRB(0, _headHeight + 10, 0,
          ScreenAdapter.bottomSafeHeight + ScreenAdapter.height(80)),
      color: Colors.white,
      child: ListView(
        children: [
          Column(children: _conteList()),
          SizedBox(
            height: 10,
          ),
          Container(
            color: Color.fromRGBO(250, 250, 250, 1),
            height: 20,
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            alignment: Alignment.bottomLeft,
            child: Column(
              children: [
                Text('商品总金额'),
                SizedBox(
                  height: 30,
                ),
                Text('立减:￥8元'),
                SizedBox(
                  height: 30,
                ),
                Text('运费:￥8元')
              ],
            ),
          )
        ],
      ),
    );
    return content;
  }

  Widget _bottomBarWidget() {
    Widget bottomBar = Positioned(
        bottom: 0,
        height: ScreenAdapter.bottomSafeHeight + ScreenAdapter.height(80),
        child: Container(
            padding: EdgeInsets.only(bottom: ScreenAdapter.bottomSafeHeight),
            width: ScreenAdapter.getScreenWidth(),
            height: ScreenAdapter.height(80),
            decoration: BoxDecoration(
                color: Colors.white,
                border:
                    Border(top: BorderSide(color: Colors.black38, width: 1))),
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Text('实付款: '),
                        Text(
                          "$_totalPrice",
                          style: TextStyle(color: Colors.red),
                        )
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () async {
                        if (this._defaultAddress.length == 0) {
                          _toastText('默认收货地址为空');
                          return;
                        }
                        List userinfo = await UserServices.getUserInfo();
                        var allPrice = this._totalPrice;
                        var sign = SignServices.getSign({
                          'uid': userinfo[0]['_id'],
                          'phone': this._defaultAddress[0]['phone'],
                          'address': this._defaultAddress[0]['address'],
                          'name': this._defaultAddress[0]['name'],
                          'all_price': allPrice,
                          'products':
                              json.encode(checkOutProvider.checkOutListData),
                          'salt': userinfo[0]['salt']
                        });

                        // 请求接口
                        var response =
                            await Dio().post(Config.confirmOrder, data: {
                          'uid': userinfo[0]['_id'],
                          'phone': this._defaultAddress[0]['phone'],
                          'address': this._defaultAddress[0]['address'],
                          'name': this._defaultAddress[0]['name'],
                          'all_price': allPrice,
                          'products':
                              json.encode(checkOutProvider.checkOutListData),
                          'sign': sign
                        });
                        print(response.data);
                        if (response.data['success']) {
                          // 删除购物车选中的商品数据
                          await CartServices.delectSelectCartData();
                          await this.cart.updateCartList();
                          // 提交订单成功，跳转支付页面
                          Navigator.pushNamed(context, '/pay');
                        } else {}
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                        child: Text(
                          '立即下单',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(4)),
                      ),
                    ),
                  )
                ],
              ),
            )));
    return bottomBar;
  }

  //===========================builder==============================
  @override
  Widget build(BuildContext context) {
    cart = Provider.of<Cart>(context);
    checkOutProvider = Provider.of<CheckOut>(context);
    Widget body = Container(
      color: Color.fromRGBO(250, 250, 250, 1),
      child: Stack(
        children: [_pageHeadWidget(), _contentBodyWidget(), _bottomBarWidget()],
      ),
    );
    Widget appBar = AppBar(
      title: Text('订单页面'),
    );
    Widget content = Scaffold(
      appBar: appBar,
      body: body,
    );
    return content;
  }
}
