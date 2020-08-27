import 'package:flutter/material.dart';
import '../services/ScreenAdapter.dart';

class Category extends StatefulWidget {
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  var _currentSelectIndex = 0;

  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);

    // 计算右侧GridView宽高比
    var screenWidth = ScreenAdapter.getScreenWidth() / 4;

    var rightItemWidth =
        (ScreenAdapter.getScreenWidth() - screenWidth - 20 - 20) / 3;
    var rightItemHeight = rightItemWidth + ScreenAdapter.height(32);

    print('object=================================');
    print(rightItemHeight);
    print(rightItemWidth);
    print(screenWidth);
    print(ScreenAdapter.height(32));

    Widget body = Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            _currentSelectIndex = index;
                          });
                        },
                        child: Container(
                          child: Text(
                            '第${index}',
                            textAlign: TextAlign.center,
                          ),
                          width: double.infinity,
                          height: ScreenAdapter.height(46),
                          color: _currentSelectIndex == index
                              ? Colors.red
                              : Colors.white,
                        ),
                      ),
                      Divider()
                    ],
                  );
                }),
          ),
        ),
        Expanded(
            flex: 3,
            child: Container(
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
                  itemBuilder: (context, index) {
                    return Container(
                      child: Column(
                        children: [
                          AspectRatio(
                              aspectRatio: 1 / 1,
                              child: Image.network(
                                "https://www.itying.com/images/flutter/list8.jpg",
                                fit: BoxFit.cover,
                              )),
                          Container(
                            height: ScreenAdapter.height(32),
                            child: Text("女孩"),
                          )
                        ],
                      ),
                    );
                  }),
            ))
      ],
    );
    Widget content = Scaffold(
        appBar: AppBar(
          title: Text('分类'),
          centerTitle: true,
        ),
        body: body);
    return content;
  }
}
