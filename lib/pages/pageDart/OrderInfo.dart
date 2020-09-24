import 'package:flutter/material.dart';
import '../services/ScreenAdapter.dart';

class OrderInfoPage extends StatefulWidget {
  @override
  _OrderInfoPageState createState() => _OrderInfoPageState();
}

class _OrderInfoPageState extends State<OrderInfoPage> {
  @override
  Widget build(BuildContext context) {
    Widget _contentItem(value) {
      Widget content = Container(
        color: Colors.white,
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
              width: ScreenAdapter.width(150),
              child: Image.network(
                  "https://www.itying.com/images/flutter/list2.jpg",
                  fit: BoxFit.cover),
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
                        "xxxxxxxxxxxxx",
                        style: TextStyle(color: Colors.black87),
                      ),
                      Text("xxxxxx"),
                      Stack(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text("￥345",
                                style: TextStyle(color: Colors.red)),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text("x2"),
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

    Widget widget = InkWell(
      child: Container(
        height: ScreenAdapter.height(80),
        width: ScreenAdapter.getScreenWidth(),
        color: Colors.white,
        child: ListTile(
          leading: Icon(Icons.add_location),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text('张三  16789389043'), Text('北京市海淀区 西二旗')],
          ),
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('订单详情'),
      ),
      body: Container(
        child: ListView(
          children: [
            widget,
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  _contentItem(2),
                  _contentItem(2),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  ListTile(
                    title: Row(
                      children: [
                        Text(
                          '订单编号：',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('345678908767898767')
                      ],
                    ),
                  ),
                  ListTile(
                    title: Row(
                      children: [
                        Text(
                          '下单日期：',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('2020-09-23')
                      ],
                    ),
                  ),
                  ListTile(
                    title: Row(
                      children: [
                        Text(
                          '支付方式：',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('微信支付')
                      ],
                    ),
                  ),
                  ListTile(
                    title: Row(
                      children: [
                        Text(
                          '配送方式：',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('顺丰速递')
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              color: Colors.white,
              child: ListTile(
                title: Row(
                  children: [
                    Text(
                      '总金额：',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '￥168',
                      style: TextStyle(color: Colors.red),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
