import 'package:flutter/material.dart';
import 'package:flutter_jdshop/pages/Widget/AppBarHead.dart';
import '../services/ScreenAdapter.dart';
import 'package:dio/dio.dart';
import '../config/Config.dart';
import '../model/CateModel.dart';
import '../services/ScreenAdapter.dart';

class Category extends StatefulWidget {
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category>
    with AutomaticKeepAliveClientMixin {
  var _currentSelectIndex = 0;
  List<CateItemModel> _leftCateList = [];
  List<CateItemModel> _rightCateList = [];

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _getLeftCateData();
  }

  // 左侧分类
  _getLeftCateData() async {
    var result = await Dio().get(Config.cateProductApi);
    CateModel leftCateList = CateModel.fromJson(result.data);
    print(leftCateList.result);
    setState(() {
      _leftCateList = leftCateList.result;
    });
    _getRightCateData(leftCateList.result[0].sId);
  }

  // 右侧分类
  _getRightCateData(pid) async {
    var api = Config.cateProductApi + "?pid=$pid";
    var result = await Dio().get(api);
    CateModel rightCateList = CateModel.fromJson(result.data);
    setState(() {
      _rightCateList = rightCateList.result;
    });
  }

  // 左侧列表
  Widget _leftCateWidget() {
    Widget content = Container(
      color: Color.fromRGBO(240, 246, 246, 0.9),
      child: ListView.builder(
          itemCount: this._leftCateList.length,
          itemBuilder: (context, index) {
            CateItemModel model = this._leftCateList[index];
            return Column(
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      _currentSelectIndex = index;
                      _getRightCateData(this._leftCateList[index].sId);
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.only(top: ScreenAdapter.height(16)),
                    child: Text(
                      model.title,
                      textAlign: TextAlign.center,
                    ),
                    width: double.infinity,
                    height: ScreenAdapter.height(64),
                    color: _currentSelectIndex == index
                        ? Color.fromRGBO(240, 246, 246, 0.9)
                        : Colors.white,
                  ),
                ),
                Divider(
                  height: 1,
                )
              ],
            );
          }),
    );
    if (_leftCateList.length > 0) {
      return content;
    } else {
      return Container();
    }
  }

  // 右侧列表
  Widget _rightCateWidget(rightItemWidth, rightItemHeight) {
    Widget content = Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      color: Color.fromRGBO(240, 246, 246, 0.9),
      child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: rightItemWidth / rightItemHeight,
            // childAspectRatio: 1 / 1.2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: this._rightCateList.length,
          itemBuilder: (context, index) {
            CateItemModel model = this._rightCateList[index];
            // 处理图片
            String pic = model.pic;
            pic = Config.domain + pic.replaceAll('\\', '/');
            return InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/productlist',
                    arguments: {'cid': model.sId});
              },
              child: Container(
                child: Column(
                  children: [
                    AspectRatio(
                        aspectRatio: 1 / 1,
                        child: Image.network(
                          pic,
                          fit: BoxFit.cover,
                        )),
                    Container(
                      height: ScreenAdapter.height(32),
                      child: Text(model.title),
                    )
                  ],
                ),
              ),
            );
          }),
    );
    if (this._rightCateList.length > 0) {
      return content;
    } else {
      return Container(
        color: Color.fromRGBO(240, 246, 246, 0.9),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);

    // 计算右侧GridView宽高比
    var screenWidth = ScreenAdapter.getScreenWidth() / 4;

    var rightItemWidth =
        (ScreenAdapter.getScreenWidth() - screenWidth - 20 - 20) / 3;
    var rightItemHeight = rightItemWidth + ScreenAdapter.height(32);

    Widget body = Row(
      children: [
        Expanded(flex: 1, child: _leftCateWidget()),
        Expanded(
            flex: 3, child: _rightCateWidget(rightItemWidth, rightItemHeight))
      ],
    );
    Widget content = Scaffold(
        appBar: AppBar(
          title: AppBarHeadPage(
            title: '笔记本',
            tapAction: () {
              Navigator.pushNamed(context, '/search');
            },
          ),
          centerTitle: true,
        ),
        body: body);
    return content;
  }
}
