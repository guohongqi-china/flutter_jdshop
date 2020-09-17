import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/Cart.dart';
import '../../services/ScreenAdapter.dart';

class CartNum extends StatefulWidget {
  int productContent;
  Function callBack = (value) {};

  CartNum({Key key, this.productContent, this.callBack}) : super(key: key);

  @override
  _CartNumState createState() => _CartNumState();
}

class _CartNumState extends State<CartNum> {
  int _productContent;

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    this._productContent = widget.productContent;

    ScreenAdapter.init(context);
    var cart = Provider.of<Cart>(context);
    return Container(
      width: ScreenAdapter.width(164),
      decoration:
          BoxDecoration(border: Border.all(width: 1, color: Colors.black12)),
      child: Row(
        children: [_leftBtn(), _centerBtn(), _rightBtn()],
      ),
    );
  }

  // 左侧按钮
  Widget _leftBtn() {
    return InkWell(
      onTap: () {
        if (this._productContent > 0) {
          this._productContent--;
        }
        widget.callBack(this._productContent);
      },
      child: Container(
        alignment: Alignment.center,
        width: ScreenAdapter.width(45),
        height: ScreenAdapter.height(45),
        child: Text('-'),
      ),
    );
  }

  // 右侧按钮
  Widget _rightBtn() {
    return InkWell(
      onTap: () {
        this._productContent++;
        widget.callBack(this._productContent);
      },
      child: Container(
        alignment: Alignment.center,
        width: ScreenAdapter.width(45),
        height: ScreenAdapter.height(45),
        child: Text('+'),
      ),
    );
  }

  // 右侧按钮
  Widget _centerBtn() {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              left: BorderSide(width: 1, color: Colors.black12),
              right: BorderSide(width: 1, color: Colors.black12))),
      alignment: Alignment.center,
      width: ScreenAdapter.width(70),
      height: ScreenAdapter.height(45),
      child: Text('$_productContent'),
    );
  }
}
