import 'package:flutter/material.dart';

import '../tabs/Tabs.dart';
import '../pageDart/ProductList.dart';
import '../pageDart/Search.dart';
import '../pageDart/ProductContent.dart';
import '../tabs/Cart.dart';
import '../pageDart/Login.dart';
import '../pageDart/RegisterFirst.dart';
import '../pageDart/RegisterSecond.dart';
import '../pageDart/RegisterThird.dart';
import '../pageDart/CheckOut.dart';
import '../pageDart/AddressAdd.dart';
import '../pageDart/AddressList.dart';
import '../pageDart/AddressEdit.dart';
import '../pageDart/Pay.dart';
import '../pageDart/Order.dart';
import '../pageDart/OrderInfo.dart';

final routes = {
  '/': (context) => TabsPage(),
  '/productlist': (context, {arguments}) =>
      ProductListPage(arguments: arguments),
  '/search': (context) => SearchPage(),
  '/login': (context) => LoginPage(),
  '/registerFirst': (context) => RegisterFirst(),
  '/registerSecond': (context, {arguments}) =>
      RegisterSecond(arguments: arguments),
  '/registerThird': (context, {arguments}) =>
      RegisterThird(arguments: arguments),
  '/cart': (context, {arguments}) => CartPage(arguments: arguments),
  '/productcontent': (context, {arguments}) => ProductContentPage(
        arguments: arguments,
      ),
  '/checkOut': (context) => CheckOutPage(),
  '/addressList': (context) => AddressListPage(),
  '/addressAdd': (context) => AddressAddPage(),
  '/order': (context) => OrderPage(),
  '/orderInfo': (context) => OrderInfoPage(),
  '/addressEdit': (context, {arguments}) =>
      AddressEditPage(arguments: arguments),
  '/pay': (context) => PayPage(),
};

//固定写法
var onGenerateRoute = (RouteSettings settings) {
  // 统一处理
  final String name = settings.name;
  final Function pageContentBuilder = routes[name];
  if (pageContentBuilder != null) {
    if (settings.arguments != null) {
      final Route route = MaterialPageRoute(
          builder: (context) =>
              pageContentBuilder(context, arguments: settings.arguments));
      return route;
    } else {
      final Route route =
          MaterialPageRoute(builder: (context) => pageContentBuilder(context));
      return route;
    }
  }
};
