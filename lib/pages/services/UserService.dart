import 'Storage.dart';
import 'dart:convert';

class UserServices {
  static getUserInfo() async {
    List _userInfo;

    var userInfoData = json.decode(await Storage.getString('userInfo') ?? '[]');
    _userInfo = userInfoData;
    return _userInfo;
  }

  static getLoginState() async {
    var userInfo = await UserServices.getUserInfo();
    if (userInfo.length > 0 && userInfo[0]['username'] != '') {
      return true;
    } else {
      return false;
    }
  }

  static loginOut() async {
    await Storage.remove('userInfo');
  }
}
