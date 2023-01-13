//
//  RadialGradientButton.dart
//  flutter_templet_project
//
//  Created by shang on 2023/1/12 22:03.
//  Copyright © 2023/1/12 shang. All rights reserved.
//

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_templet_project/pages/demo/LayoutBuilderDemo.dart';

/// 雷达渐进色按钮
class RadialGradientButton extends StatefulWidget {

  RadialGradientButton({
    Key? key,
    required this.text,
    // required this.colors,
    // required this.stops,
    this.margin = const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
    this.padding = const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
    this.center = Alignment.center,
    this.onClick,
  }) : super(key: key);

  Text text;
  // List<Color> colors;
  // List<double>? stops;

  EdgeInsets? margin;
  EdgeInsets? padding;
  Alignment center;
  GestureTapCallback? onClick;

  @override
  _RadialGradientButtonState createState() => _RadialGradientButtonState();
}

class _RadialGradientButtonState extends State<RadialGradientButton> {

  var _scale = 0.5;

  Size? _currentSize;

  @override
  void initState() {
    SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
      if (context.size?.width == null || context.size?.height == null) {
        return;
      }
      _currentSize = context.size;

      // double horizontal = (widget.margin?.left ?? 0.0) + (widget.margin?.right ?? 0.0);
      // double vertical = (widget.margin?.top ?? 0.0) + (widget.margin?.bottom ?? 0.0);
      // double width = context.size!.width > horizontal ? context.size!.width - horizontal : 0;
      // double height = context.size!.height > vertical ? context.size!.height - vertical : 0;
      double w = context.size!.width;
      double h = context.size!.height;
      _scale = radiusOfRadialGradient(
          width: w,
          height: h,
          alignment: widget.center,
      );
      print("context.size:${context.size} ${_scale}");
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onClick,
      child: Container(
        margin: widget.margin,
        padding: widget.padding,
        decoration: BoxDecoration(
          gradient: _currentSize == null ? null : RadialGradient(
            // tileMode: TileMode.mirror,
            radius: _scale,
            center: widget.center,
            colors: <Color>[
              Colors.red, // blue
              Colors.blue,
              Colors.yellow,
            ],
            stops: const <double>[0.0, 0.5, 0.8],
          ),
        ),
        child: widget.text,
      ),
    );
  }

  /// 获取雷达渐进色 radius
  double radiusOfRadialGradient({
    double? width = 0,
    double? height = 0,
    Alignment alignment = Alignment.center,
    double defaultValue = 0.5,
  }) {
    if(width == null || height == null
        || width <= 0 || height <= 0) {
      return defaultValue;
    }

    final max = math.max(width, height);
    final min = math.min(width, height);
    double result = max/min;
    if (alignment.x != 0) {
      result *= 2.0;
    }
    return result;
  }
}

