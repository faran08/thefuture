import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:thefuture/globals.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticleView extends StatelessWidget {
  String articleURL = '';
  ArticleView({Key? key, required this.articleURL}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // systemOverlayStyle: SystemUiOverlayStyle.light,
          leading: Container(),
          toolbarHeight: 1,
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: WebView(
            onPageFinished: (url) {
              EasyLoading.dismiss();
            },
            onPageStarted: (url) {
              EasyLoading.show();
            },
            backgroundColor: backGroundColor,
            initialUrl: articleURL,
          ),
        ));
  }
}
