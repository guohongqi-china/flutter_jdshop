import 'Storage.dart';

/**
 * Dart List 方法
 * any 只要集合中有满足条件的返回true
 * every 只要集合中每一个都满足条件的返回true
 */

class SearchServices {
  static setHistoryList(value) async {
    // 获取本地存储数据

    List searchHistoryData = await SearchServices.getHistoryList();
    if (searchHistoryData == null) {
      List<String> temList = List();
      temList.add("$value");
      bool result = await Storage.setStringList('searchList', temList);
      if (result) {
        print('成功$result');
      } else {
        print('失败$result');
      }
    } else {
      var hasData = searchHistoryData.any((element) {
        return element == value;
      });
      if (!hasData) {
        searchHistoryData.add("$value");
        await Storage.setStringList('searchList', searchHistoryData);
      }
    }
  }

  static getHistoryList() async {
    List searchListData = await Storage.getStringList('searchList');
    return searchListData;
  }

  static Future removeHistoryList() async {
    bool result = await Storage.remove("searchList");
    if (result) {
      print('成功$result');
    } else {
      print('失败$result');
    }
  }

  static Future removeHistoryByKey(keywords) async {
    List searchHistoryData = await SearchServices.getHistoryList();
    searchHistoryData.remove(keywords);
    await Storage.setStringList('searchList', searchHistoryData);
  }
}
