import 'package:flutter/material.dart';
import 'package:flutter_jdshop/pages/routes/Route.dart';
import 'package:flutter_jdshop/pages/tabs/Tabs.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      theme: ThemeData(primaryColor: Colors.pink),
      // home: TabsPage(),
      initialRoute: '/',
      onGenerateRoute: onGenerateRoute,
    );
  }
}
