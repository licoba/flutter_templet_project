//
//  ImageExtension.dart
//  flutter_templet_project
//
//  Created by shang on 9/15/22 7:02 PM.
//  Copyright © 9/15/22 shang. All rights reserved.
//


import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

// import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

extension UIImageExt on ui.Image {
  /// ui.Image 类型转 Uint8List
  FutureOr<Uint8List?> toUint8List({
    ui.ImageByteFormat format = ui.ImageByteFormat.png,
    // Exception? exception
  }) async {
    ByteData? byteData = await this.toByteData(format: format);
    // if (byteData == null) throw exception ?? Exception('toByteData 数据为空');
    final bytes = byteData?.buffer.asUint8List();
    return bytes;
  }

  /// 获取文件在内存中的大小
  FutureOr<String?> fileSize(
      {ui.ImageByteFormat format = ui.ImageByteFormat.png}) async {
    ByteData? byteData = await this.toByteData(format: format);
    final result = byteData?.fileSize();
    // print("imageSize: ${result}");
    return result;
  }
}

extension ImageExt on Image {
  static FutureOr<Uint8List?> imageDataFromUrl({
    required String imageUrl,
    ui.ImageByteFormat format = ui.ImageByteFormat.png,
  }) async {
    Image img = Image.network(imageUrl);

    ImageInfo imgInfo = await img.image.getImageInfo();

    Uint8List? uint8List = await imgInfo.image.toUint8List();
    return uint8List;
  }
}

extension ImageProviderExt on ImageProvider {
  /// return Future<ImageInfo>
  Future<ImageInfo> getImageInfo({
    ImageConfiguration configuration = const ImageConfiguration(),
  }) async {
    final completer = Completer<ImageInfo>();
    this.resolve(configuration).addListener(
      ImageStreamListener((ImageInfo info, bool _) async {
          completer.complete(info);
          this.evict();
        },
        onError: (Object exception, StackTrace? stackTrace) {
          completer.completeError(exception, stackTrace);
          this.evict();
        },
      ),
    );
    return completer.future;
  }
}

extension ByteDataExt on ByteData {
  /// 获取文件在内存中的大小
  String fileSize() {
    final bytes = this.buffer.lengthInBytes;
    if (bytes == 0) {
      throw Exception("获取文件字节失败");
    }

    final kb = bytes / 1024;
    final mb = kb / 1024;

    final result = kb > 1024 ? mb.toStringAsFixed(2) + 'MB' : kb.toStringAsFixed(0) + "kb";
    // print("imageSize: ${result}");
    return result;
  }
}

extension ImageChunkEventExt on ImageChunkEvent {
  // 当前百分比进度(0 - 1)
  double? get current {
    if (this.expectedTotalBytes == null) {
      return null;
    }
    final double result = this.cumulativeBytesLoaded / this.expectedTotalBytes!;
    return result;
  }
}


extension ImageCacheExt on ImageCache {

  /// PaintingBinding.instance?.imageCache?.clear();
  static clear() {
    PaintingBinding.instance?.imageCache?.clear();
  }

  /// PaintingBinding.instance?.imageCache?.clearLiveImages();
  static clearLiveImages() {
    PaintingBinding.instance?.imageCache?.clearLiveImages();
  }

  /// evict
  static bool evict(Object key, { bool includeLive = true }) {
    return (PaintingBinding.instance?.imageCache?.evict(key, includeLive: includeLive) == true);
  }

  /// evict images
  static evictImages(List<String> urls) {
    urls.forEach((e) {
      Object key = NetworkImage(e, scale: 1.0,);
      PaintingBinding.instance?.imageCache?.evict(key, includeLive: true);
    });
  }
}
