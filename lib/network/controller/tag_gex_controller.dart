//
//  TagApiController.dart
//  flutter_templet_project
//
//  Created by shang on 2024/4/4 08:24.
//  Copyright © 2024/4/4 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/model/tag_detail_model.dart';
import 'package:flutter_templet_project/network/api/tag_clear_api.dart';
import 'package:flutter_templet_project/network/api/tag_list_api.dart';
import 'package:flutter_templet_project/network/api/tag_set_api.dart';
import 'package:flutter_templet_project/vendor/toast_util.dart';
import 'package:get/get.dart';

/// 标签管理器
class TagGetxController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    // ddlog("$this 初始化");
    debugPrint("");
    // 监听count的值,当它发生改变的时候调用
    ever(count, (callback) => ddlog("ever----$count"));

    // 监听多个值,当它们发生改变的时候调用
    everAll([count], (callback) => ddlog("everAll----$count"));

    // count值改变时调用,只执行一次
    once(count, (callback) => ddlog("once----$count"));

    // 用户停止打字时1秒后调用,主要是防DDos
    debounce(count, (callback) => ddlog("debounce----$count"));

    // 忽略3秒内的所有变动
    interval(count, (callback) => ddlog("interval----$count"));
  }

  @override
  void onReady() {
    super.onReady();
    // ddlog("$this 加载完成");
    debugPrint("");
  }

  @override
  void onClose() {
    super.onClose();
    // ddlog("$this 控制器被释放");
    debugPrint("");
  }

  var count = 0.obs;

  void updateCount({
    required ValueChanged<Rx<int>> onUpdate,
    List<Object>? ids,
    bool condition = true,
  }) {
    onUpdate(count);
    update(ids, condition);
  }

  void increment() {
    count++;
    update();
    // update(['jimi_count']);
  }

  /// 标签列表
  List<TagDetailModel> _list = [];
  List<TagDetailModel> get list => _list;
  set list(List<TagDetailModel> value) {
    if (_list == value) {
      return;
    }
    _list = value;
    update();
  }

  /// 新增或者编辑标签操作是否成功
  bool _isUpdate = false;
  bool get isUpdate => _isUpdate;
  set isUpdate(bool value) {
    if (_isUpdate == value) {
      return;
    }
    _isUpdate = value;
    update();
  }

  /// 查
  @override
  Future<void> update([List<Object>? ids, bool condition = true]) async {
    if (!Get.isRegistered<TagGetxController>()) {
      return;
    }
    super.update(ids, condition);
  }

  /// 获取标签
  Future<({bool isSuccess, String message, List<TagDetailModel> result})>
      requestTagList({
    required String departmentId,
  }) async {
    var api = TagListApi(
      departmentId: departmentId,
    );

    // var tuple = await api.fetchList<T>(
    //   onList: (respone){
    //     final result = List<Map<String, dynamic>>.from(response["result"]
    //     ?? []);
    //     return result.map((e) => TagDetailModel.fromJson(e) as T).toList();
    //   },
    // );

    var tuple = await api.fetchModels(
      onValue: (response) =>
          List<Map<String, dynamic>>.from(response["result"] ?? []),
      onModel: (json) => TagDetailModel.fromJson(json), //dart 泛型传递有问题,必须声明一下
    );
    list = tuple.result;
    return tuple;
  }

  /// 更新标签
  Future<({bool isSuccess, String message, bool result})> requestUpdateTag({
    required List<TagDetailModel> selectTags,
    required String? userId,
  }) async {
    final tagIds = selectTags.map((e) => e.id ?? "").toList();
    var departmentId = "";

    final api = tagIds.isEmpty
        ? TagClearApi(
            userId: userId,
            departmentId: departmentId,
          )
        : TagSetApi(
            tagsId: tagIds,
            userId: userId,
            departmentId: departmentId,
          );
    final tuple = await api.fetchBool(hasLoading: true);
    if (tuple.isSuccess == false) {
      ToastUtil.show(tuple.message);
    }
    isUpdate = tuple.isSuccess && tuple.result;
    return tuple;
  }
}
