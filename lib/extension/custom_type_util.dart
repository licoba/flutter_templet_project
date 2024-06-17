//
//  TypeUtil.dart
//  flutter_templet_project
//
//  Created by shang on 2023/10/16 10:01.
//  Copyright © 2023/10/16 shang. All rights reserved.
//

import 'package:flutter/material.dart';

typedef GenericWidgetBuilder<T> = Widget Function(
    BuildContext context, T generic);

typedef VoidCallbackWidgetBuilder = Widget Function(
    BuildContext context, VoidCallback cb);

typedef ValueChangedWidgetBuilder<T> = Widget Function(
    BuildContext context, ValueChanged<T> onChanged);

/// 一个两个元素的元祖;
/// e 泛型数据;
/// action 事件回调;
typedef ActionRecord<T> = ({T e, VoidCallback action});
