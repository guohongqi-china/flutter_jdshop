import 'package:flutter/material.dart';
import '../Widget/CustomizeButton.dart';
import '../services/ScreenAdapter.dart';

class PayPage extends StatefulWidget {
  @override
  _PayPageState createState() => _PayPageState();
}

class _PayPageState extends State<PayPage> {
  List payList = [
    {
      'title': '支付宝支付',
      'checked': true,
      'image': 'https://www.itying.com/themes/itying/images/alipay.png'
    },
    {
      'title': '微信支付',
      'checked': false,
      'image': 'https://www.itying.com/themes/itying/images/weixinpay.png'
    }
  ];

  @override
  Widget build(BuildContext context) {
    Widget body = Column(
      children: [
        Container(
            margin: EdgeInsets.only(top: 50),
            height: 400,
            child: ListView.builder(
                itemCount: this.payList.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                          onTap: () {
                            for (var item in this.payList) {
                              item['checked'] = false;
                            }

                            setState(() {
                              this.payList[index]['checked'] = true;
                            });
                          },
                          leading:
                              Image.network("${this.payList[index]['image']}"),
                          title: Text("${this.payList[index]['title']}"),
                          trailing: this.payList[index]['checked'] == true
                              ? Icon(Icons.check)
                              : Text('')),
                      Divider(),
                    ],
                  );
                })),
        CustomizeButton(
          callback: () {
            print('支付');
          },
          height: ScreenAdapter.height(80),
          text: '支付',
          bgColor: Colors.red,
        )
      ],
    );
    Widget navBar = AppBar(
      title: Text('支付页面'),
    );
    Widget content = Scaffold(
      appBar: navBar,
      body: body,
    );
    return content;
  }
}
