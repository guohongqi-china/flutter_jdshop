import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// class Counter with ChangeNotifier ,DiagnosticableTreeMixin{
//   int _count = 0; // 状态

//   int get count => _count; //获取状态

//   // 更新状态
//   inCount() {
//     this._count++;
//     notifyListeners(); // 表示更新状态
//   }
// }

class Counter with ChangeNotifier, DiagnosticableTreeMixin {
  int _count = 0;
  int get count => _count;

  set count(int value) {
    _count = value;
    notifyListeners();
  }

  void increment() {
    _count++;
    notifyListeners();
  }

  /// Makes `Counter` readable inside the devtools by listing all of its properties
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('count', count));
  }
}
