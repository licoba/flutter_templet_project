//
//  RequestError.dart
//  flutter_templet_project
//
//  Created by shang on 2023/11/16 11:10.
//  Copyright © 2023/11/16 shang. All rights reserved.
//


enum RequestError{
  unknown("未知错误"),
  jsonError("JSON解析错误"),
  paramsError("参数错误"),
  urlError("请求链接异常"),
  timeout("请求超时。"),
  networkError("网络错误，请稍后再试"),
  notNetwork("无法连接到网络"),
  serverError("服务器响应超时，请稍后再试"),
  cancel("取消网络请求");

  const RequestError(this.desc);
  final String desc;
}