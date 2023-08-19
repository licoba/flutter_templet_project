
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/basicWidget/upload/asset_upload_config.dart';
import 'package:flutter_templet_project/basicWidget/upload/asset_upload_model.dart';
import 'package:flutter_templet_project/basicWidget/upload/image_service.dart';
import 'package:flutter_templet_project/extension/num_ext.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';


/// 上传图片单元(基于 wechat_assets_picker)
class AssetUploadButton extends StatefulWidget {

  AssetUploadButton({
    Key? key,
    required this.model,
    this.urlBlock,
    this.onDelete,
    this.radius = 8,
    // this.isFinished = false,
    this.showFileSize = false,
  }) : super(key: key);

  final AssetUploadModel model;

  /// 上传成功获取 url 回调
  final ValueChanged<String>? urlBlock;
  /// 返回删除元素的 id
  final VoidCallback? onDelete;
  /// 圆角 默认8
  final double radius;

  /// 显示文件大小
  final bool showFileSize;

  // bool isFinished;

  @override
  _AssetUploadButtonState createState() => _AssetUploadButtonState();
}

class _AssetUploadButtonState extends State<AssetUploadButton> with AutomaticKeepAliveClientMixin {
  /// 防止触发多次上传动作
  var _isLoading = false;
  /// 请求成功或失败
  final _successVN = ValueNotifier(true);
  /// 上传进度
  final _percentVN = ValueNotifier(0.0);


  @override
  void initState() {
    super.initState();

    onRefresh();
  }

  @override
  void didUpdateWidget(covariant AssetUploadButton oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (widget.model.entity.id == oldWidget.model.entity.id) {
      // BrunoUtil.showInfoToast("path相同");
      return;
    }
    // if (widget.model.url == "") {
    //   // BrunoUtil.showInfoToast("path相同");
    //   return;
    // }
    // onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // final futureWidget = NFutureBuilder<File?>(
    //   future: widget.entity.file,
    //   builder: (file) {
    //     return Image.file(
    //       File(file?.path ?? ""),
    //       fit: BoxFit.cover,
    //     );
    //   },
    //   loadingBuilder: (){
    //     return Image(image: "img_placehorder.png".toAssetImage());
    //   },
    // );

    var imgChild = ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(widget.radius)),
      child: Padding(
        padding: EdgeInsets.only(top: 0, right: 0),
        child: widget.model.file != null ? Image.file(
            File(widget.model.file?.path ?? ""),
            fit: BoxFit.cover,
          ) : Image(image: "img_placehorder.png".toAssetImage(),
        ),
      ),
    );
    
    return Stack(
      fit: StackFit.expand,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 10, right: 10),
          child: imgChild,
        )
            // .toColoredBox()
        ,
        if(widget.model.url == null || widget.model.url == "")Positioned(
          top: 0,
          right: 0,
          bottom: 0,
          left: 0,
          child: buildUploading(),
        ),
        if (widget.showFileSize) Positioned(
          top: 0,
          right: 0,
          bottom: 0,
          left: 0,
          child: buildFileSizeInfo(length: widget.model.file?.lengthSync(),),
        ),
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
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        constraints: BoxConstraints(),
        onPressed: widget.onDelete,
        icon: const Icon(Icons.cancel, color: Colors.red,),
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
        if (value >= 1) {
          return const SizedBox();
        }
        return Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(top: 10, right: 10),
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
              if(widget.model.file != null && (widget.model.file!.lengthSync() > 2 * 1024 * 1024) == true)NText(
                data: value.toStringAsPercent(2),
                fontSize: 12.sp,
                color: Colors.white,
              ),
              NText(
                data: "上传中",
                fontSize: 12.sp,
                color: Colors.white,
              ),
            ],
          ),
        );
      }
    );
  }

  Widget buildUploadFail() {
    return Stack(
      children: [
        InkWell(
          onTap: (){
            debugPrint("onTap");
            onRefresh();
          },
          child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 10, right: 10),
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.all(Radius.circular(widget.radius)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.refresh, color: Colors.red),
                NText(
                  data: "点击重试",
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
    required String filePath,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final url = AssetUploadConfig.uploadUrl;
    assert(url.startsWith("http"), "请设置上传地址");

    final formData = FormData.fromMap({
      'files': await MultipartFile.fromFile(filePath),
    });
    final response = await Dio().post<Map<String, dynamic>>(
      url,
      data: formData,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
    final res = response.data ?? {};
    final result = res['result'];
    return result;
  }
  
  onRefresh() {
    // debugPrint("onRefresh ${widget.entity}");
    if (_isLoading) {
      debugPrint("_isLoading: $_isLoading ${widget.model.entity}");
      return;
    }
    _isLoading = true;
    _successVN.value = true;

    // final entityFile = widget.isOriginFile ? widget.model.entity.originFile : widget.model.entity.file;
    final entityFile = widget.model.entity.file;
    entityFile.then((file) {
      if (file == null) {
        throw "文件为空";
      }
      return ImageService().compressAndGetFile(file);
    }).then((file) {
      if (file == null) {
        throw "文件为空";
      }
      widget.model.file = file;
      setState(() {});

      final path = widget.model.file?.path;
      if (path == null) {
        throw "文件路径为空";
      }
      // return "";//调试代码,勿删!!!
      return uploadFile(
        filePath: path,
        onSendProgress: (int count, int total){
          _percentVN.value = (count/total);
          // debugPrint("${count}/${total}_${_percentVN.value}_${_percentVN.value.toStringAsPercent(2)}");
      });
    }).then((value) {
      final url = value;
      if (url == null || url.isEmpty) {
        _successVN.value = false;
        throw "上传失败 ${widget.model.file?.path}";
      }
      _successVN.value = true;
      widget.model.url = url;
    }).catchError((err){
      debugPrint("err: $err");
      widget.model.url = "";
      _successVN.value = false;
    }).whenComplete(() {
      _isLoading = false;
      widget.urlBlock?.call(widget.model.url ?? "");
    });
  }

  Widget buildFileSizeInfo({required int? length}) {
    if (length == null) {
      return SizedBox();
    }
    final result = length/(1024 *1024);
    final desc = "${result.toStringAsFixed(2)}MB";
    return Align(
      child: Container(
        color: Colors.red,
        child: Text(desc)
      )
    );
  }

  
  @override
  bool get wantKeepAlive => true;
}