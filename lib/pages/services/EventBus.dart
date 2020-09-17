import 'package:event_bus/event_bus.dart';

// 初始化Bus
EventBus eventBus = EventBus();

class ProductContentEvent {
  String str = "";
  ProductContentEvent(this.str);
}
