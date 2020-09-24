import 'package:event_bus/event_bus.dart';

// 初始化Bus
EventBus eventBus = EventBus();

// 商品详情广播
class ProductContentEvent {
  String str = "";
  ProductContentEvent(this.str);
}

// 用户中心广播
class UserEvent {
  String str = "";
  UserEvent(this.str);
}

// 更新收货地址
class UpdateAddressEvent {
  String str = "";
  UpdateAddressEvent(this.str);
}
