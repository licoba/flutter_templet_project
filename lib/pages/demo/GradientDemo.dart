import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/SectionHeader.dart';
import 'package:flutter_templet_project/extension/buildContext_extension.dart';

class GradientDemo extends StatefulWidget {
  final String? title;

  GradientDemo({Key? key, this.title}) : super(key: key);

  @override
  _GradientDemoState createState() => _GradientDemoState();
}

class _GradientDemoState extends State<GradientDemo> {

  var blendMode = BlendMode.color;
  var tileMode = TileMode.clamp;

  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
          actions: [
            TextButton(
              onPressed: () {
                showSheetTileMode();
              },
              child: Text("$tileMode", style: TextStyle(color: Colors.white),)
            ),
            TextButton(
              onPressed: () {
                showSheetBlendMode();
              },
              child: Text("$blendMode", style: TextStyle(color: Colors.white),)
            ),
          ],
        ),
        body: _buildBody()
    );
  }


  showSheetTileMode() {
    final tileModes = [
      TileMode.clamp,
      TileMode.repeated,
      TileMode.mirror,
      TileMode.decal,
    ];

    final items = tileModes.map((e) => Text('$e')).toList();

    showSheet(
      items: items,
      onSelect: (BuildContext context, int index) {
        tileMode = tileModes[index];
        print("$index, $tileMode");
        setState(() {});
      },
    );
  }
  showSheetBlendMode() {
    final blendModes = [
      BlendMode.clear,
      BlendMode.src,
      BlendMode.dst,
      BlendMode.srcOver,
      BlendMode.dstOver,
      BlendMode.srcIn,
      BlendMode.dstIn,
      BlendMode.srcOut,
      BlendMode.dstOut,
      BlendMode.srcATop,
      BlendMode.dstATop,
      BlendMode.xor,
      BlendMode.plus,
      BlendMode.modulate,
      BlendMode.screen,
      BlendMode.overlay,
      BlendMode.darken,
      BlendMode.lighten,
      BlendMode.colorDodge,
      BlendMode.colorBurn,
      BlendMode.hardLight,
      BlendMode.softLight,
      BlendMode.difference,
      BlendMode.exclusion,
      BlendMode.multiply,
      BlendMode.hue,
      BlendMode.saturation,
      BlendMode.color,
      BlendMode.luminosity,
    ];

    final items = blendModes.map((e) => Text('$e')).toList();

    showSheet(
      items: items,
      onSelect: (BuildContext context, int index) {
        blendMode = blendModes[index];
        print("$index, $blendMode");
        setState(() {});
      },
    );
  }

  showSheet({
    required List<Widget> items,
    required Function(BuildContext context, int index)? onSelect,
  }) {
    context.showCupertinoSheet(
      title: Text('渲染模式'),
      // message: Text(message, textAlign: TextAlign.start),
      items: items,
      cancel: Text('取消'),
      onSelect: onSelect,
    );
  }

  _buildBody() {
    return ListView(children: <Widget>[
      SectionHeader.h4(title: 'LinearGradient',),
      _buildBox(
        text: '两种颜色 均分',
        decoration: BoxDecoration(
            gradient: LinearGradient(
                tileMode: this.tileMode,
                colors: [Color(0xFFFFC125), Color(0xFFFF7F24)]
            )
        ),
      ),
      _buildBox(
          text: '多种颜色 均分',
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  tileMode: this.tileMode,
                  colors: [Color(0xFFFFC125), Color(0xFFFF7F24), Color(0xFFFF4040)]
              )
          ),
      ),
      _buildBox(
          text: '两种颜色 1:3',
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  tileMode: this.tileMode,
                  colors: [Color(0xFFFFC125), Color(0xFFFF7F24), Color(0xFFFF7F24), Color(0xFFFF7F24)]
              )
          ),
      ),

      _buildBox(
          text: '两种颜色 垂直均分 topRight',
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  tileMode: this.tileMode,
                  begin: Alignment.topRight,
                  colors: [Color(0xFFFFC125), Color(0xFFFF7F24)]
              )
          )
      ),

      _buildBox(
          text: '两种颜色 前半部均分 延伸',
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  tileMode: this.tileMode,
                  begin: Alignment(-1.0, 0.0),
                  end: Alignment(0.0, 0.0),
                  // tileMode: TileMode.clamp,
                  colors: [Color(0xFFFFC125), Color(0xFFFF7F24)]
              )
          )
      ),

      _buildBox(
          text: '两种颜色 均分 重复 repeated',
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  tileMode: this.tileMode,
                  begin: Alignment(-1.0, 0.0),
                  end: Alignment(0.0, 0.0),
                  // tileMode: TileMode.repeated,
                  colors: [Color(0xFFFFC125), Color(0xFFFF7F24)]
              )
          )
      ),

      _buildBox(
          text: '两种颜色 均分 mirror',
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  tileMode: this.tileMode,
                  begin: Alignment(-1.0, 0.0),
                  end: Alignment(0.0, 0.0),
                  // tileMode: TileMode.mirror,
                  colors: [Color(0xFFFFC125), Color(0xFFFF7F24)]
              )
          )
      ),

      _buildBox(
          text: '两种颜色 设置起始位置与终止位置 repeated',
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  tileMode: this.tileMode,
                  begin: Alignment.topLeft,
                  end: Alignment(0.5, 0.0),
                  // tileMode: TileMode.repeated,
                  colors: [Color(0xFFFFC125), Color(0xFFFF7F24)],
              )
          )
      ),

      _buildBox(
          text: '两种颜色 设置起始位置与终止位置 repeated',
          decoration: BoxDecoration(
              gradient: LinearGradient(
                tileMode: this.tileMode,
                // begin: Alignment.topLeft,
                // end: Alignment(0.5, 0.0),
                colors: const <Color>[
                  Colors.red, // blue
                  Colors.blue,
                  Colors.yellow,
                ],
                stops: const <double>[0.0, 0.5, 0.8]
              )
          )
      ),
      Divider(),
      SectionHeader.h4(title: 'SweepGradient',),
      _buildBox(
          text: '两种颜色 设置起始位置与终止位置',
          decoration: BoxDecoration(
            gradient: SweepGradient(
                tileMode: this.tileMode,
                // center: AlignmentDirectional(1, -1),
                // startAngle: 1.7,
                // endAngle: 3,
                colors: const <Color>[
                  Colors.red, // blue
                  Colors.blue,
                  Colors.yellow,
                ],
                stops: const <double>[0.0, 0.5, 0.8]
            ),
          ),
      ),
      _buildBox(
        text: 'SweepGradient',
        decoration: BoxDecoration(
          gradient: SweepGradient(
            tileMode: this.tileMode,
            // center: FractionalOffset.topRight,
            startAngle: 2,
            endAngle: 5,
            colors: const <Color>[
              Colors.red, // blue
              Colors.blue,
              Colors.yellow,
            ],
            stops: const <double>[0.0, 0.5, 0.8],
          ),
        ),
      ),
      Divider(),
      SectionHeader.h4(title: 'RadialGradient',),
      _buildBox(
        height: 300,
        text: 'RadialGradient',
        decoration: BoxDecoration(
          gradient: RadialGradient(
            tileMode: this.tileMode,
            // tileMode: TileMode.mirror,
            // radius: 0.5,
            // center: Alignment.center,
            colors: <Color>[
              Colors.red, // blue
              Colors.blue,
              Colors.yellow,
            ],
            stops: const <double>[0.0, 0.5, 0.8],
          ),
        ),
      ),
      Divider(),
      SectionHeader.h4(title: 'ShaderMask - RadialGradient',),
      _buildShaderMask(
        blendMode: BlendMode.color,
        shaderCallback: (Rect bounds) {
          return RadialGradient(
            tileMode: this.tileMode,
            radius: 0.5,
            colors: <Color>[Colors.red, Colors.blue],
          ).createShader(bounds);
        },
      ),
      _buildShaderMask(
        blendMode: BlendMode.srcATop,
        shaderCallback: (Rect bounds) {
          return RadialGradient(
            tileMode: this.tileMode,
            radius: .6,
            colors: <Color>[
              Colors.transparent,
              Colors.transparent,
              Colors.grey.withOpacity(.7),
              Colors.grey.withOpacity(.7)
            ],
            stops: [0, .5, .5, 1],
          ).createShader(bounds);
        },
      ),
    ]);
  }

  Widget _buildBox({
    required String text,
    required Decoration decoration,
    double height: 100,
  }) {
    return Container(
      height: height,
      alignment: Alignment.center,
      child: Text(text, style: TextStyle(color: Colors.white, fontSize: 16.0)),
      margin: const EdgeInsets.fromLTRB(8.0, 3.0, 8.0, 3.0),
      decoration: decoration
    );
  }

  _buildShaderMask({
    required BlendMode blendMode,
    required ShaderCallback shaderCallback
  }) {
    return
      ShaderMask(
        shaderCallback: shaderCallback,
        blendMode: blendMode,
        child: Image.asset(
          'images/bg.jpg',
          fit: BoxFit.cover,
          height: 400,
        ),
      );
  }
}
