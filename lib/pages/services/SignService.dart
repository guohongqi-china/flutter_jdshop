import 'package:crypto/crypto.dart';
import 'dart:convert';

class SignServices {
  static getSign(json) {
    List attrKeys = json.keys.toList();
    // 按照ASCII字符顺序进行升序排序
    attrKeys.sort();
    String str = '';
    for (String item in attrKeys) {
      str += "$item${json[item]}";
    }
    return md5.convert(utf8.encode(str)).toString();
  }
}
