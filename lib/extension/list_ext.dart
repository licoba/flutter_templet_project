//
//  ListExtension.dart
//  flutter_templet_project
//
//  Created by shang on 10/21/21 10:11 AM.
//  Copyright © 10/21/21 shang. All rights reserved.
//

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';

extension ListExt<T, E> on List<E> {
  // static bool isEmpty(List? val) {
  //   return val == null || val.isEmpty;
  // }
  //
  // static bool isNotEmpty(List? val) {
  //   return val != null && val.isNotEmpty;
  // }

  ///运算符重载
  List<E> operator *(int value) {
    var l = <E>[];
    for (var i = 0; i < value; i++) {
      l.addAll([...this]);
    }
    return l;
  }

  /// 获取随机元素
  E? get randomOne {
    if (isEmpty) {
      return null;
    }
    final index = Random().nextInt(length);
    final e = elementAt(index);
    return e;
  }

  /// 查询符合条件元素,没有则返回为空
  E? find(bool Function(E) test) {
    for (final element in this) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }

  /// 倒叙查询符合条件元素
  E? findLast(bool Function(E) test) {
    for (var i = length - 1; i >= 0; i--) {
      final element = this[i];
      if (test(element)) {
        return element;
      }
    }
    return null;
  }

  /// 查询符合条件元素,没有则返回为空
  E? firstWhere(bool Function(E) test) => find(test);

  /// 倒叙查询符合条件元素
  E? lastWhere(bool Function(E) test) => findLast(test);

  /// 查询符合条件元素,没有则返回为空
  int? findIndex(bool Function(E) test) {
    for (var i = 0; i <= length - 1; i++) {
      final element = this[i];
      if (test(element)) {
        return i;
      }
    }
    return null;
  }

  /// 倒叙查询符合条件元素
  int? findLastIndex(bool Function(E) test) {
    for (var i = length - 1; i >= 0; i--) {
      final element = this[i];
      if (test(element)) {
        return i;
      }
    }
    return null;
  }

  /// 查询符合条件元素,没有则返回为空
  int? indexWhere(bool Function(E) test) => findIndex(test);

  /// 倒叙查询符合条件元素
  int? lastIndexWhere(bool Function(E) test) => findLastIndex(test);

  /// 所有元素都满足需求(回调返回第一个不满足需求的元素)
  bool every(bool Function(E) test, {ValueChanged<E>? cb}) {
    for (final element in this) {
      if (!test(element)) {
        cb?.call(element);
        return false;
      }
    }
    return true;
  }

  /// 移除数组空值
  List<E> removeNull() {
    var val = this;
    val.removeWhere((e) => e == null);
    final result = val.whereType<E>().toList();
    return result;
  }

  /// 用多个元素取代数组中满足条件的第一个元素
  /// replacements 取代某个元素的集合
  /// isReversed 是否倒序查询
  List<E> replace(
    bool Function(E) test, {
    required List<E> replacements,
    bool isReversed = false,
  }) {
    final target = !isReversed ? firstWhere(test) : findLast(test);
    if (target == null) {
      return this;
    }
    return replaceTarget(target, replacements: replacements);
  }

  /// 用多个元素取代数组中某个元素
  /// replacements 取代某个元素的集合
  List<E> replaceTarget(
    E target, {
    required List<E> replacements,
  }) {
    final index = indexOf(target);
    if (index != -1) {
      replaceRange(index, index + 1, replacements);
    }
    return this;
  }

  /// 数组降维() expand
  // List<T> flatMap(List<T> action(E e)) {
  // var result = <T>[];
  // this.forEach((e) {
  //   result.addAll(action(e));
  // });
  // return result;
  // }

  /// 同 sorted
  List<E> sorted([int Function(E a, E b)? compare]) {
    sort(compare);
    return this;
  }

  /// 根据值排序
  void sortByValue({
    bool ascending = true,
    required num? Function(E e) cb,
  }) {
    sort((a, b) {
      final aValue = cb(a);
      final bValue = cb(b);
      if (ascending) {
        if (aValue == null || bValue == null) {
          return 1;
        }
        return aValue.compareTo(bValue);
      }

      if (aValue == null || bValue == null) {
        return -1;
      }
      return bValue.compareTo(aValue);
    });
  }

  /// 根据值排序
  List<E> sortedByValue({
    bool ascending = true,
    required num? Function(E e) cb,
  }) {
    sortByValue(ascending: ascending, cb: cb);
    return this;
  }

  List<E> exchange(int fromIdx, int toIdx) {
    if (fromIdx >= length || toIdx >= length) {
      return this;
    }
    var e = this[fromIdx];
    var toE = this[toIdx];
    //exchange
    this[fromIdx] = toE;
    this[toIdx] = e;
    return this;
  }

  /// 递归遍历
  recursion(void Function(E e)? cb) {
    forEach((item) {
      cb?.call(item);
      recursion(cb);
    });
  }

  // /// 转为 Map<String, dynamic>
  // Map<String, E> toMap() {
  //   var map = <String, E>{};
  //   for (final item in this) {
  //     map["$item"] = item;
  //   }
  //   return map;
  // }
}

extension ListExtObject<E extends Object> on List<E> {
  // List<E> sortedByKey(String key, {bool ascending = true}) {
  //   this.forEach((element) {
  //     print("sortByKey:${element}");
  //   });
  //   if (ascending) {
  //     this.sort((a, b) => a[key].compareTo(b[key]));
  //   } else {
  //     this.sort((a, b) => b[key].compareTo(a[key]));
  //   }
  //   return this;
  // }

  List<E> sortedByValue(
      {bool ascending = true, required dynamic Function(E obj) cb}) {
    if (ascending) {
      // this.sort((a, b) => cb(a).compareTo(cb(b)));
      sort((a, b) => _customeCompare(cb(a), cb(b)));
    } else {
      // this.sort((a, b) => cb(b).compareTo(cb(a)));
      sort((a, b) => _customeCompare(cb(b), cb(a)));
    }
    return this;
  }

  /// 处理字符串中包含数字排序异常的问题
  _customeCompare(dynamic a, dynamic b) {
    if (a is String && b is String) {
      return a.compareCustom(b);
    }
    return a.compareTo(b);
  }
}

extension IterableExt<E> on Iterable<E> {
  /// 动态值
  E operator [](int index) {
    final i = index.clamp(0, length);
    return this[i];
  }

  /// 动态复制
  void operator []=(int index, E? val) {
    final i = index.clamp(0, length);
    this[i] = val;
  }

  // /// 重新
  // E? get firstNBew {
  //   var it = iterator;
  //   if (!it.moveNext()) {
  //     return null;
  //   }
  //   return it.current;
  // }
  //
  // E? get last {
  //   var it = iterator;
  //   if (!it.moveNext()) {
  //     return null;
  //   }
  //   E result;
  //   do {
  //     result = it.current;
  //   } while (it.moveNext());
  //   return result;
  // }

  // double sum(double Function(T) cb) {
  //   var result = 0.0;
  //   for (final e in this) {
  //     result += cb(e);
  //   }
  //   return result;
  // }

  // Iterable<T> filter() {
  //   return whereType<T>();
  // }
}

extension ListNullExt<E> on List<E?> {
  /// 移除数组空值
  List<E> removeNull() {
    var val = this;
    val.removeWhere((e) => e == null);
    final result = val.whereType<E>().toList();
    return result;
  }
}
