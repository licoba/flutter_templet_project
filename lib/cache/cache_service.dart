
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_templet_project/model/tag_detail_model.dart';
import 'package:flutter_templet_project/network/RequestConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 请求环境信息缓存
const String CACHE_REQUEST_ENV = "CACHE_REQUEST_ENV";

const String CACHE_REQUEST_ENV_DEV_ORIGIN = "CACHE_REQUEST_ENV_DEV_ORIGIN";

/// 请求错误缓存
const String CACHE_REQUEST_ERROR = "CACHE_REQUEST_ERROR";

/// 缓存app 名称
const String CACHE_APP_NAME = "CACHE_APP_NAME"; // 医链执业版
/// 缓存app 版本号
const String CACHE_APP_VERSION = "CACHE_APP_VERSION"; // 1.0.0
/// 缓存app 包名 - com.yilian.ylHealthApp
const String CACHE_APP_PACKAGE_NAME = "CACHE_APP_PACKAGE_NAME";

const String CACHE_TOKEN = "CACHE_TOKEN";

/// 缓存用户登录账号
const String CACHE_USER_LOGIN_NAME = "USER_LOGIN_NAME";
/// 缓存用户登录账号密码
const String CACHE_USER_LOGIN_PWD = "USER_LOGIN_PWD";

/// 用户信息 key
const String CACHE_USER_ID = "CACHE_USER_ID";

const String CACHE_TAG_ROOT_MODEL = "CACHE_TAG_ROOT_MODEL";



class CacheService {

  CacheService._() {
    init();
  }

  static final CacheService _instance = CacheService._();

  factory CacheService() => _instance;

  static CacheService get shard => _instance;

  SharedPreferences? prefs;

  init() async {
    prefs ??= await SharedPreferences.getInstance();
    // debugPrint("init prefs: $prefs");
  }

  /// memory cache, 内存缓存
  final _memoryMap = <String, dynamic>{};

  /// 清除数据
  Future<bool>? remove(String key) {
    return prefs?.remove(key);
  }

  /// 动态值
  Object? operator [](String key){
    final val = prefs?.get(key);
    return val;
  }

  /// 动态复制
  void operator []=(String key, String? val){
    if (val == null) {
      return;
    }
    prefs?.setString(key, val);
  }

  /// 泛型获取值
  void set<T>(String key, T? value) {
    if (value == null) {
      return;
    }
    switch (T) {
      case String:
        prefs?.setString(key, value as String);
        break;
      case int:
        prefs?.setInt(key, value as int);
        break;
      case bool:
        prefs?.setBool(key, value as bool);
        break;
      case double:
        prefs?.setDouble(key, value as double);
        break;
      case Map:
      case List:
        try {
          var jsonStr = jsonEncode(value);
          prefs?.setString(key, jsonStr);
        } catch (e) {
          debugPrint("$this $e");
        }
        break;
    }
  }

  /// 泛型获取值
  T? get<T>(String key) {
    var value = prefs?.get(key);
    if (value == null) {
      return null;
    }
    if (value is! String) {
      return value as T?;
    }

    try {
      var result = jsonDecode(value);
      return result;
    } catch (e) {
      return value as T?;
    }
  }


  setStringList(String key, List<String>? value) {
    if (value == null) {
      return;
    }
    prefs?.setStringList(key, value);
  }

  List<String>? getStringList(String key) {
    return prefs?.getStringList(key);
  }

  setString(String key, String? value) {
    if (value == null) {
      return;
    }
    prefs?.setString(key, value);
  }


  String? getString(String key) {
    final result = prefs?.getString(key);
    return result;
  }

  setDouble(String key, double? value) {
    if (value == null) {
      return;
    }
    prefs?.setDouble(key, value);
  }

  double? getDouble(String key) {
    return prefs?.getDouble(key);
  }

  setInt(String key, int? value) {
    if (value == null) {
      return;
    }
    prefs?.setInt(key, value);
  }

  int? getInt(String key) {
    return prefs?.getInt(key);
  }

  setBool(String key, bool? value) {
    if (value == null) {
      return;
    }
    prefs?.setBool(key, value);
  }

  bool? getBool(String key) {
    return prefs?.getBool(key);
  }

  setMap(String key, Map<String, dynamic>? value) {
    if (value == null) {
      return;
    }
    try {
      final jsonStr = jsonEncode(value);
      setString(key, jsonStr);
    } catch (e) {
      debugPrint("$this $e");
    }
  }

  Map<String, dynamic>? getMap(String key) {
    var value = prefs?.getString(key);
    if (value == null) {
      return null;
    }
    Map<String, dynamic>? map = <String, dynamic>{};
    try {
      map = jsonDecode(value) as Map<String, dynamic>?;
    } catch (e) {
      debugPrint("getMap${e.toString()}");
    }
    return map;
  }

  /// 标签
  set tagsRootModel(TagsRootModel? model) {
    if (model == null) {
      return;
    }
    _memoryMap[CACHE_TAG_ROOT_MODEL] = model.toJson();
    CacheService().setMap(CACHE_TAG_ROOT_MODEL, model.toJson());
  }

  TagsRootModel? get tagsRootModel {
    final val = _memoryMap[CACHE_TAG_ROOT_MODEL];
    final json = val ?? CacheService().getMap(CACHE_TAG_ROOT_MODEL);
    if (json == null) {
      return null;
    }
    final model = TagsRootModel.fromJson(json);
    return model;
  }
}


extension CacheServiceExt on CacheService {

  /// 清除缓存数据
  Future<bool>? clear() async {
    final env = CacheService().getString(CACHE_REQUEST_ENV);

    final isClear = await prefs?.clear();
    debugPrint("isClear: $isClear");

    CacheService().setString(CACHE_REQUEST_ENV, env);

    return Future.value(true);
  }

  Future<void> noClear(List<String> keys, VoidCallback onDone) async {
    final tuples = keys.map((key) {
      final value = CacheService().getString(key);
      return (key, value);
    });

    onDone();

    tuples.forEach((e) {
      CacheService().set(e.$1, e.$2);
    });
  }

  List<String> get noClearKeys {
    return [
      CACHE_REQUEST_ENV,
    ];
  }

  /// 清除登录环境
  clearEnv() {
    CacheService().remove(CACHE_REQUEST_ENV);
  }

  /// 设置登录环境
  set env(APPEnvironment? val) {
    if (val == null) {
      return;
    }
    final result = val.toString();
    CacheService().setString(CACHE_REQUEST_ENV, result);
  }

  /// 获取登录环境
  APPEnvironment? get env {
    final result = CacheService().getString(CACHE_REQUEST_ENV);
    final val = APPEnvironment.fromString(result);
    return val;
  }

  /// 设置登录环境 dev 下的域名
  set devOrigin(String? val) {
    if (val == null || val.isEmpty) {
      return;
    }
    CacheService().setString(CACHE_REQUEST_ENV_DEV_ORIGIN, val);
  }

  /// 获取登录环境 dev 下的域名
  String? get devOrigin {
    return CacheService().getString(CACHE_REQUEST_ENV_DEV_ORIGIN);
  }


  /// 医链执业版
  String? get appName {
    return CacheService().getString(CACHE_APP_NAME);
  }

  /// 1.0.0
  String? get appVersion {
    return CacheService().getString(CACHE_APP_VERSION);
  }

  /// com.yilian.ylHealthApp
  String? get packageName {
    return CacheService().getString(CACHE_APP_PACKAGE_NAME);
  }

  /// 设置 token
  set token(String? val) {
    if (val == null || val.isEmpty) {
      return;
    }
    CacheService().setString(CACHE_TOKEN, val);
  }

  /// 获取token
  String? get token {
    return CacheService().getString(CACHE_TOKEN);
  }

  /// 是否是登录状态
  bool get isLogin {
    final token = CacheService().token ?? "";
    final result = token.isNotEmpty;
    return result;
  }

  /// 设置登录账号
  set loginId(String? val) {
    if (val == null || val.isEmpty) {
      return;
    }
    CacheService().setString(CACHE_USER_LOGIN_NAME, val);
  }

  /// 获取登录账号
  String? get loginId {
    return CacheService().getString(CACHE_USER_LOGIN_NAME);
  }

  /// 设置 登录账号密码
  set loginPwd(String? val) {
    if (val == null || val.isEmpty) {
      return;
    }
    CacheService().setString(CACHE_USER_LOGIN_PWD, val);
  }

  /// 获取登录账号密码
  String? get loginPwd {
    return CacheService().getString(CACHE_USER_LOGIN_PWD);
  }

  /// 获取用户id
  String? get userID {
    return CacheService().getString(CACHE_USER_ID);
  }

}