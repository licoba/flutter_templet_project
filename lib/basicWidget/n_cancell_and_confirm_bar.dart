

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/uti/color_uti.dart';


class NCancellAndConfirmBar extends StatelessWidget {

  NCancellAndConfirmBar({
  	Key? key,
  	this.title,
    this.height = 48,
    this.cancellTitle = "取消",
    this.confirmTitle = "确定",
    this.bottomLeftRadius = const Radius.circular(8),
    this.bottomRightRadius = const Radius.circular(8),
    required this.onCancell,
    required this.onConfirm,
    this.cancellBgColor = bgColor,
    this.confirmBgColor = Colors.blueAccent,
    this.cancellTextStyle,
    this.confirmTextStyle,
  }) : super(key: key);

  String? title;

  double height;
  String cancellTitle;
  String confirmTitle;
  Radius bottomLeftRadius;
  Radius bottomRightRadius;
  VoidCallback? onCancell;
  VoidCallback? onConfirm;
  Color cancellBgColor = bgColor;
  Color confirmBgColor = Colors.blueAccent;
  TextStyle? cancellTextStyle;
  TextStyle? confirmTextStyle;

  @override
  Widget build(BuildContext context) {
    return buildCancellAndConfirmBar();
  }

  buildCancellAndConfirmBar(
  //  {
  //   double height = 48,
  //   String cancellTitle = "取消",
  //   String confirmTitle = "确定",
  //   Radius bottomLeft = const Radius.circular(4),
  //   Radius bottomRight = const Radius.circular(4),
  //   VoidCallback? onCancell,
  //   VoidCallback? onConfirm,
  //   Color cancellBgColor = bgColor,
  //   Color confirmBgColor = primary,
  //   TextStyle? cancellTextStyle,
  //   TextStyle? confirmTextStyle,
  // }
  ) {
    return Material(
      color: Colors.red,
      borderRadius: BorderRadius.only(
          bottomLeft: bottomLeftRadius,
          bottomRight: bottomRightRadius
      ),
      child: SizedBox(
        height: height,
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: onCancell,
                child: Container(
                  decoration: BoxDecoration(
                    color: cancellBgColor,
                    borderRadius: BorderRadius.only(bottomLeft: bottomLeftRadius)
                  ),
                  child: Center(
                    child: Text(cancellTitle,
                      style: cancellTextStyle ?? TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: fontColor[20],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: onConfirm,
                child: Container(
                  decoration: BoxDecoration(
                    color: confirmBgColor,
                    borderRadius: BorderRadius.only(bottomRight: bottomRightRadius)
                  ),
                  child: Center(
                    child: Text(confirmTitle,
                      style: confirmTextStyle ?? TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}