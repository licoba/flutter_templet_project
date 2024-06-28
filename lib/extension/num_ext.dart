//
//  NumExtension.dart
//  lib
//
//  Created by shang on 11/29/21 3:38 PM.
//  Copyright © 11/29/21 shang. All rights reserved.
//

import 'dart:math';

// import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension NumExt on num {}

extension IntExt on int {
  static int random({int min = 0, required int max}) {
    return min + Random().nextInt(max - min);
  }

  /// 随机布尔值
  static bool randomBool() {
    final result = Random().nextInt(2) == 1;
    return result;
  }

  String toHanzi() {
    if (this == 0) return '零';

    final List<String> chineseDigits = '零一二三四五六七八九'.split("").toList();
    final List<String> chineseUnits = '十百千万亿'.split("").toList();

    String result = '';
    int unitIndex = 0;
    int number = this;

    while (number > 0) {
      int digit = number % 10;
      result = (digit == 0 ? '' : chineseDigits[digit]) +
          chineseUnits[unitIndex] +
          result;
      unitIndex++;
      number ~/= 10;
    }

    // 处理连续的零
    result = result
        .replaceAllMapped(RegExp('零+'), (match) => '零')
        .replaceAll(RegExp('^零|零\$'), '');

    return result;
  }

  /// 生成随机字符串
  String generateChars({String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"}) {
    if (this == 0) {
      return "";
    }
    int length = this;
    var tmp = "";
    for (var i = 0; i < length; i++) {
      var randomIndex = IntExt.random(max: chars.length);
      var randomChar = chars[randomIndex];
      tmp += randomChar;
    }
    return tmp;
  }

// /// 数字格式化
// String numFormat([String? newPattern = '0,000', String? locale]) {
//   final fmt = NumberFormat(newPattern, locale);
//   return fmt.format(this);
// }
}

extension DoubleExt on double {
  /// 2位小数
  double get fixed2 => double.parse(toStringAsFixed(2));

  /// 3位小数
  double get fixed3 => double.parse(toStringAsFixed(3));

  /// 转为百分比描述
  String toStringAsPercent(int fractionDigits) {
    if (this >= 1.0) {
      return "100%";
    }
    final result = toStringAsFixed(fractionDigits);
    var percentDes = "${result.replaceAll("0.", "")}%";
    if (percentDes.startsWith("0")) {
      percentDes = percentDes.substring(1);
    }
    return percentDes;
  }
}
