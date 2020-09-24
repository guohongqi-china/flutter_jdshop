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

class AddressEditPage extends StatefulWidget {
  Map arguments;
  AddressEditPage({Key key, this.arguments}) : super(key: key);
  @override
  _AddressEditPageState createState() => _AddressEditPageState();
}

class _AddressEditPageState extends State<AddressEditPage> {
  String area = '省/市/区';
  String name = "";
  String phone = '';
  String address = '';

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.arguments);
    // this.area = widget.arguments['address'];
    this.nameController.text = widget.arguments['name'];
    this.phoneController.text = widget.arguments['phone'];
    this.addressController.text = widget.arguments['address'];
  }

  // Mark - Widget
  List<Widget> _listWidget() {
    List<Widget> list = [
      SizedBox(
        height: 30,
      ),
      JdText(
        controller: nameController,
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
        controller: phoneController,
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
        controller: addressController,
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
              'name': nameController.text,
              'phone': phoneController.text,
              'address': addressController.text,
              'salt': userinfo[0]['salt'],
              'id': widget.arguments['id']
            };

            var sign = SignServices.getSign(tempJson);
            var result = await Dio().post(Config.editCartApi, data: {
              'uid': userinfo[0]['_id'],
              'name': nameController.text,
              'phone': phoneController.text,
              'address': addressController.text,
              'id': widget.arguments['id'],
              'sign': sign,
            });
            if (result.data['success'] == true) {
              Navigator.pop(context);
              eventBus.fire(UpdateAddressEvent("myUser"));
            }
          },
          text: '修改',
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
      title: Text('修改收货地址'),
    );
    Widget content = Scaffold(
      appBar: navBar,
      body: body,
    );
    return content;
  }
}
