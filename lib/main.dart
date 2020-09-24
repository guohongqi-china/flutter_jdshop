import 'package:flutter/material.dart';
import 'package:flutter_jdshop/pages/routes/Route.dart';

// 进入provider
import 'package:provider/provider.dart';
import './pages/provider/Counter.dart';
import './pages/provider/Cart.dart';
import './pages/provider/CheckOut.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Provider.debugCheckInvalidValueType = null;
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => Counter()),
      ChangeNotifierProvider(create: (_) => Cart()),
      ChangeNotifierProvider(create: (_) => CheckOut()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    print('33333333333');

    return MaterialApp(
      debugShowCheckedModeBanner: true,
      theme: ThemeData(primaryColor: Colors.pink),
      // home: TabsPage(),
      initialRoute: '/',
      onGenerateRoute: onGenerateRoute,
    );
  }
}
