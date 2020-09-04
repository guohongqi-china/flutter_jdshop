import 'package:flutter/material.dart';
import 'package:flutter_jdshop/pages/model/ProductModel.dart';
import '../config/Config.dart';
import '../services/ScreenAdapter.dart';
import 'package:dio/dio.dart';
import '../Widget/LoadingWidget.dart';

class ProductListPage extends StatefulWidget {
  Map arguments;
  ProductListPage({Key key, this.arguments}) : super(key: key);
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  var _topIndex = 1;
  // 分页
  int _page = 1;
  // 每页多少条数据
  int _pageSize = 8;
  // 是否有数据
  bool hasMore = true;
  // 数据
  List _productListData = [];
  // 排序
  String _sort = "";
  // 标记
  bool flag = true;
  // 用于上啦加载
  ScrollController _scrollController = ScrollController();

  // 调用系统级别侧边栏
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  /** 
   * 二级导航数据 
   * 排序  升序：price_1   {price:1}      降序：price_-1  {price:-1}
   * */
  List _subHeaderList = [
    {"id": 1, "title": "综合", "fileds": "all", "sort": -1},
    {"id": 2, "title": "销量", "fileds": "salecount", "sort": -1},
    {"id": 3, "title": "价格", "fileds": "price", "sort": -1},
    {
      "id": 4,
      "title": "筛选",
    },
  ];

  @override
  initState() {
    super.initState();
    _getProductListData();

    _scrollController.addListener(() {
      //  position.pixels 滚动的高度
      //  position.maxScrollExtent  页面总高度
      if (_scrollController.position.pixels >
          _scrollController.position.maxScrollExtent - 20) {
        if (this.flag && this.hasMore) {
          _getProductListData();
        }
      }
    });
  }

  // 获取商品列表数据
  _getProductListData() async {
    setState(() {
      this.flag = false;
    });
    var api =
        "${Config.productInfoApi}?cid=${widget.arguments['cid']}&page=$_page&sort=${this._sort}&pageSize=${this._pageSize}";
    var result = await Dio().get(api);
    ProductModel productList = ProductModel.fromJson(result.data);
    print(productList.result);
    if (productList.result.length < this._pageSize) {
      setState(() {
        this._productListData.addAll(productList.result);
        this.flag = true;
        this.hasMore = false;
      });
    } else {
      setState(() {
        this._productListData.addAll(productList.result);
        this._page++;
        this.flag = true;
      });
    }
  }

  Widget _showMore(index) {
    if (this.hasMore) {
      return (index == this._productListData.length - 1)
          ? LoadingWidget()
          : Text('');
    } else {
      return (index == this._productListData.length - 1)
          ? Text('数据加载完毕....')
          : Text('');
    }
  }

  Widget _productListWidget() {
    Widget items = ListView.builder(
      itemBuilder: _productList,
      controller: _scrollController,
      itemCount: this._productListData.length,
    );
    return Padding(
        padding: EdgeInsets.fromLTRB(10, ScreenAdapter.height(80), 10, 10),
        child: items);
  }

  // 商品列表
  Widget _productList(context, index) {
    ProductItemModel model = this._productListData[index];
    String pic = model.pic;
    pic = Config.domain + pic.replaceAll('\\', '/');
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: ScreenAdapter.width(180),
              height: ScreenAdapter.width(180),
              child: Image.network(pic, fit: BoxFit.cover),
            ),
            Expanded(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.only(left: 10),
                  height: ScreenAdapter.width(180),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            model.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(
                            height: ScreenAdapter.height(15),
                          ),
                          Row(
                            children: [
                              Container(
                                child: Text(
                                  '2G',
                                  style: TextStyle(fontSize: 12),
                                ),
                                padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    color: Color.fromRGBO(230, 230, 230, 1)),
                              ),
                              Container(
                                child: Text(
                                  '4G',
                                  style: TextStyle(fontSize: 12),
                                ),
                                margin: EdgeInsets.only(left: 10),
                                padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.red, width: 1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    color: Color.fromRGBO(230, 230, 230, 1)),
                              ),
                            ],
                          )
                        ],
                      ),
                      Text(
                        "￥${model.price}",
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      )
                    ],
                  ),
                ))
          ],
        ),
        Divider(
          height: ScreenAdapter.height(20),
        ),
        _showMore(index)
      ],
    );
  }

  // 显示图标
  Widget _showIcon(id) {
    if (id == 2 || id == 3) {
      if (this._subHeaderList[id - 1]['sort'] == -1) {
        return Icon(Icons.arrow_drop_down);
      } else {
        return Icon(Icons.arrow_drop_up);
      }
    } else {
      return Text('');
    }
  }

  // 二级导航
  Widget _subHeaderWidget() {
    return Positioned(
        top: 0,
        width: ScreenAdapter.getScreenWidth(),
        height: ScreenAdapter.height(80),
        child: Container(
            decoration: BoxDecoration(
                border: Border(
              bottom:
                  BorderSide(width: 1, color: Color.fromRGBO(233, 233, 233, 1)),
            )),
            child: Row(
                children: this._subHeaderList.map((value) {
              return Expanded(
                flex: 1,
                child: InkWell(
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(0, ScreenAdapter.height(10),
                          ScreenAdapter.height(10), ScreenAdapter.height(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            value['title'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: value['id'] == _topIndex
                                    ? Colors.red
                                    : Color.fromRGBO(99, 99, 99, 1)),
                          ),
                          _showIcon(value['id'])
                        ],
                      )),
                  onTap: () {
                    setState(() {
                      this._topIndex = value['id'];
                      this._sort = "${value['fileds']}_${value['sort']}";
                      // 重置更多数据
                      this.hasMore = true;
                      // 重置分页
                      this._page = 1;
                      // 重置数据
                      this._productListData = [];

                      value['sort'] = value['sort'] * -1;

                      // listview滚动到顶部
                      _scrollController.animateTo(0.0,
                          duration: Duration(seconds: 2),
                          curve: Curves.bounceInOut);
                      // 重新请求数据
                      this._getProductListData();
                    });
                    if (this._topIndex == 4) {
                      this._scaffoldKey.currentState.openEndDrawer();
                    }
                  },
                ),
              );
            }).toList())));
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    Widget drawer = Drawer(
      child: Text('data'),
    );
    Widget body = Stack(
      children: [
        _subHeaderWidget(),
        this._productListData.length > 0
            ? _productListWidget()
            : LoadingWidget()
      ],
    );
    Widget appBar = AppBar(
      title: Text('商品列表'),
      centerTitle: true,
      actions: [Text('')],
      // leading: Text(''),
    );
    Widget content = Scaffold(
      key: _scaffoldKey,
      appBar: appBar,
      body: body,
      endDrawer: drawer,
    );
    return content;
  }
}
