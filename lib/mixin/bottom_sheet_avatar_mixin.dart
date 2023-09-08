//
//  BottomSheetAvatarMixin.dart
//  yl_health_app
//
//  Created by shang on 2023/9/8 11:03.
//  Copyright © 2023/9/8 shang. All rights reserved.
//


import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_templet_project/basicWidget/n_overlay.dart';
import 'package:flutter_templet_project/basicWidget/upload/image_service.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';


/// 头像更换(回调返回单张图片的路径)
/// 默认图片压缩,图片裁剪
mixin BottomSheetAvatarMixin<T extends StatefulWidget> on State<T> {
  // 相册选择器
  final ImagePicker _picker = ImagePicker();

  // 更新头像
  updateAvatar({
    bool needCropp = true,
    required Function(String? path)? cb,
  }) {
    final titles = ['拍摄', '从相册选择'];

    CupertinoActionSheet(
      actions: titles.map((e) {
        return CupertinoActionSheetAction(
          onPressed: () {
            Navigator.of(context).pop();
            if (e == titles[0]) {
              handleImageFromCamera(needCropp: needCropp, cb: cb);
            } else {
              handleImageFromXiangce(needCropp: needCropp, cb: cb);
            }
          },
          child: Text(e),
        );
      }).toList(),
      cancelButton: CupertinoActionSheetAction(
        isDestructiveAction: true,
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text('取消'),
      ),
    ).toShowCupertinoModalPopup(context: context);
  }

  handleImageFromCamera({
    bool needCropp = true,
    required Function(String? path)? cb,
  }) async {
    final file = await _takePhoto();
    if (file == null) {
      NOverlay.showToast(message: '请重新拍摄', context: context,);
      return null;
    }

    // EasyToast.showLoading("图片处理中...");

    final compressImageFile = await file.toCompressImage();
    if (!needCropp) {
      // EasyToast.hideLoading();
      return compressImageFile;
    }

    final cropImageFile = await compressImageFile.toCropImage();
    // EasyToast.hideLoading();

    final path = cropImageFile.path;
    return path;
  }

  handleImageFromXiangce({
    bool needCropp = true,
    required Function(String? path)? cb,
  }) async {
    final file = await _chooseAvatarByWechatPicker();
    if (file == null) {
      NOverlay.showToast(message: '请重新选择', context: context,);
      return null;
    }
    // EasyToast.showLoading("图片处理中...");

    final compressImageFile = await file.toCompressImage();
    if (!needCropp) {
      // EasyToast.hideLoading();
      return compressImageFile;
    }

    final cropImageFile = await compressImageFile.toCropImage();
    // EasyToast.hideLoading();
    if (!needCropp) {
      return compressImageFile;
    }

    final path = cropImageFile.path;
    cb?.call(path);
  }

  /// 拍照
  Future<File?> _takePhoto() async {
    try {
      final file = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
      );
      if (file == null) {
        return null;
      }
      var fileNew = File(file.path);
      return fileNew;
    } catch (err) {
      openAppSettings();
    }
    return null;
  }

  /// 通过微信相册选择器选择头像
  Future<File?> _chooseAvatarByWechatPicker() async {
    var maxCount = 1;

    final entitys = await AssetPicker.pickAssets(
      context,
      pickerConfig: AssetPickerConfig(
        requestType: RequestType.image,
        specialPickerType: SpecialPickerType.noPreview,
        selectedAssets: [],
        maxAssets: maxCount,
      ),
    ) ?? [];

    if (entitys.isEmpty) {
      return null;
    }
    final item = entitys[0];
    final file = await item.file;
    if (file == null) {
      return null;
    }
    return file;
  }

}
