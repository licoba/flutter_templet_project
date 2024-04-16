

import 'dart:convert';

import 'package:flutter_templet_project/cache/cache_service.dart';
import 'package:flutter_templet_project/network/base_request_api.dart';
import 'package:flutter_templet_project/vendor/toast_util.dart';

// https://doc.yljt.cn/docs/platform//5242

/// 【通用】管理设置患者标签
class TagSetApi extends BaseRequestAPI{

  TagSetApi({
    required this.tagsId,
    this.ownerId,
    this.ownerType,
    this.diseaseDepartmentId,
    this.agencyId,
  });

  /// 标签ID
  List<String> tagsId;
  /// 对象ID
  String? ownerId;
  /// 对象类型，患者：PUBLIC_USER ，医生：DOCTOR
  String? ownerType;
  // 医生传 diseaseDepartmentId,护工传agencyId
  String? agencyId;
  /// 机构ID，执业版调用传医生所在的科室ID
  String? diseaseDepartmentId;

  @override
  String get requestURI{
    const url = 'api/yft/disease_course/setTags';
    return url;
  }

  @override
  HttpMethod get requestType => HttpMethod.POST;

  @override
  Map<String, dynamic> get requestParams{
    final map = <String, dynamic>{};
    map["tagsId"] = tagsId;

    if (ownerId != null) {
      map["ownerId"] = ownerId;
    }
    if (ownerType != null) {
      map["ownerType"] = ownerType;
    }

    map["agencyId"] = diseaseDepartmentId;
    return map;
  }

  bool get validateParamsOld {
    if (tagsId.isEmpty) {
      ToastUtil.info('标签ID 不能为空');
      return false;
    }
    if (ownerId == null) {
      ToastUtil.info('对象ID 不能为空');
      return false;
    }
    if (ownerType == null) {
      ToastUtil.info('对象类型 不能为空');
      return false;
    }

    return true;
  }

}