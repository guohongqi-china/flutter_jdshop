import 'Storage.dart';
import 'dart:convert';
import '../config/Config.dart';

class CartServices {
  // 添加数据
  static Future<bool> addCart(item) async {
    item = CartServices.formatCartData(item);

    // 1、获取历史数据
    List cartList = await CartServices.getLocalDataList().then((value) {
      print("object$value");
      return value;
    });

    if (cartList.length == 0) {
      // 2.0本地存储为空
      List tempList = [];
      tempList.add(item);
      String data = json.encode(tempList);
      print('object  ==== $data');
      // 2.1写入本地存储
      await Storage.setString("cartList", data);
    } else {
      // 2.2 判断本地存储是否包含现有值
      bool hasData = cartList.any((element) {
        if (element["_id"] == item["_id"] &&
            element["selectedAttr"] == item["selectedAttr"]) {
          return true;
        }
        return false;
      });

      if (hasData) {
        for (var i = 0; i < cartList.length; i++) {
          if (cartList[i]["_id"] == item["_id"] &&
              cartList[i]["selectedAttr"] == item["selectedAttr"]) {
            cartList[i]["count"] = cartList[i]["count"] + item["count"];
          }
        }
        await Storage.setString("cartList", json.encode(cartList));
      } else {
        cartList.add(item);
        await Storage.setString("cartList", json.encode(cartList));
      }
    }
    return true;
  }

  // 清除数据
  static clearLocalCartData() async {
    await Storage.remove('cartList');
  }

  //过滤数据
  static formatCartData(item) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    String picUrl = item.pic;
    picUrl = Config.domain + picUrl.replaceAll('\\', '/');
    print('object 当前图片Url$picUrl');

    data['_id'] = item.sId;
    data['title'] = item.title;
    if (item.price is int || item.price is double) {
      data['price'] = item.price;
    } else {
      data['price'] = double.parse(item.price);
    }
    data['count'] = item.count;
    data['selectedAttr'] = item.selectedAttr;
    data['pic'] = picUrl;
    data['checked'] = false;
    data['salecount'] = item.salecount;
    return data;
  }

  static Future<List> getLocalDataList() async {
    String codeData = await Storage.getString("cartList");
    List data = json.decode(codeData == null ? "[]" : codeData);
    return data;
  }
}
