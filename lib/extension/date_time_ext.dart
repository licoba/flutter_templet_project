//
//  date_time_ext.dart
//  flutter_templet_project
//
//  Created by shang on 9/21/21 7:10 PM.
//  Copyright © 9/21/21 shang. All rights reserved.
//


extension DateTimeExt on DateTime {
  /// 打印代码执行时间
  static double logDifference(DateTime before) {
    final now = DateTime.now();
    final gap = now.difference(before).inMilliseconds;
    final seconds = gap / 1000;
    return seconds;
  }

  // /// 打印代码执行时间
  // bool isSameDay(DateTime date) {
  //   // ignore hour,minute,second..
  //   final dateFormat = DateFormat("yyyy-MM-dd");
  //   final date1 = dateFormat.format(this);
  //   final date2 = dateFormat.format(date);
  //   return date1 == date2;
  // }

  String toString19() => toString().split(".").first;

}


// const duration = Duration(seconds: 123);
// print('Days: ${duration.inDaysRest}'); // 0
// print('Hours: ${duration.inHoursRest}'); // 0
// print('Minutes: ${duration.inMinutesRest}'); // 2
// print('Seconds: ${duration.inSecondsRest}'); // 3
// print('Milliseconds: ${duration.inMillisecondsRest}'); // 0
// print('Microseconds: ${duration.inMicrosecondsRest}'); // 0

extension DurationExt on Duration {
  int get inDaysRest => inDays;
  int get inHoursRest => inHours - (inDays * 24);
  int get inMinutesRest => inMinutes - (inHours * 60);
  int get inSecondsRest => inSeconds - (inMinutes * 60);
  int get inMillisecondsRest => inMilliseconds - (inSeconds * 1000);
  int get inMicrosecondsRest => inMicroseconds - (inMilliseconds * 1000);
}


// String _formatTime(String dateTimeStr)
//   DateTime dateTime = DateTime.parse(dateTimeStr);
//   return DateFormat("MM-dd HH:mm").format(dateTime);
// }