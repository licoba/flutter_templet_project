//
//  buildContext_extension.dart
//  flutter_templet_project
//
//  Created by shang on 10/14/21 2:21 PM.
//  Copyright © 10/14/21 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extensions/ddlog.dart';

extension BuildContextExt on BuildContext {

  ///扩展方法
  void logRendBoxInfo() {
    RenderObject? renderObject = this.findRenderObject();
    if (renderObject == null || renderObject is! RenderBox) {
      return;
    }
    RenderBox box = renderObject;
    Offset origin = box.localToGlobal(Offset.zero);
    print([DateTime.now(), origin, box.size]);
  }

  /// 扩展属性 Theme.of(this.context)
  get theme => Theme.of(this);
  /// 扩展属性 MediaQuery.of(this.context)
  get mediaQuery => MediaQuery.of(this);
  /// 扩展属性 MediaQuery.of(this.context).size
  get screenSize => mediaQuery.size;
  /// 扩展属性 MediaQuery.of(this).devicePixelRatio
  get devicePixelRatio => mediaQuery.devicePixelRatio;

  // 有刘海的屏幕:44 没有刘海的屏幕为20
  get statusBarHeight => mediaQuery.padding.top;
  // 有刘海的屏幕:34 没有刘海的屏幕0
  get bottomHeight => mediaQuery.padding.bottom;

  get scaffoldMessenger => ScaffoldMessenger.of(this);

  showSnackBar(SnackBar snackBar, [bool isReplace = false]) {
    if (isReplace) {
      // scaffoldMessenger.hideCurrentSnackBar();
      scaffoldMessenger.clearSnackBars();
    }
    this.scaffoldMessenger.showSnackBar(snackBar);
  }
}

extension StatefulWidgetExt<T extends StatefulWidget> on State<T> {
  /// 扩展属性 Theme.of(this.context)
  get theme => this.context.theme;
  /// 扩展属性 MediaQuery.of(this.context)
  get mediaQuery => this.context.mediaQuery;
  /// 扩展属性 MediaQuery.of(this.context).size
  get screenSize => this.context.screenSize;
  /// 扩展属性 MediaQuery.of(this).devicePixelRatio
  get devicePixelRatio => this.context.devicePixelRatio;

  /// 扩展属性 ScaffoldMessenger.of(this.context);
  get scaffoldMessenger => this.context.scaffoldMessenger;
  /// 扩展方法
  showSnackBar(SnackBar snackBar, [bool isReplace = false]) => this.context.showSnackBar(snackBar, isReplace);
}

// extension StatefulWidgetExt<T extends StatefulWidget> on State<T> {
//   /// 扩展属性 ScaffoldMessenger.of(this.context);
//   get scaffoldMessenger => ScaffoldMessenger.of(this.context);
//   /// 扩展方法
//   void showSnackBar(SnackBar snackBar, [bool isReplace = false]) {
//     if (isReplace) {
//       // scaffoldMessenger.hideCurrentSnackBar();
//       scaffoldMessenger.clearSnackBars();
//     }
//     scaffoldMessenger.showSnackBar(snackBar);
//   }
//
//   /// 扩展属性 Theme.of(this.context)
//   get theme => Theme.of(this.context);
//   /// 扩展属性 MediaQuery.of(this.context)
//   get mediaQuery => MediaQuery.of(this.context);
//   /// 扩展属性 MediaQuery.of(this.context).size
//   get screenSize => MediaQuery.of(this.context).size;
// }


// showSnackBar({
//   required BuildContext context,
//   required SnackBar snackBar,
//   bool isReplace = false
// }) {
//   final scaffoldMessenger = ScaffoldMessenger.of(context);
//   if (isReplace) {
//     scaffoldMessenger.hideCurrentSnackBar();
//   }
//   scaffoldMessenger.showSnackBar(snackBar);
// }

// extension SnackBarExt on SnackBar {
//
//   void showBy(BuildContext context, [bool isReplace = false]) {
//     if (isReplace) {
//       context.scaffoldMessenger.hideCurrentSnackBar();
//     }
//     context.scaffoldMessenger.showSnackBar(this);
//   }
// }


// extension SmartIterable<T> on Iterable<T> {
//   void doTheSmartThing(void Function(T) smart) {
//     for (var e in this) smart(e);
//   }
// }
// extension SmartList<T> on List<T> {
//   void doTheSmartThing(void Function(T) smart) {
//     for (int i = 0; i < length; i++) smart(this[i]);
//   }
// }