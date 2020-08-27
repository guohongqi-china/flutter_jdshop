class Config {
  static String _domain = "http://jd.itying.com/";

  static String get domain => _domain;

  static String bannerApi = "${domain}api/focus";
  // 猜你喜欢
  static String productApi = "${domain}api/plist?is_hot=1";
  // 热门推荐
  static String bestProductApi = "${domain}api/plist?is_best=1";
}
