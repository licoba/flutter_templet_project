//
//  NnPickerToolBar.dart
//  flutter_templet_project
//
//  Created by shang on 4/3/23 10:42 AM.
//  Copyright © 4/3/23 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NPickerToolBar extends StatelessWidget {
  const NPickerToolBar({
    super.key,
    this.height = 45,
    this.width = double.infinity,
    this.title = '请选择',
    this.cancelTitle = '取消',
    this.confirmTitle = '确定',
    this.onCancel,
    this.onConfirm,
  });

  final double? width;
  final double? height;
  final String title;
  final String cancelTitle;
  final String confirmTitle;
  final VoidCallback? onCancel;
  final VoidCallback? onConfirm;

  @override
  Widget build(BuildContext context) {
    final toolbar = NavigationToolbar(
      leading: CupertinoButton(
        padding: EdgeInsets.all(12),
        onPressed: onCancel ??
            () {
              Navigator.of(context).pop();
            },
        child: Text(
          cancelTitle,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
      ),
      middle: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black,
          backgroundColor: Colors.white,
          decoration: TextDecoration.none,
        ),
        textAlign: TextAlign.center,
      ),
      trailing: CupertinoButton(
        padding: EdgeInsets.all(12),
        onPressed: confirmTitle.isEmpty ? null : onConfirm,
        child: Text(
          confirmTitle,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );

    return Container(
      height: height,
      width: width,
      // decoration: BoxDecoration(
      //     border: Border.all(color: Colors.blueAccent)
      // ),
      child: toolbar,
    );
  }

  // buildTitleBar({
  //   String title = '请选择',
  //   List<String> actionTitles = const ['取消', '确定'],
  //   required VoidCallback onCancel,
  //   required VoidCallback onConfirm,
  // }) {
  //   return Row(
  //     children: [
  //       CupertinoButton(
  //         padding: EdgeInsets.all(12),
  //         child: Text(actionTitles[0]),
  //         onPressed: onCancel,
  //       ),
  //       Expanded(
  //         child: Text(title,
  //           style: TextStyle(
  //             fontSize: 17,
  //             fontWeight: FontWeight.normal,
  //             color: Colors.black,
  //             backgroundColor: Colors.white,
  //             decoration: TextDecoration.none,
  //           ),
  //           textAlign: TextAlign.center,
  //         )
  //       ),
  //       CupertinoButton(
  //         padding: EdgeInsets.all(12),
  //         child: Text(actionTitles[1]),
  //         onPressed: onConfirm,
  //       ),
  //     ],
  //   );
  // }
}

// /// picker 顶部
// class NToolbar extends StatelessWidget {
//
//   const NToolbar({
//   	super.key,
//   	required this.title,
//     this.onCancel,
//     this.trailing,
//   });
//
//   final String title;
//   final VoidCallback? onCancel;
//   final Widget? trailing;
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 50,
//       child: NavigationToolbar(
//         leading: InkWell(
//           onTap: onCancel ?? (){
//             Navigator.of(context).pop();
//           },
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
//             child: const Text("取消",
//               style: TextStyle(
//                 fontWeight: FontWeight.w500,
//                 fontSize: 16.0,
//                 color: Color(0xff737373),
//               ),
//             ),
//           ),
//         ),
//         middle: Text(title,
//           style: const TextStyle(
//             fontWeight: FontWeight.w500,
//             fontSize: 18.0
//           ),
//           textAlign: TextAlign.center,
//         ),
//         trailing: trailing,
//       ),
//     );
//   }
// }
