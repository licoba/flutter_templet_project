//
//  NTransformTheme.dart
//  flutter_templet_project
//
//  Created by shang on 2024/8/8 10:14.
//  Copyright © 2024/8/8 shang. All rights reserved.
//

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/basicWidget/n_transform_view.dart';
import 'package:flutter_templet_project/cache/file_manager.dart';
import 'package:flutter_templet_project/extension/date_time_ext.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/extension/snack_bar_ext.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

/// 属性元祖
typedef PropertyRecord = ({String name, String type, String comment});

class ConvertTheme extends StatefulWidget {
  ConvertTheme({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<ConvertTheme> createState() => _ConvertThemeState();
}

class _ConvertThemeState extends State<ConvertTheme> {
  bool get hideApp =>
      Get.currentRoute.toLowerCase() != "/$widget".toLowerCase();

  Map<String, dynamic> arguments = Get.arguments ?? <String, dynamic>{};

  /// id
  late final id = arguments["id"];

  final transformViewController = NTransformViewController();

  late final actionItems = <({String name, VoidCallback action})>[
    (name: "Generate", action: onGenerate),
    (name: "Paste", action: onPaste),
    (name: "Clear", action: onClear),
  ];

  final themeTemplet = """
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yl_health_app/extension/string_ext.dart';
import 'package:yl_health_app/routers/navigator_util.dart';
import 'package:yl_health_app/util/color_util_new.dart';
import 'package:yl_health_app/widget/common/my_icon.dart';
import 'package:yl_health_app/widget/common/my_text.dart';

///自定义顶部appBar
class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({
    Key? key,
    this.title = '',
    this.centerTitle = true,
    this.rightActions,
    this.backgroundColor = white,
    this.mainColor = fontColor,
    this.titleW,
    this.titleSpacing,
    this.bottom,
    this.leading,
    this.leadingWidth,
    this.flexibleSpace,
    this.leadingImg = '',
    this.leadingVisible = true,
    this.brightness = Brightness.dark,
    this.overlayStyle = SystemUiOverlayStyle.dark,
    this.automaticallyImplyLeading = true,
    this.elevation = 0,
    this.toolbarHeight = 48,
    this.backClick,
  }) : super(key: key);

  final String title;
  final bool centerTitle; //标题是否居中，默认居中
  final List<Widget>? rightActions;
  final Color? backgroundColor;//背景色
  final Color? mainColor;
  final Widget? titleW;
  final Widget? flexibleSpace;
  final double? leadingWidth;
  final double? titleSpacing;
  final Widget? leading;
  final bool leadingVisible;
  final PreferredSizeWidget? bottom;
  final String leadingImg;
  final double elevation;
  final double toolbarHeight;
  final Brightness brightness; //状态栏颜色 默认为白色文字
  final SystemUiOverlayStyle overlayStyle;
  final bool automaticallyImplyLeading; //配合leading 使用，如果左侧不需要图标 ，设置false
  final Function? backClick;

  @override
  Size get preferredSize =>
      Size.fromHeight(toolbarHeight + (bottom?.preferredSize.height ?? 0.0));

  @override
  Widget build(BuildContext context) {
    final titleStr = title.toShort();

    return AppBar(
      title: titleW ??
          MyText(
            titleStr,
            size: 18,
            color: mainColor,
            fontWeight: FontWeight.w500,
          ),
      backgroundColor: backgroundColor,
      elevation: elevation,
      flexibleSpace: flexibleSpace,
      leading: leading ??
          Visibility(
            visible: leadingVisible,
            child: IconButton(
              onPressed: () {
                if (backClick != null) {
                  backClick!();
                } else {
                  NavigatorUtil.goBack();
                }
              },
              icon: MyIcon(
                Icons.arrow_back_ios_new_outlined,
                color: mainColor,
                size: 18,
              ),
            ),
          ),
      titleSpacing: titleSpacing,
      leadingWidth: leadingWidth,
      systemOverlayStyle: Platform.isAndroid
          ? SystemUiOverlayStyle(
              statusBarBrightness: brightness,
              statusBarIconBrightness: brightness,
              systemNavigationBarColor: Colors.transparent,
            )
          : overlayStyle,
      automaticallyImplyLeading: automaticallyImplyLeading,
      centerTitle: centerTitle,
      actions: rightActions ?? rightActions,
      toolbarHeight: toolbarHeight,
      bottom: bottom ?? bottom,
    );
  }
}
""";

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      transformViewController.textEditingController.text = themeTemplet;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hideApp
          ? null
          : AppBar(
              title: Text("$widget"),
            ),
      body: NTransformView(
        controller: transformViewController,
        title: NText(
          '根据 Widget 组件生成对应的 Theme',
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        // message: NText(
        //   "这是一条提示信息",
        //   maxLines: 3,
        // ),
        toolbarBuilder: (_) {
          return Wrap(
            spacing: 8,
            runSpacing: 8,
            children: actionItems.map((e) {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: e.action,
                child: NText(e.name),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  onGenerate() async {
    final lines = transformViewController.textEditingController.text
        .split("Widget build(BuildContext context)")
        .first
        .split("\n")
        .where(
            (e) => e.startsWith("class ") || e.trimLeft().startsWith("final "))
        .toList();

    final clsName =
        (lines.where((e) => e.startsWith("class ")).firstOrNull ?? "ClassName")
            .split(" ")[1]
            .replaceAll("My", "Yl");

    final propertys = lines.where((e) {
      final result = e.trimLeft().startsWith("final ") && e.contains("?");
      return result;
    }).map((e) {
      final eContent = e.trimLeft();
      final comment = eContent.contains("//") ? eContent.split("//").last : "";
      final parts = eContent.split(RegExp(r'[ ;]+'));
      final p = (name: parts[2], type: parts[1], comment: comment);
      return p;
    }).toList();
    // transformViewController.out = clsName +
    //     propertys.map((e) => e.toString()).join(""
    //         "\n");

    final fileName = "${clsName.toUncamlCase("_")}_theme.dart";
    final content = createThemeFileContent(
      clsName: clsName,
      propertys: propertys,
    );
    transformViewController.out = content;

    onCreate(fileName: fileName, content: content);
    final file = await FileManager.instance.createFile(
      fileName: fileName,
      content: content,
    );
    if (file.existsSync()) {
      showSnackBar(SnackBar(
        content: NText(
          "文件已生成(下载文件夹)",
          color: Colors.white,
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.green,
      ));
      openFolder(file: file);
    }
  }

  onClear() {
    transformViewController.clear();
  }

  onPaste() async {
    transformViewController.paste();
    onGenerate();
  }

  onCreate({
    required String fileName,
    required String content,
  }) async {
    final file = await FileManager.instance.createFile(
      fileName: fileName,
      content: content,
    );
    if (file.existsSync()) {
      showSnackBar(SnackBar(
        content: NText(
          "文件已生成(下载文件夹)",
          color: Colors.white,
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.green,
      ));
      openFolder(file: file);
    }
  }

  Future<void> openFolder({required File file}) async {
    final path = 'file:///Users/shang/Downloads';
    final uri = Uri.parse(path);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }

  String createThemeFileContent({
    String prefix = "Yl",
    required String clsName,
    required List<PropertyRecord> propertys,
  }) {
    final projectName = "yl_design";
    final dateStr = DateTimeExt.stringFromDate(
      date: DateTime.now(),
      format: 'yyyy/MM/dd HH:mm:ss',
    );

    final name = clsName.startsWith(prefix) ? clsName : prefix + clsName;
    final content = """
//
//  ${name}Theme.dart
//  $projectName
//
//  Created by shang on ${dateStr?.substring(0, 16)}.
//  Copyright © ${dateStr?.substring(0, 10)} shang. All rights reserved.
//

import 'package:flutter/material.dart';

/// 取消按钮
class ${name}Theme extends ThemeExtension<${name}Theme> {
  /// 取消按钮
  ${name}Theme({
${propertys.map((e) => "\t\tthis.${e.name},").join("\n")}
  });

${propertys.map((e) => """
  /// ${e.comment}
  final ${e.type} ${e.name};
  """).join("\n")}

  @override
  ThemeExtension<${name}Theme> copyWith({
${propertys.map((e) => """
\t\t${e.type} ${e.name},
""").join("")}
  }) =>
      ${name}Theme(
    ${propertys.map((e) => """
      ${e.name}: ${e.name} ?? this.${e.name},
    """).join("")}
      );

  @override
  ThemeExtension<${name}Theme> lerp(
    covariant ${name}Theme? other,
    double t,
  ) =>
      ${name}Theme(
    ${propertys.map((e) => """
      ${e.name}: ${e.type.replaceAll("?", "")}.lerp(${e.name}, other?.${e.name}, t),
    """).join("")}
      );
}
    """;
    return content;
  }
}
