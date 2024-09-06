import 'package:flutter/material.dart';

class SliverFillViewportDemo extends StatelessWidget {
  const SliverFillViewportDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SliverFillViewport'),
      ),
      body: buildBody(),
    );
  }

  buildBody() {
    List<Color> colors = Colors.primaries.sublist(6, 10);

    return CustomScrollView(
      slivers: <Widget>[
        SliverFillViewport(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Container(
                color: colors[index],
                child: Center(child: Text('$index')),
              );
            },
            childCount: colors.length,
          ),
          viewportFraction: 1.0,
        ),
      ],
    );
  }
}
