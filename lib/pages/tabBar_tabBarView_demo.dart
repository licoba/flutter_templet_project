//
//  TabBarTabBarViewDemo.dart
//  flutter_templet_project
//
//  Created by shang on 10/22/21 2:32 PM.
//  Copyright © 10/22/21 shang. All rights reserved.
//

import 'package:enhance_expansion_panel/enhance_expansion_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/basicWidget/list_subtitle_cell.dart';
import 'package:flutter_templet_project/basicWidget/app_update_card.dart';
import 'package:flutter_templet_project/basicWidget/section_list_view.dart';

import 'package:flutter_templet_project/extension/color_ext.dart';
import 'package:flutter_templet_project/extension/divider_ext.dart';
import 'package:flutter_templet_project/extension/list_ext.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/extension/object_ext.dart';

import 'package:flutter_templet_project/main.dart';
import 'package:flutter_templet_project/mockData/mock_data.dart';
import 'package:flutter_templet_project/routes/APPRouter.dart';

import 'package:get/get.dart';
import 'package:tuple/tuple.dart';

import 'demo/AutocompleteDemo.dart';


class TabBarTabBarViewDemo extends StatefulWidget {

  @override
  _TabBarTabBarViewDemoState createState() => _TabBarTabBarViewDemoState();
}

class _TabBarTabBarViewDemoState extends State<TabBarTabBarViewDemo> with SingleTickerProviderStateMixin {
  late TabController _tabController = TabController(length: _pages.length, vsync: this);

  final textEditingController = TextEditingController();

  // late PageController _pageController = PageController(initialPage: 0, keepPage: true);

  // late List<String> _titles = getTitlesOfTuples();

  List<Tuple2<String, Widget>> _pages = [];

  @override
  void initState() {
    super.initState();

    _pages = [
      Tuple2('功能列表', _buildPage1()),
      Tuple2('升级列表', _buildPage2()),
      Tuple2('列表搜索', _buildPage3()),
      Tuple2('列表(折叠)', _buildPage4()),
    ];

    _tabController.index = _pages.length - 1;
    // testData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          // Status bar color
          statusBarColor: Colors.red,

          // Status bar brightness (optional)
          // statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          // statusBarBrightness: Brightness.light, // For iOS (dark icons)
        ),
        // titleTextStyle: TextStyle(color: Colors.red),
        // toolbarTextStyle: TextStyle(color: Colors.orange),
        // iconTheme: IconThemeData(color: Colors.green),
        actionsIconTheme: IconThemeData(color: Colors.yellow),
        title: Text('基础组件列表'),
        leading: Builder(builder: (context) {
          return IconButton(
            icon: Icon(Icons.menu, color: Colors.white), //自定义图标
            onPressed: () {
              // Scaffold.of(context).openDrawer();
              kScaffoldKey.currentState!.openDrawer();// 打开抽屉菜单
            },
          );
        }),
        actions: [
          TextButton(
            onPressed: (){
              Get.toNamed(APPRouter.stateManagerDemo, arguments: "状态管理");
            },
            child: Text("状态管理",
              style: TextStyle(color: Colors.white),
            ),
          ),
          IconButton(onPressed: () => print("aa"), icon: Icon(Icons.ac_unit))
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _pages.map((e) => Tab(
              key: PageStorageKey<String>(e.item1),
              text: e.item1
          )).toList(),
          // indicatorSize: TabBarIndicatorSize.label,
          // indicatorPadding: EdgeInsets.only(left: 6, right: 6),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _pages.map((e) => e.item2).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Increment',
        child: Icon(Icons.add),
        onPressed: () {
          kScaffoldKey.currentState!.openEndDrawer();
          // testData();
          getTitles(tuples: tuples);
        },
      ),
    );
  }
  
  _buildPage1() {
    return ListView.separated(
      cacheExtent: 180,
      itemCount: kAliPayList.length,
      itemBuilder: (context, index) {
        final data = kAliPayList[index];
        return ListSubtitleCell(
          padding: EdgeInsets.all(10),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.network(
              data.imageUrl,
              width: 40,
              height: 40,
            ),
          ),
          title: Text(
            data.title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(0xFF333333),
            ),
          ),
          subtitle: Text(data.content,
            // maxLines: 1,
            // overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFF999999),
            ),
          ),
          trailing: Text(data.time,
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF999999),
            ),
          ),
          subtrailing: Text("已完成",
            style: TextStyle(
              fontSize: 13,
              color: Colors.blue,
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return DividerExt.custome();
      },
    );
  }

  _buildPage2() {
    return ListView.separated(
      cacheExtent: 180,
      itemCount: kUpdateAppList.length,
      itemBuilder: (context, index) {
        final data = kUpdateAppList[index];
        if (index == 0) {
          return AppUpdateCard(data: data, isExpand: true, showExpand: false,);
        }
        return AppUpdateCard(data: data);
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
  }

  _buildPage3() {
    return AutocompleteDemo(hideAppBar: true,);
  }

  _buildPage4() {
    return EnhanceExpandListView(
      children: tuples.map<ExpandPanelModel<Tuple2<String, String>>>((e) => ExpandPanelModel(
        canTapOnHeader: true,
        isExpanded: false,
        arrowPosition: EnhanceExpansionPanelArrowPosition.none,
        // backgroundColor: Color(0xFFDDDDDD),
        headerBuilder: (contenx, isExpand) {
          final trailing = isExpand ? Icon(Icons.keyboard_arrow_up, color: Colors.blue) :
          Icon(Icons.keyboard_arrow_down, color: Colors.blue,);
          return Container(
            // color: Colors.green,
            color: isExpand ? Colors.black12 : null,
            child: ListTile(
              title: Text("${e.item1}", style: TextStyle(fontWeight: FontWeight.bold),),
              // subtitle: Text("subtitle"),
              trailing: trailing,
            ),
          );
        },
        bodyChildren: e.item2,
        bodyItemBuilder: (context, e) {
          return ListTile(
              title: Text(e.item1, style: TextStyle(fontSize: 14),),
              subtitle: Text(e.item2, style: TextStyle(fontSize: 12),),
              trailing: Icon(Icons.chevron_right),
              dense: true,
              // contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
              onTap: () {
                ddlog("section_");
                if (e.item1.toLowerCase().contains("loginPage".toLowerCase())){
                  Get.offNamed(e.item1, arguments: e.item1);
                } else {
                  Get.toNamed(e.item1, arguments: e.item1);
                }
              });
        },
      )).toList(),
    );
  }
  
  List<String> getTitles({required List<Tuple2<String, List<Tuple2<String, String>>>> tuples}) {
    final titles = tuples.expand((e) => e.item2.map((e) => e.item1)).toList();
    final result = List<String>.from(titles);
    // print('titles runtimeType:${titles.runtimeType},${titles.every((element) => element is String)},');
    print('result runtimeType:${result.runtimeType}');
    return result;
  }

  testData() {
    final String? a = null;
    ddlog(a.runtimeType);

    final String? a1 = "a1";
    ddlog(a1.runtimeType);

    final List<String>? array = null;
    ddlog(array.runtimeType);

    ddlog(a.isBlank);
    // ddlog(a.or(block: (){
    //   return "123";
    // }));
    ddlog(a.or(() => "456"));
    ddlog(a.or((){
      return "111";
    }));

    // array.or(() => null);

    final List<String>? array1 = List.generate(9, (index) => "$index");
    final result = array1!.reduce((value, element) => value + element);
    ddlog(result);

    ddlog(array.or(() => array1));

    final nums = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
    final val = nums.reduce((value, element) => value + element);
    ddlog(val);

    final map = {"a": "aa", "b": "bb", "c": "cc",} ;
    final value = map["d"] ?? "-";
    ddlog(value);
  }

  _buildTextField() {
    return Container(
      ///SizedBox 用来限制一个固定 width height 的空间
      child: SizedBox(
        width: 400,
        height: 130,
        child: Container(
          color: Colors.white24,
          ///距离顶部
          margin: EdgeInsets.only(top: 30),
          padding: EdgeInsets.all(10),
          ///Alignment 用来对齐 Widget
          alignment: Alignment(0, 0),
          ///文本输入框
          child: TextField(
            controller: textEditingController,
            ///用来配置 TextField 的样式风格
            decoration: InputDecoration(
              ///设置输入文本框的提示文字
              ///输入框获取焦点时 并且没有输入文字时
              hintText: "请输入关键字搜索",
              ///设置输入文本框的提示文字的样式
              hintStyle: TextStyle(color: Colors.grey, textBaseline: TextBaseline.ideographic,),
              
              ///输入文字前的小图标
              prefixIcon: Icon(Icons.search),
              ///输入文字后面的小图标
              suffixIcon: textEditingController.text.length == 0 ? null : IconButton(
                onPressed: () => textEditingController.clear(),
                icon: Icon(Icons.close),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

var tuples = [
  Tuple2("数据类型", dataTypes),
  Tuple2("特殊功能", specials),
  Tuple2("动画相关", animateds),
  Tuple2("系统组件demo", list),
  Tuple2("系统组件 - sliver", slivers),
  Tuple2("自定义组件", customs),
  Tuple2("第三方组件", vendors),
  Tuple2("表单", forms),
  Tuple2("其它", others)

];


var list = [
  Tuple2(APPRouter.materialDemo, "materialDemo", ),
  Tuple2(APPRouter.alertDialogDemo, "AlertDialog", ),
  Tuple2(APPRouter.alertSheetDemo, "AlertSheet", ),
  Tuple2(APPRouter.appWebViewDemo, "appWebViewDemo", ),
  Tuple2(APPRouter.builderDemo, "builderDemo", ),

  Tuple2(APPRouter.backdropFilterDemo, "backdropFilterDemo", ),

  Tuple2(APPRouter.cupertinoTabScaffoldDemo, "CupertinoTabScaffoldDemo", ),
  Tuple2(APPRouter.cupertinoFormDemo, "cupertinoFormDemo", ),
  Tuple2(APPRouter.contextMenuActionDemo, "cupertinoFormDemo", ),

  Tuple2(APPRouter.dataTableDemo, "dateTableDemo", ),
  Tuple2(APPRouter.dataTableDemoNew, "dataTableDemoNew", ),
  Tuple2(APPRouter.draggableDemo, "draggableDemo", ),
  Tuple2(APPRouter.draggableScrollableSheetDemo, "draggableScrollableSheetDemo", ),

  Tuple2(APPRouter.expandIconDemo, "expandIconDemo", ),
  Tuple2(APPRouter.expandIconDemoNew, "ExpandIconDemoNew", ),

  Tuple2(APPRouter.gridViewDemo, "GridView", ),
  Tuple2(APPRouter.gridPaperDemo, "gridPaperDemo", ),

  Tuple2(APPRouter.menuDemo, "MenuDemo", ),

  Tuple2(APPRouter.pageViewDemo, "PageViewDemo", ),
  Tuple2(APPRouter.pageViewTabBarWidget, "PageViewTabBarWidget", ),

  Tuple2(APPRouter.pickerDemo, "pickerDemo", ),
  Tuple2(APPRouter.progressHudDemo, "ProgressHudDemo", ),
  Tuple2(APPRouter.progressHudDemoNew, "ProgressHudDemoNew", ),
  Tuple2(APPRouter.progressIndicatorDemo, "ProgressIndicatorDemo", ),

  Tuple2(APPRouter.reorderableListViewDemo, "reorderableListViewDemo", ),
  Tuple2(APPRouter.listDismissibleDemo, "recordListDemo", ),

  Tuple2(APPRouter.segmentControlDemo, "segmentControlDemo", ),
  Tuple2(APPRouter.snackBarDemo, "SnackBar", ),
  Tuple2(APPRouter.snackBarDemoOne, "SnackBar封装", ),
  Tuple2(APPRouter.sliderDemo, "sliderDemo", ),
  Tuple2(APPRouter.stepperDemo, "stepperDemo", ),
  Tuple2(APPRouter.slidableDemo, "SlidableDemo", ),
  Tuple2(APPRouter.sliverFamilyDemo, "SliverFamilyDemo", ),

  Tuple2(APPRouter.tabBarDemo, "tabBarDemo", ),
  Tuple2(APPRouter.tabBarDemoNew, "tabBarDemoNew", ),
  Tuple2(APPRouter.tabBarOnlyDemo, "tabBarOnlyDemo", ),
  Tuple2(APPRouter.tabBarSegmentDemo, "tabBarSegmentDemo", ),
  Tuple2(APPRouter.tabBarSegmentNewDemo, "tabBarSegmentNewDemo", ),

  Tuple2(APPRouter.textlessDemo, "textlessDemo", ),
  Tuple2(APPRouter.textFieldDemo, "textFieldDemo", ),
  Tuple2(APPRouter.textFieldDemoOne, "textFieldDemoOne", ),

  Tuple2(APPRouter.layoutBuilderDemo, "layoutBuilderDemo", ),
  Tuple2(APPRouter.tableDemo, "tableDemo", ),
  Tuple2(APPRouter.nestedScrollViewDemo, "nestedScrollViewDemo", ),

  Tuple2(APPRouter.absorbPointerDemo, "absorbPointerDemo", ),
  Tuple2(APPRouter.willPopScopeDemo, "willPopScopeDemo", ),

  Tuple2(APPRouter.futureBuilderDemo, "futureBuilderDemo", ),
  Tuple2(APPRouter.streamBuilderDemo, "streamBuilderDemo", ),

  Tuple2(APPRouter.indexedStackDemo, "indexedStackDemo", ),
  Tuple2(APPRouter.responsiveColumnDemo, "responsiveColumnDemo", ),
  Tuple2(APPRouter.offstageDemo, "offstageDemo", ),
  Tuple2(APPRouter.bottomAppBarDemo, "bottomAppBarDemo", ),
  Tuple2(APPRouter.calendarDatePickerDemo, "calendarDatePickerDemo", ),
  Tuple2(APPRouter.chipDemo, "chipDemo", ),
  Tuple2(APPRouter.chipFilterDemo, "chipFilterDemo", ),
  Tuple2(APPRouter.bottomSheetDemo, "bottomSheetDemo", ),
  Tuple2(APPRouter.timePickerDemo, "timePickerDemo", ),
  Tuple2(APPRouter.shaderMaskDemo, "ShaderMaskDemo", ),
  Tuple2(APPRouter.blurViewDemo, "blurViewDemo", ),
  Tuple2(APPRouter.boxDemo, "boxDemo", ),
  Tuple2(APPRouter.mouseRegionDemo, "mouseRegionDemo", ),
  Tuple2(APPRouter.navigationBarDemo, "navigationBarDemo", ),
  Tuple2(APPRouter.shortcutsDemo, "shortcutsDemo", ),
  Tuple2(APPRouter.shortcutsDemoOne, "shortcutsDemoOne", ),
  Tuple2(APPRouter.transformDemo, "动画", ),
  Tuple2(APPRouter.fittedBoxDemo, "fittedBox", ),
  Tuple2(APPRouter.coloredBoxDemo, "coloredBoxDemo", ),
  Tuple2(APPRouter.positionedDirectionalDemo, "positionedDirectionalDemo", ),
  Tuple2(APPRouter.statefulBuilderDemo, "statefulBuilderDemo", ),
  Tuple2(APPRouter.valueListenableBuilderDemo, "valueListenableBuilderDemo", ),
  Tuple2(APPRouter.overflowBarDemo, "水平溢出自动垂直排列", ),
  Tuple2(APPRouter.navigationToolbarDemo, "navigationToolbar", ),
  Tuple2(APPRouter.selectableTextDemo, "文字选择", ),
  Tuple2(APPRouter.materialBannerDemo, "一个 Banner", ),
  Tuple2(APPRouter.autocompleteDemo, "自动填写", ),
  Tuple2(APPRouter.rotatedBoxDemo, "rotatedBoxDemo", ),
  Tuple2(APPRouter.dismissibleDemo, "左滑删除", ),
  Tuple2(APPRouter.modalBarrierDemo, "静态蒙版", ),
  Tuple2(APPRouter.bannerDemo, "角落价格标签", ),
  Tuple2(APPRouter.listViewDemo, "listView", ),
  Tuple2(APPRouter.listViewStyleDemo, "listViewStyleDemo", ),
  Tuple2(APPRouter.builderDemo, "各种回调 builder", ),
  Tuple2(APPRouter.stackDemo, "StackDemo", ),
  Tuple2(APPRouter.wrapDemo, "流水自动换行", ),
  Tuple2(APPRouter.inheritedWidgetDemo, "inheritedWidgetDemo 数据共享", ),
  Tuple2(APPRouter.notificationListenerDemo, "notificationListenerDemo 数据共享", ),
  Tuple2(APPRouter.notificationCustomDemo, "notificationCustomDemo 自定义通知", ),
  Tuple2(APPRouter.scrollbarDemo, "scrollbarDemo 滚动指示器监听", ),
  Tuple2(APPRouter.intrinsicHeightDemo, "intrinsicHeightDemo", ),
  Tuple2(APPRouter.flexDemo, "flex 布局", ),
  Tuple2(APPRouter.flexibleDemo, "flexible 布局", ),
  Tuple2(APPRouter.physicalModelDemo, "physicalModelDemo", ),
  Tuple2(APPRouter.visibilityDemo, "visibilityDemo", ),
  Tuple2(APPRouter.ignorePointerDemo, "ignorePointerDemo", ),
  Tuple2(APPRouter.boxShadowDemo, "BoxShadow 阴影", ),
  Tuple2(APPRouter.borderDemo, "buttonBorderDemo", ),
  Tuple2(APPRouter.overflowDemo, "overflowDemo", ),
  Tuple2(APPRouter.flexibleSpaceDemo, "flexibleSpaceDemo", ),
  Tuple2(APPRouter.nnHorizontalScrollWidgetDemo, "nnHorizontalScrollWidgetDemo", ),
  Tuple2(APPRouter.interactiveViewerDemo, "图片缩放", ),
  Tuple2(APPRouter.tabBarPageViewDemo, "tabBarPageViewDemo页面封装", ),

];

var slivers = [
  Tuple2(APPRouter.sliverFamilyDemo, "SliverFamilyDemo", ),

];

var specials = [
  Tuple2(APPRouter.operatorDemo, "特殊操作符", ),
  Tuple2(APPRouter.mediaQueryDemo, "mediaQuery", ),
  Tuple2(APPRouter.pageLifecycleObserverDemo, "页面生命周期监听", ),
  Tuple2(APPRouter.systemIconsPage, "flutter 系统 Icons", ),
  Tuple2(APPRouter.systemColorPage, "flutter 系统 颜色", ),
  Tuple2(APPRouter.localImagePage, "本地图片", ),
  Tuple2(APPRouter.providerRoute, "providerRoute", ),
  Tuple2(APPRouter.stateManagerDemo, "状态管理", ),

  Tuple2(APPRouter.tabBarPageViewDemo, "tabBarPageViewDemo", ),
  Tuple2(APPRouter.tabBarReusePageDemo, "tabBarReusePageDemo", ),

  Tuple2(APPRouter.githubRepoDemo, "githubRepoDemo", ),
  Tuple2(APPRouter.hitTest, "hitTest", ),
  Tuple2(APPRouter.textViewDemo, "textViewDemo", ),
  Tuple2(APPRouter.flutterFFiTest, "ffi", ),
  Tuple2(APPRouter.mergeImagesDemo, "图像合并", ),
  Tuple2(APPRouter.mergeNetworkImagesDemo, "网络图像合并", ),
  Tuple2(APPRouter.drawImageNineDemo, "图像拉伸", ),
  Tuple2(APPRouter.promptBuilderDemo, "指引模板", ),
  Tuple2(APPRouter.isolateDemo, "isolateDemo", ),
  Tuple2(APPRouter.overlayDemo, "overlay弹窗", ),
  Tuple2(APPRouter.boxConstraintsDemo, "boxConstraints", ),
  Tuple2(APPRouter.gradientDemo, "渐变色", ),
  Tuple2(APPRouter.imageBlendModeDemo, "图片渲染模式", ),
  Tuple2(APPRouter.containerDemo, "containerDemo", ),
  Tuple2(APPRouter.scrollControllerDemo, "滚动行为", ),
  Tuple2(APPRouter.buttonStyleDemo, "按钮样式研究", ),
  Tuple2(APPRouter.keyDemo, "key研究", ),


  Tuple2(APPRouter.netStateListenerDemo, "netStateListenerDemo", ),
  Tuple2(APPRouter.netStateListenerDemoOne, "mixin监听网络", ),

];

var animateds = [
  // Tuple2(APPRouter.animatedIconDemo, "AnimatedIconDemo", ),
  Tuple2(APPRouter.animatedDemo, "animatedDemo", ),

  Tuple2(APPRouter.animatedSwitcherDemo, "animatedSwitcherDemo", ),
  Tuple2(APPRouter.animatedWidgetDemo, "animatedWidgetDemo", ),
  Tuple2(APPRouter.animatedGroupDemo, "animatedGroupDemo", ),
  Tuple2(APPRouter.animatedBuilderDemo, "animatedBuilderDemo", ),
  Tuple2(APPRouter.animatedListDemo, "animatedListDemo", ),
  Tuple2(APPRouter.animatedListSample, "animatedListSample", ),
  Tuple2(APPRouter.animatedStaggerDemo, "staggerDemo", ),


];

var customs = [
  Tuple2(APPRouter.datePickerPage, "DatePickerPage", ),
  Tuple2(APPRouter.dateTimeDemo, "dateTimeDemo", ),
  Tuple2(APPRouter.hudProgressDemo, "HudProgressDemo", ),
  Tuple2(APPRouter.localNotifationDemo, "localNotifationDemo", ),
  Tuple2(APPRouter.locationPopView, "locationPopView", ),
  Tuple2(APPRouter.numberStepperDemo, "商品计数器", ),
  Tuple2(APPRouter.numberFormatDemo, "数字格式化", ),
  Tuple2(APPRouter.steperConnectorDemo, "steperConnectorDemo", ),
  Tuple2(APPRouter.customSwipperDemo, "自定义轮播", ),
  Tuple2(APPRouter.neumorphismDemo, "拟物按钮", ),
  Tuple2(APPRouter.horizontalCellDemo, "水平 cell 布局", ),
  Tuple2(APPRouter.listViewOneDemo, "跑马灯效果", ),
  Tuple2(APPRouter.marqueeWidgetDemo, "跑马灯效果", ),
  Tuple2(APPRouter.ticketDemo, "券", ),
  Tuple2(APPRouter.myPopverDemo, "弹窗测试", ),
  Tuple2(APPRouter.customScrollBarDemo, "自定义 ScrollBar", ),
  Tuple2(APPRouter.enhanceTabBarDemo, "Tab 指示器支持固定宽度", ),
  Tuple2(APPRouter.nnCollectionNavWidgetDemo, "图文导航", ),


];

var vendors = [
  Tuple2(APPRouter.carouselSliderDemo, "carouselSliderDemo", ),
  Tuple2(APPRouter.timelinesDemo, "timelinesDemo", ),
  Tuple2(APPRouter.timelineDemo, "timelineDemo", ),
  Tuple2(APPRouter.qrCodeScannerDemo, "扫描二维码", ),
  Tuple2(APPRouter.qrFlutterDemo, "生成二维码", ),
  Tuple2(APPRouter.scribbleDemo, "scribble 画板", ),
  Tuple2(APPRouter.aestheticDialogsDemo, "aestheticDialogs 对话框", ),
  Tuple2(APPRouter.customTimerDemo, "自定义计时器", ),
  Tuple2(APPRouter.skeletonDemo, "骨架屏", ),
  Tuple2(APPRouter.smartDialogPageDemo, "弹窗", ),
  Tuple2(APPRouter.ratingBarDemo, "星评", ),
  Tuple2(APPRouter.dragAndDropDemo, "文件拖拽", ),
  Tuple2(APPRouter.popoverDemo, "popoverDemo", ),
  Tuple2(APPRouter.badgesDemo, "badgesDemo", ),
  Tuple2(APPRouter.flutterSwiperDemo, "flutterSwiperDemo", ),
  Tuple2(APPRouter.flutterSwiperIndicatorDemo, "flutterSwiperIndicatorDemo", ),
  Tuple2(APPRouter.visibilityDetectorDemo, "visibilityDetector 曝光检测", ),
  Tuple2(APPRouter.svgaImageDemo, "svgaImageDemo", ),
  Tuple2(APPRouter.providerDemo, "状态管理 - provider", ),
  Tuple2(APPRouter.colorConverterDemo, "颜色转换", ),
  Tuple2(APPRouter.wechatAssetsPickerDemo, "微信相册选择器", ),
  Tuple2(APPRouter.wechatPhotoPickerDemo, "微信相册选择器组件封装", ),
  Tuple2(APPRouter.dottedBorderDemo, "dottedBorder边框线", ),

];

var others = [
  Tuple2(APPRouter.notFound, "notFound", ),
  Tuple2(APPRouter.firstPage, "firstPage", ),
  Tuple2(APPRouter.fourthPage, "fourthPage", ),
  Tuple2(APPRouter.loginPage, "LoginPage", ),
  Tuple2(APPRouter.loginPage2, "LoginPage2", ),
  Tuple2(APPRouter.clipDemo, "clipDemo", ),

  Tuple2(APPRouter.navgationBarDemo, "navgationBarDemo", ),
  Tuple2(APPRouter.richTextDemo, "richTextDemo", ),
  Tuple2(APPRouter.testPage, "testPage", ),
  Tuple2(APPRouter.testPageOne, "testPageOne", ),
  Tuple2(APPRouter.decorationDemo, "decorationDemo", ),
  Tuple2(APPRouter.synHomeSrollDemo, "SynHomeSrollDemo", ),
  Tuple2(APPRouter.synHomeNavDemo, "synHomeNavDemo", ),

];

var forms = [
  Tuple2(APPRouter.autocompleteDemo, "autocompleteDemo", ),
  Tuple2(APPRouter.autofillGroupDemo, "autofillGroupDemo", ),

];

var dataTypes = [
  Tuple2(APPRouter.dataTypeDemo, "数据类型", ),

];
