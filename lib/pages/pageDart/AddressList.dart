import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_jdshop/pages/services/SignService.dart';
import '../services/ScreenAdapter.dart';
import '../config/Config.dart';
import 'package:dio/dio.dart';
import '../services/UserService.dart';
import '../services/EventBus.dart';

class AddressListPage extends StatefulWidget {
  @override
  _AddressListPageState createState() => _AddressListPageState();
}

class _AddressListPageState extends State<AddressListPage> {
  List addressList = [];

  StreamSubscription actionEventBus;

  // Mark - Methods
  initState() {
    super.initState();
    _getAddressList();

    actionEventBus = eventBus.on<UpdateAddressEvent>().listen((event) {
      _getAddressList();
    });
  }

  dispose() {
    super.dispose();
    this.actionEventBus.cancel();
  }

  _getAddressList() async {
    // 请求接口
    List userinfo = await UserServices.getUserInfo();

    var temJson = {'uid': userinfo[0]['_id'], 'salt': userinfo[0]['salt']};

    var sign = SignServices.getSign(temJson);

    var api = Config.addAddressList + "?uid=${userinfo[0]['_id']}&sign=$sign";
    var result = await Dio().get(api);

    setState(() {
      this.addressList = result.data['result'];
    });
  }

  _changeDefaultAddress(id) async {
    // 请求接口
    List userinfo = await UserServices.getUserInfo();

    var temJson = {
      'uid': userinfo[0]['_id'],
      'salt': userinfo[0]['salt'],
      'id': id
    };

    var sign = SignServices.getSign(temJson);

    var response = await Dio().post(Config.changeDefaultAddress,
        data: {'uid': userinfo[0]['_id'], 'sign': sign, 'id': id});

    if (response.data['success']) {
      eventBus.fire(UpdateAddressEvent("myUser"));
      Navigator.pop(context);
    }
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
                  Navigator.pop(context, 'Cancle');
                },
              ),
              FlatButton(
                child: Text("确定"),
                onPressed: () {
                  Navigator.pop(context, 'Ok');

                  _deleteAddress(keywords);
                },
              )
            ],
          );
        });
  }

  _deleteAddress(id) async {
    // 请求接口
    List userinfo = await UserServices.getUserInfo();

    var temJson = {
      'uid': userinfo[0]['_id'],
      'salt': userinfo[0]['salt'],
      'id': id
    };

    var sign = SignServices.getSign(temJson);

    var response = await Dio().post(Config.deleteAddress,
        data: {'uid': userinfo[0]['_id'], 'sign': sign, 'id': id});

    _getAddressList();
  }

  // Mark - Widget
  _bottomAddWidget() {
    return Positioned(
        bottom: 0,
        height: ScreenAdapter.bottomSafeHeight + ScreenAdapter.height(100),
        width: ScreenAdapter.getScreenWidth(),
        child: Container(
          height: ScreenAdapter.height(100),
          padding: EdgeInsets.only(bottom: ScreenAdapter.bottomSafeHeight),
          color: Colors.white,
          alignment: Alignment.center,
          child: Container(
              color: Colors.red,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
              height: ScreenAdapter.height(60),
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/addressAdd');
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    Text(
                      '新增收货地址',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              )),
        ));
  }

  _contentWidget() {
    Widget addressList = ListView.builder(
        itemCount: this.addressList.length,
        // ignore: missing_return
        itemBuilder: (context, index) {
          return Column(
            children: [
              this.addressList[index]['default_address'] == 1
                  ? ListTile(
                      leading: Icon(Icons.check, color: Colors.red),
                      title: InkWell(
                        onTap: () async {
                          await _changeDefaultAddress(
                              this.addressList[index]['_id']);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${this.addressList[index]['name']}  ${this.addressList[index]['phone']}',
                              style: TextStyle(fontSize: 14),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Text('${this.addressList[index]['address']}',
                                style: TextStyle(fontSize: 13))
                          ],
                        ),
                      ),
                      trailing: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/addressEdit',
                              arguments: {
                                'id': this.addressList[index]['_id'],
                                'name': this.addressList[index]['name'],
                                'phone': this.addressList[index]['phone'],
                                'address': this.addressList[index]['address'],
                              });
                        },
                        child: Icon(
                          Icons.edit,
                          color: Colors.blue,
                        ),
                      ))
                  : ListTile(
                      title: InkWell(
                        onTap: () async {
                          await _changeDefaultAddress(
                              this.addressList[index]['_id']);
                        },
                        onLongPress: () {
                          _showAlertDialog(this.addressList[index]['_id']);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${this.addressList[index]['name']}  ${this.addressList[index]['phone']}',
                              style: TextStyle(fontSize: 14),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Text('${this.addressList[index]['address']}',
                                style: TextStyle(fontSize: 13))
                          ],
                        ),
                      ),
                      trailing: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/addressEdit',
                              arguments: {
                                'id': this.addressList[index]['_id'],
                                'name': this.addressList[index]['name'],
                                'phone': this.addressList[index]['phone'],
                                'address': this.addressList[index]['address'],
                              });
                        },
                        child: Icon(
                          Icons.edit,
                          color: Colors.blue,
                        ),
                      )),
              Divider(
                height: 20,
              ),
            ],
          );
        });

    return addressList;
  }

  // Mark - builder
  @override
  Widget build(BuildContext context) {
    Widget body = Stack(
      children: [
        _contentWidget(),
        _bottomAddWidget(),
      ],
    );
    Widget navBar = AppBar(
      title: Text('地址列表'),
    );
    Widget content = Scaffold(
      appBar: navBar,
      body: body,
    );
    return content;
  }
}
