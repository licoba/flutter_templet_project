//
//  Singleton.dart
//  flutter_templet_project
//
//  Created by shang on 11/30/21 6:37 PM.
//  Copyright © 11/30/21 shang. All rights reserved.
//

class Singleton {
  // 静态变量指向自身
  static final Singleton _instance = Singleton._();
  // 私有构造器
  Singleton._();

  // 方案1：工厂构造方法获得实例变量
  factory Singleton() => _instance;
  // 方案2：静态属性获得实例变量
  static Singleton get instance => _instance;
  // 方案3：静态方法获得实例变量
  static Singleton getInstance() => _instance;
}

class SharedInstance {
  // 私有构造函数
  SharedInstance._();

  // 静态私有成员，没有初始化
  static SharedInstance? _instance;

  // 静态、同步、私有访问点
  static SharedInstance _sharedInstance() {
    _instance ??= SharedInstance._();
    return _instance!;
  }

  // 单例公开访问点
  factory SharedInstance() => _sharedInstance();

  static SharedInstance? get instance => _sharedInstance();
}
