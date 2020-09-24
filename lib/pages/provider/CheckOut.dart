import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CheckOut with ChangeNotifier {
  List _checkOutListData = [];
  List get checkOutListData => _checkOutListData;

  changeCheckOutListData(data) {
    this._checkOutListData = data;
    notifyListeners();
  }
}
