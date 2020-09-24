import 'package:flutter/material.dart';
import 'package:flutter_jdshop/pages/services/SignService.dart';
import '../Widget/jdText.dart';
import '../Widget/CustomizeButton.dart';
import '../services/ScreenAdapter.dart';
import 'package:city_pickers/city_pickers.dart';
import '../services/UserService.dart';
import 'package:dio/dio.dart';
import '../config/Config.dart';
import '../services/EventBus.dart';

class AddressAddPage extends StatefulWidget {
  @override
  _AddressAddPageState createState() => _AddressAddPageState();
}

class _AddressAddPageState extends State<AddressAddPage> {
  String area = '省/市/区';
  String name = "";
  String phone = '';
  String address = '';

  // Mark - Widget
  List<Widget> _listWidget() {
    List<Widget> list = [
      SizedBox(
        height: 30,
      ),
      JdText(
        holderText: "收货人姓名",
        tfHeight: ScreenAdapter.height(60),
        onChangeValue: (value) {
          this.name = value;
        },
      ),
      SizedBox(
        height: 10,
      ),
      JdText(
        holderText: "收货人电话",
        tfHeight: ScreenAdapter.height(60),
        onChangeValue: (value) {
          this.phone = value;
        },
      ),
      SizedBox(
        height: 10,
      ),
      Container(
        height: ScreenAdapter.height(60),
        decoration: BoxDecoration(
            border: Border(
          bottom: BorderSide(width: 1, color: Colors.black12),
        )),
        child: InkWell(
          child: Row(
            children: [Icon(Icons.add_location), Text(this.area)],
          ),
          onTap: () async {
            Result result = await CityPickers.showCityPicker(
              context: context,
            );
            setState(() {
              this.area =
                  "${result.provinceName}/${result.cityName}/${result.areaName}";
            });
            print(result.provinceName);
            print(result.cityName);
            print(result.areaName);
          },
        ),
      ),
      JdText(
        holderText: "详细地址",
        tfHeight: ScreenAdapter.height(200),
        onChangeValue: (value) {
          this.address = value;
        },
      ),
      SizedBox(
        height: 40,
      ),
      Container(
        height: ScreenAdapter.height(80),
        child: CustomizeButton(
          callback: () async {
            List userinfo = await UserServices.getUserInfo();
            var tempJson = {
              'uid': userinfo[0]['_id'],
              'name': this.name,
              'phone': this.phone,
              'address': this.address,
              'salt': userinfo[0]['salt']
            };
            var sign = SignServices.getSign(tempJson);
            print(sign);
            var result = await Dio().post(Config.addCartApi, data: {
              'uid': userinfo[0]['_id'],
              'name': this.name,
              'phone': this.phone,
              'address': this.address,
              'sign': sign,
            });
            if (result.data['success'] == true) {
              Navigator.pop(context);
              eventBus.fire(UpdateAddressEvent("myUser"));
            }
          },
          text: '增加',
          bgColor: Colors.red,
        ),
      )
    ];
    return list;
  }

  @override
  Widget build(BuildContext context) {
    Widget body = ListView(
      children: _listWidget(),
    );
    Widget navBar = AppBar(
      title: Text('增加收货地址'),
    );
    Widget content = Scaffold(
      appBar: navBar,
      body: body,
    );
    return content;
  }
}
