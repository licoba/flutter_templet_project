//
//  RichTextDemo.dart
//  flutter_templet_project
//
//  Created by shang on 7/31/21 12:11 PM.
//  Copyright © 7/31/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_section_header.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/extension/rich_text_ext.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';
import 'package:tuple/tuple.dart';

class RichTextDemo extends StatefulWidget {
  final String? title;

  const RichTextDemo({Key? key, this.title}) : super(key: key);

  @override
  _RichTextDemoState createState() => _RichTextDemoState();
}

class _RichTextDemoState extends State<RichTextDemo> {
  var linkMap = {
    '《用户协议》': 'https://flutter.dev',
    '《隐私政策》': 'https://flutter.dev',
    '您的': 'https://flutter.dev',
  };

  String text = """
        亲爱的xxxx用户，感谢您信任并使用xxxxAPP！
xxxx十分重视用户权利及隐私政策并严格按照相关法律法规的要求，对《用户协议》和《隐私政策》进行了更新,特向您说明如下：
        1.为向您提供更优质的服务，我们会收集、使用必要的信息，并会采取业界先进的安全措施保护您的信息安全；
        2.基于您的明示授权，我们可能会获取设备号信息、包括：设备型号、操作系统版本、设备设置、设备标识符、MAC（媒体访问控制）地址、IMEI（移动设备国际身份码）、广告标识符（“IDFA”与“IDFV”）、集成电路卡识别码（“ICCD”）、软件安装列表。我们将使用三方产品（友盟、极光等）统计使用我们产品的设备数量并进行设备机型数据分析与设备适配性分析。（以保障您的账号与交易安全），且您有权拒绝或取消授权；
        3.您可灵活设置伴伴账号的功能内容和互动权限，您可在《隐私政策》中了解到权限的详细应用说明；
        4.未经您同意，我们不会从第三方获取、共享或向其提供您的信息；
        5.您可以查询、更正、删除您的个人信息，我们也提供账户注销的渠道。
        请您仔细阅读并充分理解相关条款，其中重点条款已为您黑体加粗标识，方便您了解自己的权利。如您点击“同意”，即表示您已仔细阅读并同意本《用户协议》及《隐私政策》，将尽全力保障您的合法权益并继续为您提供优质的产品和服务。如您点击“不同意”，将可能导致您无法继续使用我们的产品和服务。
""";

  late final textSpans = <TextSpan>[
    TextSpan(
      text: '红色',
      style: TextStyle(fontSize: 18.0, color: Colors.red),
    ),
    TextSpan(
      text: '绿色',
      style: TextStyle(fontSize: 18.0, color: Colors.green),
    ),
    TextSpan(
      text: '蓝色',
      style: TextStyle(fontSize: 18.0, color: Colors.blue),
    ),
    TextSpan(
      text: '白色',
      style: TextStyle(fontSize: 18.0, color: Colors.orange),
    ),
    TextSpan(
      text: '紫色',
      style: TextStyle(fontSize: 18.0, color: Colors.purple),
    ),
    TextSpan(
      text: '黑色',
      style: TextStyle(fontSize: 18.0, color: Colors.black),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: [
          TextButton(
            onPressed: () {
              matchRegExp();
            },
            child: Text(
              "done",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            children: [
              NSectionHeader(
                title: "buildRichText",
                child: buildRichText().toBorder(),
              ),
              NSectionHeader(
                title: "buildWidgetSpan",
                child: buildWidgetSpan(),
              ),
              NSectionHeader(
                title: "richTextWid04",
                child: richTextWid04(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRichText() {
    return Container(
      // padding: EdgeInsets.all(12),
      child: Text.rich(
        TextSpan(
          children: RichTextExt.createTextSpans(
            text: text,
            textTaps: linkMap.keys.toList(),
            // linkStyle: TextStyle(fontSize: 18.0, color: Colors.red),
            onLink: (textTap) {
              ddlog(textTap);
            },
          ),
        ),
        // style: TextStyle(
        //   wordSpacing: 12
        // ),
        strutStyle: StrutStyle(
          leading: 0.4,
        ),
      ),
    );
  }

  /// 图文混排
  Widget buildWidgetSpan() {
    return Text.rich(TextSpan(
      children: <InlineSpan>[
        TextSpan(text: '图文混排 '),
        TextSpan(text: 'Flutter is'),
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: SizedBox(
            width: 120,
            height: 40,
            child: Card(
                color: Colors.blue,
                child: Center(child: Text('Hello World!'))),
          ),
        ),
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: SizedBox(
            child: FlutterLogo(
              size: 40,
            ),
          ),
        ),
        TextSpan(text: 'the best!'),
      ],
    ));
  }

  Widget richTextWid04() {
    return RichText(
      text: TextSpan(
        text: '多种样式，如：',
        style: TextStyle(fontSize: 16.0, color: Colors.black),
        children: textSpans.map((e) => e.copyWith(onLink: onLink,)).toList(),
      ),
      textAlign: TextAlign.center,
    );
  }

  void matchRegExp() {
    final reg = RegExp(r'《[^《》]+》', multiLine: true).allMatches(text);
    final list = reg.map((e) => e.group(0)).toList();
    ddlog(list);

    final result = text.allMatchesByReg(RegExp(r'《[^《》]+》', multiLine: true));
    ddlog(result);

    var prefix = "《";
    var suffix = "》";
    final origin = '$prefix[^$prefix$suffix]+$suffix';
    ddlog(text.allMatchesByReg(RegExp(origin)));

    var str3 = '''
  Multi
  Line
  String
  ''';

    final result1 = str3.splitMapJoin(
        RegExp(r'^', multiLine: true), // Matches the beginning of the line
        onMatch: (m) => '** ${m.group(0)}', // Adds asterisk to match
        onNonMatch: (n) => n); // Just return non-matches
    debugPrint(result1);

    var s = 'bezkoder';
    ddlog(s.padLeft(10)); // '  bezkoder'
    ddlog(s.padLeft(10, ' ')); // '==bezkoder'

    ddlog(s.padRight(12)); // 'bezkoder  '
    ddlog(s.padRight(12, '=')); // 'bezkoder=='
  }

  void onLink(String? text) {
    debugPrint("onTap: $text");
  }
}
