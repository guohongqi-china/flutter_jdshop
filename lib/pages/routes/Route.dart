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

final routes = {
  '/': (context) => TabsPage(),
  '/productlist': (context, {arguments}) =>
      ProductListPage(arguments: arguments),
  '/search': (context) => SearchPage(),
  '/login': (context) => LoginPage(),
  '/registerFirst': (context) => RegisterFirst(),
  '/registerSecond': (context, {arguments}) =>
      RegisterSecond(arguments: arguments),
  '/registerThird': (context) => RegisterThird(),
  '/cart': (context, {arguments}) => CartPage(arguments: arguments),
  '/productcontent': (context, {arguments}) => ProductContentPage(
        arguments: arguments,
      )
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
