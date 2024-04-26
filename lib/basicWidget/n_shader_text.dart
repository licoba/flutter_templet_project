import 'package:flutter/material.dart';


/// @author[yilian]
/// @version[创建日期，2024/4/7 10:20]
/// @function[渐变文字效果 ]

class ShaderText extends StatelessWidget {
  const ShaderText({
    super.key,
    this.hasShader = false,
    this.colors = const [
      Colors.transparent,
      Colors.transparent,
      Colors.white,
    ],
    required this.child,
  });

  /// 是否展开  - 展开隐藏渐变色，用于档案多行文本
  final bool hasShader;
  /// 渐变色
  final List<Color> colors;
  /// 子text组件
  final Widget child;


  @override
  Widget build(BuildContext context) {
    if (hasShader) {
      return child;
    }

    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          colors: colors,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          tileMode: TileMode.clamp,
        ).createShader(bounds);
      },
      blendMode: BlendMode.srcATop,
      child: child,
    );
  }
}
