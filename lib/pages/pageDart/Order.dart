import 'package:flutter/material.dart';
import '../services/ScreenAdapter.dart';
import '../config/Config.dart';
import 'package:dio/dio.dart';
import '../services/UserService.dart';
import '../services/SignService.dart';
import '../model/OrderModel.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  var _orderList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getOrderListData();
  }

  _getOrderListData() async {
    List userinfo = await UserServices.getUserInfo();
    var tempjson = {'uid': userinfo[0]['_id'], 'salt': userinfo[0]['salt']};

    var sign = SignServices.getSign(tempjson);
    var api = Config.orderList + "?uid=${userinfo[0]['_id']}&sign=$sign";
    print(api);

    var response = await Dio().get(api);
    setState(() {
      this._orderList = OrderData.fromJson(response.data).result;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _contentWidgetItem(temp) {
      List<Widget> tempList = [];
      for (var item in temp) {
        tempList.add(Column(
          children: [
            SizedBox(
              height: 10,
            ),
            ListTile(
              leading: Container(
                width: ScreenAdapter.width(80),
                height: ScreenAdapter.height(80),
                child: Image.network("${item.productImg}", fit: BoxFit.cover),
              ),
              title: Text("${item.productTitle}"),
              trailing: Text('x${item.productCount}'),
            )
          ],
        ));
      }
      return tempList;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('我的订单'),
      ),
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: ScreenAdapter.height(86)),
            child: ListView(
              children: this._orderList.map((value) {
                return Card(
                    child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/orderInfo');
                  },
                  child: Column(
                    children: [
                      ListTile(
                        title: Text('订单编号：${value.sId}',
                            style: TextStyle(color: Colors.black54)),
                      ),
                      Divider(
                        height: 10,
                      ),
                      Container(
                          child: Column(
                              children: _contentWidgetItem(value.orderItem))),
                      ListTile(
                        leading: Text('合计：￥${value.allPrice}'),
                        trailing: FlatButton(
                          onPressed: () {},
                          child: Text('申请售后'),
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                ));
              }).toList(),
            ),
          ),
          Positioned(
            top: 0,
            width: ScreenAdapter.getScreenWidth(),
            height: ScreenAdapter.height(76),
            child: Container(
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                    '全部',
                    textAlign: TextAlign.center,
                  )),
                  Expanded(
                      child: Text(
                    '待付款',
                    textAlign: TextAlign.center,
                  )),
                  Expanded(
                      child: Text(
                    '待收货',
                    textAlign: TextAlign.center,
                  )),
                  Expanded(
                      child: Text(
                    '已完成',
                    textAlign: TextAlign.center,
                  )),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
