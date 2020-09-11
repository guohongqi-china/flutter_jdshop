import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import '../model/ProductContent.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../config/Config.dart';
import '../services/ScreenAdapter.dart';

class ProductContentSecondPage extends StatefulWidget {
  List<ProductContentItem> productContentList;

  ProductContentSecondPage({Key key, this.productContentList})
      : super(key: key);

  @override
  _ProductContentSecondPageState createState() =>
      _ProductContentSecondPageState();
}

class _ProductContentSecondPageState extends State<ProductContentSecondPage>
    with AutomaticKeepAliveClientMixin {
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  var _id;

  // final Completer<WebViewController> _controller =
  // Completer<WebViewController>();

  WebViewController _controller;
  String _title = "webview";
  double _height = 500;
  double _width = 400;
  String htmlStr = """<p>ListView中的webview_flutter要放在SizedBox中，指定并指定sizedbox的高度，
                      否则会出错。<span style="color:#e74c3c">实际高度可以调用js来获得返回的高度
                      </span></p>

                      <p><img alt="" src="http://10.0.2.2:8000/media/imgs/2019-12-05.png"  /></p>""";

  @override
  initState() {
    super.initState();
    this._id = widget.productContentList[0].sId;
    print("${Config.productwebApi}${this._id}");
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }

  // Widget _webViewWidget() {
  //   return WebView(
  //     initialUrl: "https://www.baidu.com/",
  //     javascriptMode: JavascriptMode.unrestricted,
  //     onWebViewCreated: (WebViewController webViewController) {
  //       _controller.complete(webViewController);
  //     },
  //     javascriptChannels: <JavascriptChannel>[
  //       _toasterJavascriptChannel(context),
  //     ].toSet(),
  //     navigationDelegate: (NavigationRequest request) {
  //       if (request.url.startsWith('https://www.youtube.com/')) {
  //         print('blocking navigation to $request}');
  //         return NavigationDecision.prevent;
  //       }
  //       print('allowing navigation to $request');
  //       return NavigationDecision.navigate;
  //     },
  //     onPageStarted: (String url) {
  //       print('Page started loading: $url');
  //     },
  //     onPageFinished: (String url) {
  //       print('Page finished loading: $url');
  //     },
  //     gestureNavigationEnabled: true,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    Widget webView = Expanded(
      child: WebView(
        initialUrl: "http://jd.itying.com/pcontent?id=5a0425bc010e711234661439",
        //JS执行模式 是否允许JS执行
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (controller) {
          _controller = _controller;
          // controller.loadUrl(Uri.dataFromString(htmlStr,
          //         mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
          //     .toString());
        },
        onPageFinished: (url) {
          //调用JS得到实际高度
          _controller
              .evaluateJavascript("document.documentElement.clientHeight;")
              .then((result) {
            setState(() {
              _height = double.parse(result);
              print("高度$_height");
            });
          });
        },
        navigationDelegate: (NavigationRequest request) {
          if (request.url.startsWith("myapp://")) {
            print("即将打开 ${request.url}");

            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
        javascriptChannels: <JavascriptChannel>[
          JavascriptChannel(
              name: "share",
              onMessageReceived: (JavascriptMessage message) {
                print("参数： ${message.message}");
              }),
        ].toSet(),
      ),
    );

    return Container(
      child: Column(
        children: [webView],
      ),
    );
  }
}
