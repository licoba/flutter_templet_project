//
//  app_update_model.dart
//  flutter_templet_project
//
//  Created by shang on 5/19/21 5:34 PM.
//  Copyright © 5/19/21 shang. All rights reserved.
//

///升级模型
class AppUpdateItemModel {
  const AppUpdateItemModel({
    this.appIcon = "-",
    this.appSize = "-",
    this.appName = "-",
    this.appDate = "-",
    this.appDescription = "-",
    this.appVersion = "-",
    this.isShowAll = false,
  });

  /// App图标
  final String appIcon;

  /// App名称
  final String appName;

  /// App大小
  final String appSize;

  /// App更新日期
  final String appDate;

  /// App更新文案
  final String appDescription;

  /// App版本
  final String appVersion;

  /// App更新文案
  final bool isShowAll;
}

///升级模型
class AppModel {
  AppModel({
    this.appIcon = "-",
    this.appSize = "-",
    this.appName = "-",
    this.appDate = "-",
    this.appDescription = "-",
    this.appVersion = "-",
    this.isShowAll = false,
  });

  /// App图标
  String appIcon;

  /// App名称
  String appName;

  /// App大小
  String appSize;

  /// App更新日期
  String appDate;

  /// App更新文案
  String appDescription;

  /// App版本
  String appVersion;

  /// App更新文案
  bool isShowAll;

  static AppModel? fromJson(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    return AppModel(
      appIcon: map["appIcon"].toString(),
      appSize: map["appSize"].toString(),
      appName: map["appName"].toString(),
      appDate: map["appDate"].toString(),
      appDescription: map["appDescription"].toString(),
      appVersion: map["appVersion"].toString(),
      isShowAll: map["isShowAll"] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "appIcon": appIcon,
      "appSize": appSize,
      "appName": appName,
      "appDate": appDate,
      "appDescription": appDescription,
      "appVersion": appVersion,
      "isShowAll": isShowAll,
    };
  }

  Object? operator [](String key) {
    final map = toJson();
    final result = map[key];
    return result;
  }

  void operator []=(String key, dynamic value) {
    switch (key) {
      case "appName":
        appName = value;
        break;
      case "appIcon":
        appIcon = value;
        break;
      case "appSize":
        appSize = value;
        break;
      case "appDate":
        appDate = value;
        break;
      case "appDescription":
        appDescription = value;
        break;
      case "appVersion":
        appVersion = value;
        break;
      case "isShowAll":
        isShowAll = value;
        break;
      default:
        break;
    }
  }
}
