//
//  AssetUploadDocumentButton.dart
//  yl_health_app
//
//  Created by shang on 2023/04/30 11:19.
//  Copyright © 2023/04/30 shang. All rights reserved.
//

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/basicWidget/upload_document/asset_upload_document_model.dart';
import 'package:flutter_templet_project/enum/FileType.dart';
import 'package:flutter_templet_project/extension/num_ext.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/network/oss/oss_util.dart';
import 'package:get/get.dart';

/// 上传图片单元(基于 wechat_assets_picker)
class AssetUploadDocumentButton extends StatefulWidget {
  const AssetUploadDocumentButton({
    super.key,
    required this.model,
    this.width,
    this.height,
    this.radius = 4,
    this.urlBlock,
    this.onDelete,
    this.canEdit = true,
    this.showFileSize = false,
  });

  final AssetUploadDocumentModel model;

  /// 宽度
  final double? width;

  /// 高度
  final double? height;

  /// 圆角 默认8
  final double radius;

  /// 上传成功获取 url 回调
  final ValueChanged<String>? urlBlock;

  /// 返回删除元素的 id
  final VoidCallback? onDelete;

  /// 显示文件大小
  final bool showFileSize;

  /// 是否可编辑 - 删除
  final bool canEdit;

  @override
  AssetUploadDocumentButtonState createState() =>
      AssetUploadDocumentButtonState();
}

class AssetUploadDocumentButtonState extends State<AssetUploadDocumentButton>
    with AutomaticKeepAliveClientMixin {
  /// 防止触发多次上传动作
  var _isLoading = false;

  /// 请求成功或失败
  final _successVN = ValueNotifier(true);

  /// 上传进度
  final _percentVN = ValueNotifier(0.0);

  String? get filePath => widget.model.file?.path;

  String? get fileName => filePath?.split("/").last;

  @override
  void initState() {
    super.initState();

    onRefresh();
  }

  @override
  void didUpdateWidget(covariant AssetUploadDocumentButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model.file?.path == oldWidget.model.file?.path ||
        widget.model.url == oldWidget.model.url) {
      // EasyToast.showInfoToast("path相同");
      return;
    }
    onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final fileName =
        (widget.model.file?.path ?? widget.model.url)?.split("/").last ?? "";
    final fileType = IMFileType.values
            .firstWhereOrNull((e) => fileName.endsWith(e.name) == true) ??
        IMFileType.unknow;
    Widget img = FractionallySizedBox(
      heightFactor: 0.75,
      child: Image(
        image: fileType.iconName.toAssetImage(),
        width: widget.width,
        height: widget.height,
      ),
    );

    var imgChild = ClipRRect(
      borderRadius: BorderRadius.circular(widget.radius),
      child: img,
    );

    return Stack(
      fit: StackFit.expand,
      children: [
        imgChild,
        if (widget.model.url?.startsWith("http") == false)
          Positioned(
            top: 0,
            right: 0,
            bottom: 0,
            left: 0,
            child: buildUploading(),
          ),
        if (widget.showFileSize)
          Positioned(
            top: 0,
            right: 0,
            bottom: 0,
            left: 0,
            child: buildFileSizeInfo(
              length: widget.model.file?.lengthSync(),
            ),
          ),
        if (widget.canEdit)
          Positioned(
            top: 0,
            right: 0,
            child: buildDelete(),
          ),
      ],
    );
  }

  /// 右上角删除按钮
  Widget buildDelete() {
    if (widget.onDelete == null) {
      return const SizedBox();
    }
    return Container(
      width: widget.width! * .26,
      height: widget.width! * .26,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.3),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(widget.radius),
          bottomLeft: Radius.circular(widget.radius),
        ),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        onPressed: widget.onDelete,
        icon: Icon(Icons.close, size: widget.width! * .15, color: Colors.white),
      ),
    );
  }

  Widget buildUploading() {
    return AnimatedBuilder(
        animation: Listenable.merge([
          _successVN,
          _percentVN,
        ]),
        builder: (context, child) {
          if (_successVN.value == false) {
            return buildUploadFail();
          }
          final value = _percentVN.value;
          // LogUtil.d("${fileName}_percentVN: ${_percentVN.value}");
          if (value >= 1) {
            return const SizedBox();
          }
          return Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.all(Radius.circular(widget.radius)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // if (value <= 0)NText(
                //   data: "处理中",
                //   fontSize: 14,
                //   color: Colors.white,
                // ),
                if (widget.model.file != null &&
                    (widget.model.file!.lengthSync() > 2 * 1024 * 1024) == true)
                  NText(
                    value.toStringAsPercent(2),
                    fontSize: 12,
                    color: Colors.white,
                  ),
                const NText(
                  "上传中",
                  fontSize: 12,
                  color: Colors.white,
                ),
              ],
            ),
          );
        });
  }

  Widget buildUploadFail() {
    return Stack(
      children: [
        InkWell(
          onTap: () {
            debugPrint("onTap");
            onRefresh();
          },
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.all(Radius.circular(widget.radius)),
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.refresh, color: Colors.red),
                NText(
                  "点击重试",
                  fontSize: 14,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: buildDelete(),
        ),
      ],
    );
  }

  Future<String?> uploadFile({
    required String path,
  }) async {
    var res = await OssUtil.upload(
      filePath: path,
      onSendProgress: (int count, int total) {
        final percent = (count / total);
        if (percent >= 0.99) {
          _percentVN.value = 0.99;
        }
      },
      onReceiveProgress: (int count, int total) {
        _percentVN.value = 1;
      },
      needCompress: false,
    );
    if (res?.startsWith("http") == true) {
      // debugPrint("res: $res");
      _percentVN.value = 1;
      return res;
    }
    return null;
  }

  onRefresh() {
    // debugPrint("onRefresh ${widget.entity}");
    final entityFile = widget.model.file;
    if (entityFile == null || widget.model.url?.startsWith("http") == true) {
      return;
    }

    if (_isLoading) {
      debugPrint("_isLoading: $_isLoading ${widget.model.file?.path}");
      return;
    }

    _isLoading = true;
    _successVN.value = true;

    setState(() {});

    final path = entityFile.path;
    // return "";//调试代码,勿删!!!
    uploadFile(
      path: path,
    ).then((value) {
      final url = value;
      if (url == null || url.isEmpty) {
        _successVN.value = false;
        throw "上传失败 ${widget.model.file?.path}";
      }
      _successVN.value = true;
      widget.model.url = url;
    }).catchError((err) {
      debugPrint("err: $err");
      widget.model.url = "";
      _successVN.value = false;

      setState(() {});
    }).whenComplete(() {
      _isLoading = false;
      // LogUtil.d("${fileName}_whenComplete");
      widget.urlBlock?.call(widget.model.url ?? "");
    });
  }

  Widget buildFileSizeInfo({required int? length}) {
    if (length == null) {
      return const SizedBox();
    }
    final result = length / (1024 * 1024);
    final desc = "${result.toStringAsFixed(2)}MB";
    return Align(child: Container(color: Colors.red, child: Text(desc)));
  }

  @override
  bool get wantKeepAlive => true;
}
