


import 'package:enhance_expansion_panel/enhance_expansion_panel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/basicWidget/enhance/enhance_expansion/enhance_expansion_choic.dart';
import 'package:flutter_templet_project/basicWidget/enhance/enhance_expansion/enhance_expansion_tile.dart';

import 'package:flutter_templet_project/basicWidget/n_cancell_and_confirm_bar.dart';
import 'package:flutter_templet_project/basicWidget/n_choice_box.dart';
import 'package:flutter_templet_project/basicWidget/n_choice_box_horizontal.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/color_ext.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';
import 'package:flutter_templet_project/uti/Debounce.dart';
import 'package:flutter_templet_project/uti/color_uti.dart';
import 'package:flutter_templet_project/model/fake_data_model.dart';
import 'package:get_storage/get_storage.dart';

class DropBoxMutiRowChoicDemo extends StatefulWidget {

  DropBoxMutiRowChoicDemo({
    Key? key, 
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _DropBoxMutiRowChoicDemoState createState() => _DropBoxMutiRowChoicDemoState();
}

class _DropBoxMutiRowChoicDemoState extends State<DropBoxMutiRowChoicDemo> {
  final items = List.generate(20, (i) => i).toList();

  var searchText = "";
  late final searchtEditingController = TextEditingController();

  final _debounce = Debounce(milliseconds: 500);

  // final _throttle = Throttle(milliseconds: 500);

  var isVisible = ValueNotifier(false);

  final _globalKey = GlobalKey();

  ScrollController? dropBoxController = ScrollController();

  /// 选项组
  List<FakeDataModel> get models => items.map((e) => FakeDataModel(
    id: "id_$e",
    name: "选项_$e",
  )).toList();
  List<FakeDataModel> selectedModels = [];
  List<FakeDataModel> selectedModelsTmp = [];


  /// 标签组
  List<FakeDataModel> get item1Models => items.map((e) => FakeDataModel(
    id: "id_$e",
    name: "选项1_$e",
  )).toList();
  List<FakeDataModel> selectedItem1Models = [];
  List<FakeDataModel> selectedItem1ModelsTmp = [];

  /// 标签组
  List<FakeDataModel> get item2Models => items.map((e) => FakeDataModel(
    id: "id_$e",
    name: "选项2_$e",
  )).toList();
  List<FakeDataModel> selectedItem2Models = [];
  List<FakeDataModel> selectedItem2ModelsTmp = [];

  /// 标签组
  List<FakeDataModel> get item3Models => items.map((e) => FakeDataModel(
    id: "id_$e",
    name: "选项3_$e",
  )).toList();
  List<FakeDataModel> selectedItem3Models = [];
  List<FakeDataModel> selectedItem3ModelsTmp = [];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) => TextButton(
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => debugPrint(e),)
        ).toList(),
      ),
      body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        buildSearchAndFilterBar(),
                        Expanded(
                          child: buildList(
                            items: items.map((e) => "item_$e").toList(),
                          )
                        ),
                      ],
                    ),
                    ValueListenableBuilder<bool>(
                        valueListenable: isVisible,
                        builder: (context, bool value, child) {
                          if (value == false) {
                            return const SizedBox();
                          }

                          final top = _globalKey.currentContext?.renderBoxSize?.height ??
                              60.h;
                          return Positioned(
                            top: top,
                            bottom: 0,
                            width: context.screenSize.width,
                            // height: 600.h,
                            child: buildDropBox(
                              controller: dropBoxController,
                              hasShadow: true,
                            ),
                          );
                        }
                    ),
                  ],
                ),
              ),
            ],
          )
      ),
    );
  }

  buildSearchAndFilterBar() {
    return Container(
      key: _globalKey,
      padding: EdgeInsets.only(left: 16.w, right: 8.w, top: 12.w, bottom: 12.w),
      child: Row(
        children: [
          Expanded(
            child: buildSearch(cb: (value) {
              searchText = value;
              //...
            }),
          ),
          SizedBox(
            width: 8.w,
          ),
          buildTextBtn(
            padding: EdgeInsets.only(left: 16.w),
            icon: Icon(Icons.fitbit),
            cb: (){
              isVisible.value = !isVisible.value;
              closeKeyboard();
            }
          ),
        ],
      ),
    );
  }

  buildSearch({
    String placeholder = "搜索",
    ValueChanged<String>? cb
  }) {
    return Container(
      height: 36.h,
      // width: 295.w,
      // padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 1.h),
      child: CupertinoSearchTextField(
        controller: searchtEditingController,
        padding: EdgeInsets.zero,
        // prefixIcon: Icon(Icons.search, color: Color(0xff999999), size: 20.h,),
        prefixIcon: Image(
          image: "icon_search.png".toAssetImage(),
          width: 14.w,
          height: 14.w,
        ),
        suffixIcon: Icon(
          Icons.clear,
          color: const Color(0xff999999),
          size: 20.h,
        ),
        prefixInsets: EdgeInsets.only(left: 14.w, top: 5, bottom: 5, right: 6.w),
        // padding: EdgeInsets.only(left: 3, top: 5, bottom: 5, right: 5),
        placeholder: placeholder,
        placeholderStyle: TextStyle(fontSize: 15.sp, color: fontColor[30]),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4.w)),
            color: bgColor
        ),
        onChanged: (String value) {
          _debounce(() {
            debugPrint('searchText: $value');
            cb?.call(value);
          });
        },
        onSubmitted: (String value) {
          _debounce(() {
            debugPrint('onSubmitted: $value');
            cb?.call(value);
          });
        },
      ),
    );
  }

  buildTextBtn({
    String title = "筛选",
    Color? color = Colors.blue,
    VoidCallback? cb,
    bool isIconRight = false,
    OutlinedBorder? shape,
    double labelIconPadding = 4,
    EdgeInsets? padding,
    Widget? icon,
  }) {
    final label = Text(
      title,
      style: TextStyle(
        color: color,
        fontSize: 15.sp,
        fontWeight: FontWeight.w500,
      ),
    );

    var child = <Widget>[label];
    if (icon != null) {
      child = isIconRight
          ? [Flexible(child: label), SizedBox(width: labelIconPadding), icon]
          : [icon, SizedBox(width: labelIconPadding), Flexible(child: label)];
    }

    return TextButton(
      style: TextButton.styleFrom(
        // splashFactory: NoSplash.splashFactory,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: shape,
        // shape: StadiumBorder(
        //   side: BorderSide(color: color ?? Color(0xFF000000)),
        // ),
      ),
      onPressed: cb ?? () {
        debugPrint(title);
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: child,
      ),
    );
  }

  /// 筛选弹窗
  Widget buildDropBox({
    required ScrollController? controller,
    bool hasShadow = false,
    bool isSingle = false,
  }) {
    final child = Container(
      width: double.maxFinite,
      // padding: EdgeInsets.only(left: 16, right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.w),
          bottomRight: Radius.circular(30.w),
        ),
        boxShadow: !hasShadow ? null : [
          BoxShadow(
            offset: Offset(0, 8.w),
            blurRadius: 8.w,
            // spreadRadius: 4,
            color: context.primaryColor.withOpacity(0.3),
          ),
        ]
      ),
      child: Column(
        children: [
          Divider(height: 1.h, color: lineColor,),
          Expanded(
            child: CupertinoScrollbar(
              controller: controller,
              child: SingleChildScrollView(
                controller: controller,
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.only(
                    left: 16.w,
                    right: 16.w,
                    // bottom: 30.w,
                  ),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Text("多行水平选择菜单", style: TextStyle(fontWeight: FontWeight.bold),),
                          buildtMutiRowChoic(models: models,),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          buildDropBoxButtonBar(),
        ],
      ),
    );
    return Container(
      color: Colors.black.withOpacity(0.1),
      padding: EdgeInsets.only(bottom: context.appBarHeight.h),
      child: child,
    );
  }

  /// 多行标签选择
  Widget buildtMutiRowChoic({
    required List<FakeDataModel> models,
    bool isExpand = false,
    int collapseCount = 6,
  }) {

    return StatefulBuilder(
      builder: (context, setState) {

        // final items = isExpand ? models : models.take(collapseCount).toList();
        return buildExpandMenu(
          disable: false,
          isExpand: isExpand,
          onExpansionChanged: (val) {
            isExpand = !isExpand;
            setState(() {});
          },
          title: "多行选择菜单",
          header: (isOpen, onTap) => Container(),
          childrenHeader: (isOpen, onTap) => Column(
            children: [
              buildHorizontalChoicRow<FakeDataModel>(
                  title: "第一栏: ",
                  models: models,
                  cbID: (e) => e.id ?? "",
                  cbName: (e) => e.name ?? "",
                  cbSelected: (e) => selectedModelsTmp.map((e) => e.id ?? "").toList().contains(e.id),
                  onChanged: (value) {
                    // debugPrint("selectedModels: $value");
                    selectedModelsTmp = value.map((e) => e.data!).toList();
                    debugPrint("selectedModelsTmp: ${selectedModelsTmp.map((e) => e.name).toList()}");
                  },
              ),
              buildHorizontalChoicRow<FakeDataModel>(
                title: "第二栏: ",
                models: item1Models,
                cbID: (e) => e.id ?? "",
                cbName: (e) => e.name ?? "",
                cbSelected: (e) => selectedItem1ModelsTmp.map((e) => e.id ?? "").toList().contains(e.id),
                onChanged: (value) {
                  // debugPrint("selectedModels: $value");
                  selectedItem1ModelsTmp = value.map((e) => e.data!).toList();
                  debugPrint("selectedItem1ModelsTmp: ${selectedItem1ModelsTmp.map((e) => e.name).toList()}");
                },
              ),
            ],
          ),
          children: [
            Column(
              children: [
                buildHorizontalChoicRow<FakeDataModel>(
                  title: "第三栏: ",
                  isSingle: false,
                  models: item2Models,
                  cbID: (e) => e.id ?? "",
                  cbName: (e) => e.name ?? "",
                  cbSelected: (e) => selectedItem2ModelsTmp.map((e) => e.id ?? "").toList().contains(e.id),
                  onChanged: (value) {
                    // debugPrint("selectedModels: $value");
                    selectedItem2ModelsTmp = value.map((e) => e.data!).toList();
                    debugPrint("selectedItem2ModelsTmp: ${selectedItem2ModelsTmp.map((e) => e.name).toList()}");
                  },
                ),
                buildHorizontalChoicRow<FakeDataModel>(
                  title: "第四栏: ",
                  isSingle: false,
                  models: item3Models,
                  cbID: (e) => e.id ?? "",
                  cbName: (e) => e.name ?? "",
                  cbSelected: (e) => selectedItem3ModelsTmp.map((e) => e.id ?? "").toList().contains(e.id),
                  onChanged: (value) {
                    // debugPrint("selectedModels: $value");
                    selectedItem3ModelsTmp = value.map((e) => e.data!).toList();
                    debugPrint("selectedItem3ModelsTmp: ${selectedItem3ModelsTmp.map((e) => e.name).toList()}");
                  },
                ),
              ],
            )
          ],
          childrenFooter: (isOpen, onTap) => Container(
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 1),
            child: GestureDetector(
              onTap: onTap,
              child: Icon(isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down),
            ),
          ),
        );
      }
    );
  }

  /// 筛选弹窗 水平滑动标签选择
  Widget buildDropBoxChoicHorizontal<T>({
    required List<T> models,
    required String Function(T) cbID,
    required String Function(T) cbName,
    required bool Function(T) cbSelected,
    required ValueChanged<List<ChoiceBoxModel<T>>> onChanged,
    bool isExpand = false,
    int collapseCount = 6,
    double height = 50,
    bool isSingle = true,
  }) {
    final disable = (models.length <= collapseCount);

    return StatefulBuilder(
      builder: (context, setState) {

        final items = isExpand ? models : models.take(collapseCount).toList();
        return buildExpandMenu(
          disable: disable,
          isExpand: isExpand,
          onExpansionChanged: (val) {
            isExpand = !isExpand;
            setState(() {});
          },
          title: "标签",
          header: (isOpen, onTap) => SizedBox(),
          childrenHeader: (isOpen, onTap) => Container(
            // color: ColorExt.random,
            height: height,
            width: double.maxFinite,
            child: NChoiceBoxHorizontal<T>(
              isSingle: isSingle,
              items: items.map((e) => ChoiceBoxModel<T>(
                id: cbID(e),
                title: cbName(e),
                isSelected: cbSelected(e),
                data: e,
              )).toList(),
              onChanged: onChanged,
            ),
          ),
          children: [],
        );
      }
    );
  }


  ///水平选择子菜单
  buildHorizontalChoiceMenu<T>({
    required List<T> models,
    required String Function(T) cbID,
    required String Function(T) cbName,
    required bool Function(T) cbSelected,
    ValueChanged<List<ChoiceBoxModel<T>>>? onChanged,
    bool isSingle = true,
  }) {
    return NChoiceBoxHorizontal<T>(
      isSingle: isSingle,
      // itemColor: Colors.transparent,
      // wrapAlignment: WrapAlignment.spaceBetween,
      // wrapAlignment: WrapAlignment.start,
      items: models.map((e) => ChoiceBoxModel<T>(
        id: cbID(e),
        title: cbName(e),
        isSelected: cbSelected(e),
        data: e,
      )).toList(),
      onChanged: onChanged ?? (value) {
        debugPrint("selectedModels: $value");
      },
    );
  }


  buildHorizontalChoicRow<T>({
    String title = "标题",
    required List<T> models,
    required String Function(T) cbID,
    required String Function(T) cbName,
    required bool Function(T) cbSelected,
    required ValueChanged<List<ChoiceBoxModel<T>>> onChanged,
    bool isSingle = true,
  }) {
    return Row(
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold),),
        SizedBox(width: 8,),
        Expanded(
          child: buildDropBoxChoicHorizontal<T>(
            isSingle: isSingle,
            height: 35,
            models: models,
            cbID: cbID,
            cbName: cbName,
            cbSelected: cbSelected,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  /// 筛选弹窗 取消确认菜单
  Widget buildDropBoxButtonBar() {
    return NCancellAndConfirmBar(
      cancellTitle: "重置",
      bottomLeftRadius: Radius.circular(30.w),
      bottomRightRadius: Radius.circular(30.w),
      onCancell: () {
        // Navigator.of(context).pop();
        handleResetFitler();
      },
      onConfirm: () {
        // Navigator.of(context).pop();
        handleConfirmFitler();
      },
    );
  }

  /// 重置过滤参数
  handleResetFitler() {
    // closeDropBox();
    selectedModelsTmp = [];
    selectedItem1ModelsTmp = [];
    selectedItem2ModelsTmp = [];
    selectedItem3ModelsTmp = [];

    handleConfirmFitler();
  }
  /// 确定过滤参数
  handleConfirmFitler() {
    closeDropBox();

    selectedModels = selectedModelsTmp;
    selectedItem1Models = selectedItem1ModelsTmp;
    selectedItem2Models = selectedItem2ModelsTmp;
    selectedItem3Models = selectedItem3ModelsTmp;

    debugPrint("""-------------------------------------------
selectedModels: ${selectedModels.map((e) => e.name).toList()},
selectedItem1Models: ${selectedItem1Models.map((e) => e.name).toList()},
selectedItem2Models: ${selectedItem2Models.map((e) => e.name).toList()},
selectedItem3Models: ${selectedItem3Models.map((e) => e.name).toList()},""");
    //请求
  }


  Widget buildExpandMenu({
    required String title,
    List<Widget> children = const [],
    bool isExpand = true,
    ValueChanged<bool>? onExpansionChanged,
    Color color = const Color(0xffFF7E6E),
    bool disable = false,
    ExpansionWidgetBuilder? header,
    ExpansionWidgetBuilder? childrenHeader,
    ExpansionWidgetBuilder? childrenFooter,
  }) {
    return Theme(
      data: ThemeData(
        dividerColor: Colors.transparent,
      ),
      child: EnhanceExpansionTile(
        header: header,
        childrenHeader: childrenHeader,
        childrenFooter: childrenFooter,
        tilePadding: const EdgeInsets.symmetric(horizontal: 0),
        // leading: Icon(Icons.ac_unit),
        // trailing: OutlinedButton.icon(
        //     onPressed: (){
        //       debugPrint("arrow");
        //     },
        //     icon: Icon(Icons.expand_more),
        //     label: Text("展开"),
        //   style: OutlinedButton.styleFrom(
        //     shape: StadiumBorder()
        //   ),
        // ),
        trailing: disable ? const SizedBox() : buildExpandMenuTrailing(
          isExpand: isExpand,
          color: color,
          boderColor: color.withOpacity(0.2),
        ),
        collapsedTextColor: fontColor,
        textColor: fontColor,
        iconColor: color,
        collapsedIconColor: color,
        title: Text(
          title,
          style: TextStyle(
              color: fontColor,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold
          ),
        ),
        initiallyExpanded: disable ? false : isExpand,
        onExpansionChanged: onExpansionChanged,
        children: children,
      ),
    );
  }

  buildExpandMenuTrailing({
    bool isExpand = true,
    Color color = Colors.blueAccent,
    Color boderColor = Colors.blueAccent,
  }) {
    final title = isExpand ? "收起" : "展开";
    final icon = isExpand
        ? Icon(Icons.expand_less, size: 24, color: color,)
        : Icon(Icons.expand_more, size: 24, color: color,);

    return Container(
      width: 66.w,
      height: 29.w,
      // color: Colors.red,
      padding: EdgeInsets.only(left: 8.w, right: 4.w, top: 2.w, bottom: 2.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15.w)),
        border: Border.all(color: boderColor),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(color: color),
          ),
          const SizedBox(width: 0,),
          icon,
        ],
      ),
    );
  }

  buildList({required List<String> items}) {
    return Material(
      // color: Colors.transparent,
      child: ListView.separated(
        padding: EdgeInsets.all(0),
        itemCount: items.length,
        cacheExtent: 10,
        itemBuilder: (context, index) {
          final e = items[index];
          return ListTile(
            title: Text(e),
            onTap: () {
              debugPrint(e);
            },
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            height: .5,
            indent: 15,
            endIndent: 15,
            color: Color(0xFFe4e4e4),
          );
        },
      ).addCupertinoScrollbar(),
    );
  }

  closeDropBox() {
    if (isVisible.value == false) {
      return;
    }
    isVisible.value = !isVisible.value;
  }

  closeKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}