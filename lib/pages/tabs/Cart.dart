import "package:flutter/material.dart";
import 'package:flutter_jdshop/pages/pageDart/cart/CartItem.dart';
import 'package:flutter_jdshop/pages/services/CartServices.dart';
// import '../pages/pageDart/cart/CartItem.dart';
import 'package:provider/provider.dart';
import '../pageDart/cart/CartItem.dart';
// import '../pageDart/cart/CartNum.dart';
import '../provider/Cart.dart';
import '../services/ScreenAdapter.dart';
import '../provider/CheckOut.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../services/UserService.dart';

class CartPage extends StatefulWidget {
  Map arguments;
  CartPage({Key key, this.arguments}) : super(key: key);
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool _isEdit = false;
  var _checkOutProvider;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  _doCheckOut() async {
    // 1、获取购物车选中的数据
    List checkList = await CartServices.getCheckOutData();
    // 2、保存购物车选中的数据
    this._checkOutProvider.changeCheckOutListData(checkList);
    // 3、购物车有没有选中的数据
    if (checkList.length > 0) {
      // 4、判断用户有没有登录
      bool loginState = await UserServices.getLoginState();
      if (loginState) {
        Navigator.pushNamed(context, '/checkOut');
      } else {
        _toastText('您还没有登录，请登录以后再去结算');
        Navigator.pushNamed(context, '/login');
      }
    } else {
      _toastText('没有勾选数据');
    }
    // 判断用户有没有登录， 保存购物车选中的数据
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

  Widget _bottomRightWidget(cartProvider) {
    Widget accountWidget = Text(
      '结算',
      style: TextStyle(
          color: Colors.white, fontSize: ScreenAdapter.fontSize(20.0)),
    );

    Widget deleteWidget = Text(
      '删除',
      style: TextStyle(
          color: Colors.white, fontSize: ScreenAdapter.fontSize(20.0)),
    );
    Widget widget = InkWell(
      onTap: () {
        if (this._isEdit) {
          cartProvider.deleteAllData();
        } else {
          _doCheckOut();
        }
      },
      child: Container(
        height: double.infinity,
        alignment: Alignment.center,
        width: ScreenAdapter.width(150),
        child: this._isEdit ? deleteWidget : accountWidget,
        color: Colors.red,
      ),
    );
    return widget;
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    var cartProvider = Provider.of<Cart>(context);
    _checkOutProvider = Provider.of<CheckOut>(context);

    print("object0000000000${widget.arguments}");
    var bottomH = widget.arguments == null
        ? ScreenAdapter.height(78)
        : ScreenAdapter.height(78) + ScreenAdapter.bottomSafeHeight;
    var bottomM =
        widget.arguments == null ? 0.0 : ScreenAdapter.bottomSafeHeight;
    Widget bottomBar = Positioned(
        bottom: 0,
        width: ScreenAdapter.getScreenWidth(),
        child: Container(
            height: bottomH,
            margin: EdgeInsets.only(bottom: 0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  top: BorderSide(
                      style: BorderStyle.solid,
                      width: 1,
                      color: Color.fromRGBO(233, 233, 233, 0.9))),
            ),
            child: Container(
              height: ScreenAdapter.height(78),
              margin: EdgeInsets.only(bottom: bottomM),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: cartProvider.isCheckedAll,
                        onChanged: (value) {
                          cartProvider.checkAll(value);
                        },
                        activeColor: Colors.red,
                      ),
                      Text('全选', style: TextStyle(fontSize: 14)),
                      SizedBox(
                        width: 10,
                      ),
                      this._isEdit
                          ? Text('')
                          : Text("合计: ", style: TextStyle(fontSize: 14)),
                      this._isEdit
                          ? Text('')
                          : Text(
                              "${cartProvider.allPrice}",
                              style: TextStyle(color: Colors.red, fontSize: 18),
                            )
                    ],
                  ),
                  _bottomRightWidget(cartProvider)
                ],
              ),
            )));
    Widget body = Stack(
      children: [
        ListView(
          children: [
            Column(
              children: cartProvider.cartList.map((e) {
                return CartItem(e);
              }).toList(),
            ),
            SizedBox(
              height: ScreenAdapter.height(78) + ScreenAdapter.bottomSafeHeight,
            )
          ],
        ),
        bottomBar
      ],
    );

    return Scaffold(
        appBar: AppBar(
          title: Text('购物车'),
          actions: [
            IconButton(
                icon: Icon(Icons.launch),
                onPressed: () => {
                      setState(() {
                        this._isEdit = !this._isEdit;
                      })
                    })
          ],
          centerTitle: true,
        ),
        body: cartProvider.cartList.length > 0
            ? body
            : Center(
                child: Text('购物车空空如也！'),
              ));
  }
}

// class _CartPageState extends State<CartPage> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     // context.read<Counter>().increment();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var counterProvider = Provider.of<Counter>(context);
//     var cartProvider = Provider.of<Cart>(context);

//     return Scaffold(
//         floatingActionButton: FloatingActionButton(
//           onPressed: () => cartProvider.addData('哈哈${cartProvider.cartNum}'),
//           child: Icon(Icons.add),
//         ),
//         appBar: AppBar(
//           title: Text('购物车'),
//           actions: [IconButton(icon: Icon(Icons.launch), onPressed: () => {})],
//           centerTitle: true,
//         ),
//         body: Column(
//           children: [
//             Padding(padding: EdgeInsets.only(top: 20)),
//             CartItem(),
//             Divider(
//               height: 40,
//             ),
//             CartNum()
//           ],
//         ));
//   }
// }

// class _CartPageState extends State<CartPage> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     context.read<Counter>().increment();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('购物车'),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: Text("${context.watch<Counter>().count}"),
//       ),
//     );
//   }
// }
