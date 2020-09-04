import 'package:flutter/material.dart';
import 'package:flutter_jdshop/pages/model/ProductModel.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../services/ScreenAdapter.dart';
import '../model/FocusModel.dart';
import 'package:dio/dio.dart';
import '../config/Config.dart';
import '../Widget/AppBarHead.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  List<FocusItemModel> _focusData = [];
  List<ProductItemModel> _hotProductList = [];
  List<ProductItemModel> _bestProductList = [];

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  initState() {
    super.initState();
    _getFocusData();
    _getHotProductData();
    _getBestProductData();
  }

  //==============================Event Actions=============================================

  // 获取轮播图数据
  _getFocusData() async {
    var api = Config.bannerApi;
    var result = await Dio().get(api);
    FocusModel focuslist = FocusModel.fromJson(result.data);
    setState(() {
      this._focusData = focuslist.result;
    });
  }

  // 获取猜你喜欢数据
  _getHotProductData() async {
    var api = Config.productApi;
    var result = await Dio().get(api);
    ProductModel hotProductList = ProductModel.fromJson(result.data);

    setState(() {
      this._hotProductList = hotProductList.result;
    });
  }

  // 获取热门推荐
  _getBestProductData() async {
    var api = Config.bestProductApi;
    var result = await Dio().get(api);
    ProductModel bestProductList = ProductModel.fromJson(result.data);
    print('=================');
    setState(() {
      this._bestProductList = bestProductList.result;
    });
  }

  //==============================Widget Actions=============================================

  // 轮播图
  Widget _swiper() {
    Widget swiper = Swiper(
      itemBuilder: (BuildContext context, int index) {
        String pic = this._focusData[index].pic;
        return new Image.network(
          "${Config.domain}${pic.replaceAll('\\', '/')}",
          fit: BoxFit.fill,
        );
      },
      // indicatorLayout: PageIndicatorLayout.COLOR,
      autoplay: true,
      itemCount: this._focusData.length,
      pagination: new SwiperPagination(),
      control: new SwiperControl(),
    );

    if (this._focusData.length > 0) {
      return Container(
        child: AspectRatio(
          aspectRatio: 2 / 1,
          child: swiper,
        ),
      );
    } else {
      return Text('加载中....');
    }
  }

  // 小组件
  Widget _titleWidget(String title) {
    return Container(
      height: ScreenAdapter.height(36),
      margin: EdgeInsets.only(left: ScreenAdapter.width(20)),
      padding: EdgeInsets.only(left: ScreenAdapter.width(10)),
      decoration: BoxDecoration(
          border: Border(
              left: BorderSide(
                  color: Colors.red, width: ScreenAdapter.width(10)))),
      child: Text(
        title,
        style: TextStyle(color: Colors.black54),
      ),
    );
  }

  //热门商品
  Widget _hotProductListWidget() {
    Widget _hotProductWidget = Container(
      height: ScreenAdapter.height(200),
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (contxt, index) {
          String sPic = this._hotProductList[index].sPic;
          sPic = Config.domain + sPic.replaceAll("\\", "/");

          return Column(
            children: [
              Container(
                  margin: EdgeInsets.only(left: ScreenAdapter.width(10)),
                  height: ScreenAdapter.height(140),
                  // width: ScreenAdapter.width(140),
                  child: AspectRatio(
                    aspectRatio: 4 / 5,
                    child: Image.network(sPic, fit: BoxFit.cover),
                  )),
              Container(
                // color: Colors.red,
                height: ScreenAdapter.height(30),
                child: Text(
                  "￥${this._hotProductList[index].price}",
                  style: TextStyle(color: Colors.red),
                ),
              )
            ],
          );
        },
        itemCount: this._hotProductList.length,
      ),
    );
    if (this._hotProductList.length > 0) {
      return _hotProductWidget;
    } else {
      return Text(' ');
    }
  }

  // 热门推荐列表
  Widget _recProductItemWidget(ProductItemModel value) {
    var itemWidth = (ScreenAdapter.getScreenWidth() - 30) / 2;
    String sImg = value.sPic;
    sImg = Config.domain + sImg.replaceAll("\\", "/");
    return Container(
      padding: EdgeInsets.all(10),
      width: itemWidth,
      decoration:
          BoxDecoration(border: Border.all(color: Colors.black12, width: 1.0)),
      child: Column(
        children: [
          Container(
              width: double.infinity,
              child: AspectRatio(
                // 防止服务器返回的图片大小不一致，导致高度不一致
                aspectRatio: 1 / 1,
                child: Image.network(sImg, fit: BoxFit.cover),
              )),
          Padding(
            padding: EdgeInsets.only(top: ScreenAdapter.height(10)),
            child: Text(
              value.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.black54),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    '￥${value.price}',
                    style: TextStyle(color: Colors.red, fontSize: 16.0),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Text('￥${value.oldPrice}',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14.0,
                        decoration: TextDecoration.lineThrough,
                      )),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _recProductListWidget() {
    return Container(
        padding: EdgeInsets.all(10),
        child: Wrap(
          runSpacing: 10,
          spacing: 10,
          children: this._bestProductList.map((value) {
            return _recProductItemWidget(value);
          }).toList(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);

    // 列表组件
    List<Widget> listWidget = [
      _swiper(),
      SizedBox(
        height: 10,
      ),
      _titleWidget('猜你喜欢'),
      SizedBox(
        height: 10,
      ),
      _hotProductListWidget(),
      _titleWidget('热门推荐'),
      _recProductListWidget(),
    ];

    Widget headerSearch = InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/search');
      },
      child: Container(
        height: ScreenAdapter.height(50),
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        decoration: BoxDecoration(
            color: Color.fromRGBO(233, 233, 233, 0.8),
            borderRadius: BorderRadius.circular(ScreenAdapter.height(50) / 2)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              color: Colors.grey,
            ),
            Text(
              '笔记本',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            )
          ],
        ),
      ),
    );

    // body
    Widget content = Scaffold(
      appBar: AppBar(
        title: AppBarHeadPage(
          title: '笔记本',
          tapAction: () {
            Navigator.pushNamed(context, '/search');
          },
        ),
        centerTitle: true,
        leading:
            IconButton(icon: Icon(Icons.center_focus_weak), onPressed: () {}),
        actions: [
          IconButton(
              icon: Icon(
                Icons.message,
                color: Colors.white,
              ),
              iconSize: 28,
              color: Colors.black87,
              onPressed: () {}),
        ],
      ),
      body: ListView(children: listWidget),
    );

    return content;
  }
}
