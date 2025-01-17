//
//  NnSliverPersistentHeaderDelegate.dart
//  flutter_templet_project
//
//  Created by shang on 2/3/23 6:05 PM.
//  Copyright © 2/3/23 shang. All rights reserved.
//

import 'package:flutter/material.dart';


class NSliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  NSliverPersistentHeaderDelegate({
    // Key? key,
    this.min = 48,
    this.max = 80,
    required this.builder,
  });
  /// 默认 48 是 TabBar 的默认高度
   double min;
   double max;

   Widget Function(BuildContext context, double offset, bool overlapsContent) builder;

  
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return builder(context, shrinkOffset, overlapsContent);
  }

  //SliverPersistentHeader最大高度
  @override
  double get maxExtent => max;

  //SliverPersistentHeader最小高度
  @override
  double get minExtent => min;

  @override
  bool shouldRebuild(covariant NSliverPersistentHeaderDelegate oldDelegate) {
    return min != oldDelegate.min || max != oldDelegate.max || builder != oldDelegate.builder;
  }
}

/// SliverPersistentHeader
class NSliverPersistentHeader extends StatelessWidget {

  const NSliverPersistentHeader({
  	Key? key,
  	this.title,
    this.pinned = true,
    this.floating = false,
    this.min = 48,
    this.max = 80,
    required this.builder,
  }) : super(key: key);

  final String? title;

  final bool pinned;

  final bool floating;

  final double min;

  final double max;

  final Widget Function(BuildContext context, double offset, bool overlapsContent) builder;


  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: pinned,
      floating: floating,
      delegate: NSliverPersistentHeaderDelegate(
        min: min,
        max: max,
        builder: builder,
      ),
    );
  }
}

