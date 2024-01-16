//
//  FileExt.dart
//  flutter_templet_project
//
//  Created by shang on 2024/1/16 11:50.
//  Copyright © 2024/1/16 shang. All rights reserved.
//


import 'dart:io';

extension FileExt on File {


}

extension FileIntExt on int{
  /// length 转为 MB 描述
  String get fileSizeDesc {
    final result = this/(1024 *1024);
    final desc = "${result.toStringAsFixed(2)}MB";
    return desc;
  }

  /// 压缩质量( )
  int get compressQuality {
    int length = this;
    // var quality = 100;
    const mb = 1024 * 1024;
    if (length > 10 * mb) {
      return 20;
    }

    if (length > 8 * mb) {
      return 30;
    }

    if (length > 6 * mb) {
      return 40;
    }

    if (length > 4 * mb) {
      return 50;
    }

    if (length > 2 * mb) {
      return 60;
    }
    return 90;
  }
}