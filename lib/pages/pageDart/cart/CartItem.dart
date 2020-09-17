import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/Cart.dart';
import '../../services/ScreenAdapter.dart';
import 'CartNum.dart';

class CartItem extends StatefulWidget {
  Map _itemData;
  CartItem(this._itemData, {Key key}) : super(key: key);
  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  Map _itemData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget._itemData);
  }

  @override
  Widget build(BuildContext context) {
    this._itemData = widget._itemData;

    ScreenAdapter.init(context);
    var cart = Provider.of<Cart>(context);
    return Container(
      height: ScreenAdapter.height(200),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 1, color: Colors.black12))),
      child: Row(
        children: [
          Container(
            width: ScreenAdapter.width(60),
            child: Checkbox(
              value: this._itemData["checked"],
              onChanged: (value) {
                setState(() {
                  _itemData["checked"] = !_itemData["checked"];
                });
                cart.itemChange();
                cart.computeAllPrice();
              },
              activeColor: Colors.pink,
            ),
          ),
          Container(
            width: ScreenAdapter.width(160),
            padding: EdgeInsets.all(10),
            child: Image.network(
              "${this._itemData['pic']}",
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${this._itemData['title']}",
                      maxLines: 2,
                      textAlign: TextAlign.start,
                    ),
                    Text(
                      "${this._itemData['selectedAttr']}",
                      maxLines: 2,
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 13),
                    ),
                    Stack(
                      children: [
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            '￥${this._itemData['price']}',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: CartNum(
                            productContent: this._itemData["count"],
                            callBack: (value) {
                              this._itemData["count"] = value;
                              cart.changeItemCount();
                              cart.computeAllPrice();
                            },
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
