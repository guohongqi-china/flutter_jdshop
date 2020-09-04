import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScreenAdapter {
  static init(context) {
    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
  }

  // 适配高度
  static height(double value) {
    return ScreenUtil().setHeight(value);
  }

  // 适配宽度
  static width(double value) {
    return ScreenUtil().setWidth(value);
  }

  // 适配字体
  static fontSize(double fontSize) {
    return ScreenUtil().setSp(fontSize);
  }

  /// 获取整屏高度
  static getScreenHeight() {
    return ScreenUtil.screenHeight;
  }

  /// 获取整屏宽度
  static getScreenWidth() {
    return ScreenUtil.screenWidth;
  }
}
