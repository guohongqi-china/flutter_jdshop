import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jdshop/pages/services/Storage.dart';
import '../services/CartServices.dart';
import 'dart:convert';

class Cart with ChangeNotifier {
  List _cartList = []; //状态
  bool _isCheckedAll = false; // 全选状态
  double _allPrice = 0; // 总价

  List get cartList => _cartList;
  bool get isCheckedAll => _isCheckedAll;
  double get allPrice => _allPrice;

  int get cartNum => _cartList.length;

  Cart() {
    this.initData();
  }
  // 初始化的时候获取购物车数据
  initData() async {
    List carListData = await CartServices.getLocalDataList().then((value) {
      return value;
    });
    this._cartList = carListData ?? [];
    this._isCheckedAll = isChekAll();
    notifyListeners();
  }

  Future<bool> updateCartList() async {
    this.initData();
    return true;
  }

  changeItemCount() {
    Storage.setString('cartList', json.encode(this._cartList));
    notifyListeners();
  }

  // 全选 反选
  checkAll(value) {
    for (var item in this._cartList) {
      item["checked"] = value;
    }
    this._isCheckedAll = value;
    Storage.setString('cartList', json.encode(this._cartList));
    notifyListeners();
  }

  // 判断是否全选
  bool isChekAll() {
    return !this._cartList.any((element) => element["checked"] == false);
  }

  // 监听选中事件
  itemChange() {
    this._isCheckedAll = this.isChekAll();
    changeItemCount();
  }

  // 计算总价
  computeAllPrice() {
    double tempAllPrice = 0;
    for (var i = 0; i < this._cartList.length; i++) {
      if (this._cartList[i]["checked"] == true) {
        double pic = 0;
        pic = this._cartList[i]["price"];
        tempAllPrice += pic * this._cartList[i]["count"];
      }
    }
    this._allPrice = tempAllPrice;
    print('${this._allPrice}');
    notifyListeners();
  }

  // 清空数据
  deleteAllData() async {
    List tempList = [];
    for (var item in this._cartList) {
      if (item['checked'] != true) {
        tempList.add(item);
      }
    }
    this._cartList = tempList;
    computeAllPrice();
    Storage.setString('cartList', json.encode(this._cartList));
    notifyListeners();
  }
}
