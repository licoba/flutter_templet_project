//
//  BottomSheetAvatarMixin.dart
//  yl_health_app
//
//  Created by shang on 2023/9/8 11:03.
//  Copyright © 2023/9/8 shang. All rights reserved.
//


import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/basicWidget/upload/image_service.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';
import 'package:flutter_templet_project/util/permission_util.dart';
import 'package:flutter_templet_project/util/get_util.dart';
import 'package:flutter_templet_project/vendor/easy_toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tuple/tuple.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';


/// 头像更换(回调返回单张图片的路径)
/// 默认图片压缩,图片裁剪
mixin BottomSheetImageMixin<T extends StatefulWidget> on State<T> {
  /// 展示图片选择菜单
  /// needCropp 是否需要裁剪(仅在 maxCount == 1 时有效)
  /// maxCount 最大张数
  chooseImage({
    int maxCount = 9,
    bool needCropp = false,
    required ValueChanged<File> onChanged,
  }) {
    GetSheet.showSheetActions(
        actions: [
          Tuple2(0, NText('拍摄', ),),
          Tuple2(1, NText('从相册选择', ),),
        ],
        onItem: (tag) {
          if (tag == 0) {
            takePhoto(
              needCropp: needCropp,
              onChanged: onChanged,
            );
          } else {
            // chooseImagesByImagePicker(
            //   isFile: isFile,
            //   onChanged: onChanged,
            // );

            chooseImagesByWechatPicker(
              maxCount: maxCount,
              needCropp: needCropp,
              onChanged: onChanged,
            );
          }
        }
    );
  }

  // 更新头像
  updateAvatar({
    int maxCount = 1,
    bool needCropp = false,
    required ValueChanged<File> onChanged,
  }) {
    final titles = ['拍摄', '从相册选择'];

    CupertinoActionSheet(
      actions: titles.map((e) {
        return CupertinoActionSheetAction(
          onPressed: () {
            Navigator.of(context).pop();
            if (e == titles[0]) {
              takePhoto(needCropp: needCropp, onChanged: onChanged);
            } else {
              chooseImagesByWechatPicker(needCropp: needCropp, onChanged: onChanged, maxCount: 1);
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


  /// 拍照
  /// needCropp 是否需要裁剪(仅在 maxCount == 1 时有效)
  /// onChanged 回调
  Future<File?> takePhoto({
    bool needCropp = false,
    required ValueChanged<File> onChanged,
  }) async {
    try {
      bool isGranted = await PermissionUtil.checkCamera();
      if (!isGranted) {
        return null;
      }

      // 打开相机
      final _picker = ImagePicker();
      final xfile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
      );
      if (xfile == null) {
        // BrunoUtil.showToast('程序异常,请重新拍摄');
        return null;
      }

      var file = File(xfile.path);
      final compressFile = await file.toCompressImage();
      if (!needCropp) {
        // int length = await compressFile.length();
        onChanged(compressFile);
        return compressFile;
      }

      final cropFile = await compressFile.toCropImage();

      // int length = await cropFile.length();
      onChanged(cropFile);
      return cropFile;
    } catch (err) {
      openAppSettings();
    }
    return null;
  }

  // /// 通过 ImagePicker 库选择图片
  // chooseImagesByImagePicker({
  //   int maxCount = 9,
  //   double limit = 5,
  //   required ValueChanged<File> onChanged,
  // }) async {
  //   try {
  //     bool isGranted = await PhonePermission.checkPhotoAlbum();
  //     if (!isGranted) {
  //       return;
  //     }
  //     List<XFile> images = [];
  //     if (maxCount == 1) {
  //       final XFile? xfile = await _picker.pickImage(
  //         source: ImageSource.gallery,
  //       );
  //       if (xfile == null) {
  //         return;
  //       }
  //       images.add(xfile);
  //     } else {
  //       images = await _picker.pickMultiImage(
  //         imageQuality: 50,
  //       );
  //     }
  //
  //     if (images.isEmpty) return;
  //     if (images.length > maxCount) {
  //       BrunoUtil.showToast('最多上传$maxCount张图片');
  //       return;
  //     }
  //
  //     images.map((item) async {
  //       File file = File(item.path);
  //       final fileNew = await file.toCompressImage();
  //       final imagePath = fileNew.path;
  //
  //       int length = await fileNew.length();
  //       bool isLimit = length > limit * 1024 * 1024;
  //       if (isLimit) {
  //         final fileSizeInfo = (length/1024/1024).toStringAsFixed(2);
  //         debugPrint("fileSizeInfo: $imagePath ${fileSizeInfo}M");
  //         BrunoUtil.showToast('图片体积超出限制, 请重新选择');
  //         return;
  //       }
  //       onChanged(file);
  //     }).toList();
  //   } catch (err) {
  //     openAppSettings();
  //   }
  // }

  /// 通过微信相册选择器选择图片
  /// needCropp 是否需要裁剪(仅在 maxCount == 1 时有效)
  /// maxCount 最大张数
  /// limit 图片大小限制(MB)
  chooseImagesByWechatPicker({
    bool needCropp = false,
    maxCount = 9,
    limit = 5,
    required ValueChanged<File> onChanged,
  }) async {
    bool isGranted = await PermissionUtil.checkPhotoAlbum();
    if (!isGranted) {
      return;
    }

    if (!mounted) {
      return;
    }

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
      return;
    }
    if (entitys.length > maxCount) {
      EasyToast.showToast('最多上传$maxCount张图片');
      return;
    }

    if (maxCount == 1 && needCropp) {
      final file = await entitys[0].file;
      if (file == null) {
        EasyToast.showToast('图片路径为空');
        return;
      }
      // EasyToast.showLoading("图片处理中...");
      final fileNew = await file.toCropImage();
      // EasyToast.hideLoading();

      // int length = await fileNew.length();
      //
      // final imagePath = fileNew.path;
      onChanged(fileNew);
      return;
    }

    entitys.map((item) async {
      final file = await item.file;
      // final imagePath = file?.path;
      if (file == null) {
        EasyToast.showToast('图片路径为空');
        return;
      }
      var fileNew = await ImageService().compressAndGetFile(file);
      final imagePath = fileNew.path;

      var length = await fileNew.length();
      var isLimit = length > limit * 1024 * 1024;
      if (isLimit) {
        final fileSizeInfo = (length/1024/1024).toStringAsFixed(2);
        debugPrint("fileSizeInfo: $imagePath ${fileSizeInfo}M");
        EasyToast.showToast('图片体积超出限制, 请重新选择');
        return;
      }
      onChanged(fileNew);
    }).toList();
  }
  

}
