import 'package:flutter/material.dart';
import '../services/ScreenAdapter.dart';
import '../Widget/CustomizeButton.dart';

class ProductContentFirstPage extends StatefulWidget {
  @override
  _ProductContentFirstPageState createState() =>
      _ProductContentFirstPageState();
}

class _ProductContentFirstPageState extends State<ProductContentFirstPage> {
  _attrBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return GestureDetector(
              onTap: () {
                return false;
              },
              child: Stack(
                children: [
                  ListView(),
                  Positioned(
                      bottom: ScreenAdapter.bottomSafeHeight,
                      width: ScreenAdapter.width(750),
                      height: ScreenAdapter.width(100),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: CustomizeButton(
                              callback: null,
                              bgColor: Colors.red,
                              text: '加入购物车',
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: CustomizeButton(
                                callback: null,
                                bgColor: Colors.orange,
                                text: '立即购买',
                              ))
                        ],
                      ))
                ],
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: ListView(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network('https://www.itying.com/images/flutter/p1.jpg',
                fit: BoxFit.cover),
          ),
          Container(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              'sdfsdfasdfasdfa的法撒旦法是的发送到发送到发送到发斯蒂芬',
              style: TextStyle(
                  color: Colors.black87, fontSize: ScreenAdapter.fontSize(36)),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              'sdfsdfasdfasdfa的法撒旦法是的发送到发送到发送到发斯蒂芬',
              style: TextStyle(
                  color: Colors.black54, fontSize: ScreenAdapter.fontSize(28)),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              children: [
                Expanded(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('特价: '),
                    Text(
                      '￥23.00',
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: ScreenAdapter.fontSize(46)),
                    )
                  ],
                )),
                Expanded(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('原价: '),
                    Text(
                      '￥323.00',
                      style: TextStyle(
                          fontSize: ScreenAdapter.fontSize(28),
                          decoration: TextDecoration.lineThrough),
                    )
                  ],
                )),
              ],
            ),
          ),
          Container(
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.only(top: 30),
              height: ScreenAdapter.height(80),
              child: InkWell(
                onTap: _attrBottomSheet,
                child: Row(
                  children: [
                    Text(
                      '已选: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '115 黑色， XL, 1件',
                      style: TextStyle(color: Colors.black87),
                    )
                  ],
                ),
              )),
          Divider(),
          Container(
            padding: EdgeInsets.only(top: 30),
            height: ScreenAdapter.height(80),
            child: Row(
              children: [
                Text(
                  '运费: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '免费',
                  style: TextStyle(color: Colors.black87),
                )
              ],
            ),
          ),
          Divider()
        ],
      ),
    );
  }
}
