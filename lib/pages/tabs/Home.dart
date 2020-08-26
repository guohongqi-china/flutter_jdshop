import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../services/ScreenAdapter.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget _swiper() {
    List<Map> imgList = [
      {'url': 'https://www.itying.com/images/flutter/slide01.jpg'},
      {'url': 'https://www.itying.com/images/flutter/slide02.jpg'},
      {'url': 'https://www.itying.com/images/flutter/slide03.jpg'},
    ];

    // 轮播图
    Widget swiper = Swiper(
      itemBuilder: (BuildContext context, int index) {
        return new Image.network(
          imgList[index]["url"],
          fit: BoxFit.fill,
        );
      },
      // indicatorLayout: PageIndicatorLayout.COLOR,
      autoplay: true,
      itemCount: imgList.length,
      pagination: new SwiperPagination(),
      control: new SwiperControl(),
    );
    return Container(
      child: AspectRatio(
        aspectRatio: 2 / 1,
        child: swiper,
      ),
    );
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
    return Container(
      height: ScreenAdapter.height(200),
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (contxt, index) {
          return Column(
            children: [
              Container(
                  margin: EdgeInsets.only(left: ScreenAdapter.width(10)),
                  height: ScreenAdapter.height(140),
                  // width: ScreenAdapter.width(140),
                  child: AspectRatio(
                    aspectRatio: 4 / 5,
                    child: Image.network(
                        "https://www.itying.com/images/flutter/hot${index + 1}.jpg",
                        fit: BoxFit.cover),
                  )),
              Container(
                // color: Colors.red,
                height: ScreenAdapter.height(30),
                child: Text("第${index}条"),
              )
            ],
          );
        },
        itemCount: 10,
      ),
    );
  }

  _recProductItemWidget() {
    var itemWidth = (ScreenAdapter.getScreenWidth() - 30) / 2;
    return Container(
      padding: EdgeInsets.all(10),
      width: itemWidth,
      decoration:
          BoxDecoration(border: Border.all(color: Colors.black12, width: 1.0)),
      child: Column(
        children: [
          Container(
              width: double.infinity,
              child: Image.network(
                  'https://www.itying.com/images/flutter/list1.jpg',
                  fit: BoxFit.cover)),
          Padding(
            padding: EdgeInsets.only(top: ScreenAdapter.height(10)),
            child: Text(
              "2019夏季四方达是的发送到发送到发送到发送到发生打发斯蒂芬",
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
                    '￥ 188.00',
                    style: TextStyle(color: Colors.red, fontSize: 16.0),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Text('￥ 198.00',
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

  Widget _wrapWidget() {
    return Wrap(
      runSpacing: 10,
      spacing: 10,
      children: [
        _recProductItemWidget(),
        _recProductItemWidget(),
        _recProductItemWidget(),
        _recProductItemWidget(),
        _recProductItemWidget(),
        _recProductItemWidget(),
      ],
    );
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
      Container(padding: EdgeInsets.all(10), child: _wrapWidget())
    ];

    // body
    Widget content = Scaffold(
      appBar: AppBar(
        title: Text('首页'),
        centerTitle: true,
      ),
      body: ListView(children: listWidget),
    );

    return content;
  }
}
