class Config {
  static String _domain = "http://jd.itying.com/";

  static String get domain => _domain;

  static String bannerApi = "${domain}api/focus";
  // 猜你喜欢
  static String productApi = "${domain}api/plist?is_hot=1";
  // 热门推荐
  static String bestProductApi = "${domain}api/plist?is_best=1";

  // 分类
  static String cateProductApi = "${domain}api/pcate";

  // 商品详情列表
  static String productInfoApi = "${domain}api/plist";

  // 商品详情列表
  static String productcontentApi = "${domain}api/pcontent?id=";

  // 商品详情列表
  static String productwebApi = "${domain}pcontent?id=";

  // 发送验证码
  static String sendCodeApi = "${domain}api/sendCode";

  // 验证验证码
  static String validateCodeAPi = "${domain}api/validateCode";

  // 完成注册
  static String doneRegisterApi = "${domain}api/register";

  // 登录
  static String loginApi = "${domain}api/doLogin";

  // 新增用户地址
  static String addCartApi = "${domain}api/addAddress";

  // 新增用户地址
  static String editCartApi = "${domain}api/editAddress";

  // 获取用户列表
  static String addAddressList = "${domain}api/addressList";

  // 获取用户默认地址
  static String getDefaultAddress = "${domain}api/oneAddressList";

  // 修改用户默认地址
  static String changeDefaultAddress = "${domain}api/changeDefaultAddress";

  // 刪除地址
  static String deleteAddress = "${domain}api/deleteAddress";

  // 下单
  static String confirmOrder = "${domain}api/doOrder";

  // 订单列表
  static String orderList = "${domain}api/orderList";
}
