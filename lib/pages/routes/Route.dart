import 'package:flutter/material.dart';

import '../tabs/Tabs.dart';
import '../pageDart/ProductList.dart';
import '../pageDart/Search.dart';

final routes = {
  '/': (context) => TabsPage(),
  '/productlist': (context, {arguments}) =>
      ProductListPage(arguments: arguments),
  '/search': (context) => SearchPage()
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
