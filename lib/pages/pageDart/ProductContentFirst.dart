import 'dart:async';
import '../services/CartServices.dart';
import 'package:flutter/material.dart';
import '../services/ScreenAdapter.dart';
import '../Widget/CustomizeButton.dart';
import '../model/ProductContent.dart';
import '../config/Config.dart';
import '../services/EventBus.dart';
import './cart/CartNum.dart';
import '../provider/Cart.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductContentFirstPage extends StatefulWidget {
  final List<ProductContentItem> _productContentList;

  ProductContentFirstPage(this._productContentList, {Key key})
      : super(key: key);

  @override
  _ProductContentFirstPageState createState() =>
      _ProductContentFirstPageState();
}

class _ProductContentFirstPageState extends State<ProductContentFirstPage>
    with AutomaticKeepAliveClientMixin {
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  ProductContentItem _productContent;
  String selectValue;
  // ignore: cancel_subscriptions
  StreamSubscription actionEventBus;

  var _cartProvider;

  List _attr = [];
  @override
  initState() {
    super.initState();
    this._productContent = widget._productContentList[0];
    this._attr = this._productContent.attr;
    _initAttr();
    _getSelectedAttrValue();
    actionEventBus = eventBus.on<ProductContentEvent>().listen((event) {
      _attrBottomSheet();
    });
  }

  // 销毁
  void dispose() {
    super.dispose();
    print('object=====已经销毁');
    actionEventBus.cancel();
  }

  _initAttr() {
    // "attr":[{"cate":"鞋面材料","list":["牛皮 "]},{"cate":"闭合方式","list":["系带"]},{"cate":"颜色","list":["红色","白色","黄色"]}]
    var attr = this._attr;

    for (var i = 0; i < attr.length; i++) {
      for (var j = 0; j < attr[i].list.length; j++) {
        attr[i]
            .attrList
            .add({"title": attr[i].list[j], "checked": j == 0 ? true : false});
      }
    }
  }

  // 改变选中规格
  _changeAttriValue(cate, title, setBottomState) {
    var attr = this._attr;
    print(title);
    for (var i = 0; i < attr.length; i++) {
      if (attr[i].cate == cate) {
        for (var j = 0; j < attr[i].list.length; j++) {
          attr[i].attrList[j]['checked'] =
              attr[i].attrList[j]['title'] == title ? true : false;
        }
      }
    }
    setBottomState(() {
      this._attr = attr;
    });
    _getSelectedAttrValue();
  }

  // 获取选中规格
  _getSelectedAttrValue() {
    var _list = this._attr;
    List tempArr = [];
    for (var i = 0; i < _list.length; i++) {
      for (var j = 0; j < _list[i].list.length; j++) {
        if (_list[i].attrList[j]['checked'] == true) {
          tempArr.add(_list[i].attrList[j]['title']);
        }
      }
    }

    setState(() {
      this.selectValue = tempArr.join(',');
    });
    this._productContent.selectedAttr = this.selectValue;
  }

  //============================================widget============================================

  Widget _standardsWidget(value, setBottomState) {
    List<Widget> _listitem(List arr, cate) {
      return arr.map((e) {
        return InkWell(
          onTap: () {
            _changeAttriValue(cate, "${e['title']}", setBottomState);
          },
          child: Container(
            margin: EdgeInsets.all(10),
            child: Chip(
              label: Text("${e['title']}"),
              padding: EdgeInsets.all(10),
              backgroundColor: e['checked'] ? Colors.red : Colors.lightGreen,
            ),
          ),
        );
      }).toList();
    }

    return Wrap(
      children: [
        Container(
          padding: EdgeInsets.only(top: ScreenAdapter.height(30)),
          width: ScreenAdapter.width(100),
          child: Text(
            '${value.cate}: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          width: ScreenAdapter.width(610),
          child: Wrap(children: _listitem(value.attrList, value.cate)),
        )
      ],
    );
  }

  _attrBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, setBottomState) {
            return GestureDetector(
                onTap: () {
                  return false;
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Stack(
                    children: [
                      ListView(
                        children: [
                          Column(
                              children: this._attr.map((e) {
                            return _standardsWidget(e, setBottomState);
                          }).toList()),
                          Divider(),
                          Container(
                              margin: EdgeInsets.only(top: 10),
                              height: ScreenAdapter.height(80),
                              child: Row(
                                children: [
                                  Text(
                                    '数量: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  CartNum(
                                    productContent: this._productContent.count,
                                    callBack: (value) {
                                      // print('object +++++++++ $value');
                                      setBottomState(() {
                                        this._productContent.count = value;
                                      });
                                    },
                                  )
                                ],
                              ))
                        ],
                      ),
                      Positioned(
                          bottom: ScreenAdapter.bottomSafeHeight,
                          width: ScreenAdapter.width(750),
                          height: ScreenAdapter.width(100),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: CustomizeButton(
                                  callback: () async {
                                    CartServices.addCart(this._productContent)
                                        .then((value) {
                                          // 调用privaer 更新数据
                                          return this
                                              ._cartProvider
                                              .updateCartList();
                                        })
                                        .then((value) =>
                                            Navigator.of(context).pop())
                                        .then((value) => Fluttertoast.showToast(
                                            msg: "加入购物车成功",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.black54,
                                            textColor: Colors.white,
                                            fontSize: 16.0));
                                  },
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
                  ),
                ));
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    this._cartProvider = Provider.of<Cart>(context);

    String pic = this._productContent.pic;
    pic = pic.replaceAll('\\', '/');
    pic = Config.domain + pic;
    return Container(
      padding: EdgeInsets.all(10),
      child: ListView(
        children: [
          AspectRatio(
            aspectRatio: 16 / 15,
            child: Image.network("$pic", fit: BoxFit.cover),
          ),
          Container(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              "${this._productContent.title}",
              style: TextStyle(
                  color: Colors.black87, fontSize: ScreenAdapter.fontSize(36)),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              "${this._productContent.subTitle}",
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
                      '￥${this._productContent.price}',
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
                      '￥${this._productContent.oldPrice}',
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
                      "$selectValue",
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
          Divider(),
          Container(
            height: 100.0,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
