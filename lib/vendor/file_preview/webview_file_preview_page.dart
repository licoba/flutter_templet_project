//
//  WebviewFilePreviewPage.dart
//  yl_health_app
//
//  Created by shang on 2023/9/19 16:24.
//  Copyright © 2023/9/19 shang. All rights reserved.
//


import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/cache/cache_asset_service.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/vendor/easy_toast.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:share_plus/share_plus.dart';


/// 网页加载
class WebviewFilePreviewPage extends StatefulWidget {

  WebviewFilePreviewPage({
    Key? key,
    required this.url,
    this.title,
  }) : assert(url.startsWith("http")),
        super(key: key);

  final String url;

  final String? title;

  @override
  _WebviewFilePreviewPageState createState() => _WebviewFilePreviewPageState();
}

class _WebviewFilePreviewPageState extends State<WebviewFilePreviewPage> {

  final  _progressVN = ValueNotifier(0.0);


  @override
  Widget build(BuildContext context) {
    final initialUrl = widget.url;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? '详情'),
        actions: [
          IconButton(
            onPressed: onShare,
            icon: Icon(Icons.more_horiz, color: Colors.black87,),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(3),
          child: ValueListenableBuilder<double>(
            valueListenable: _progressVN,
            builder: (context, value, child){

              final indicatorColor = value >= 1.0 ? Colors.transparent : primaryColor;

              return LinearProgressIndicator(
                value: value,
                color: indicatorColor,
                backgroundColor: Colors.transparent,
              );
            }
          ),
        ),
      ),
      body: SafeArea(
        child: WebView(
          initialUrl: initialUrl,
          javascriptMode: JavascriptMode.unrestricted,
          onProgress: (int progress) {
            debugPrint("progress: $progress");
            _progressVN.value = progress/100;
          },
          onPageStarted: (String url) {
            debugPrint("onPageStarted $url");
          },
          onPageFinished: (String url) {
            debugPrint("onPageFinished $url");
            _progressVN.value = 1;
          },
        ),
      ),
    );
  }

  onShare() async {
    Directory tempDir = await CacheAssetService().getDir();
    var tmpPath = '${tempDir.path}/${widget.title}';

    final percentVN = ValueNotifier(0.0);

    EasyToast.showLoading(
      "文件下载中",
      indicator: ValueListenableBuilder<double>(
        valueListenable: percentVN,
        builder: (context,  value, child){

          return CircularProgressIndicator(
            value: value,
          );
        }
      )
    );

    final response = await Dio().download(widget.url, tmpPath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            final percent = (received / total);
            final percentStr = "${(percent * 100).toStringAsFixed(0)}%";
            percentVN.value = percent;
            debugPrint("percentStr: $percentStr");
          }
        }
    );
    // debugPrint("response: ${response.data}");
    debugPrint("tmpPath: ${tmpPath}");
    EasyToast.hideLoading();

    Share.shareXFiles([XFile(tmpPath)]);
  }

}
