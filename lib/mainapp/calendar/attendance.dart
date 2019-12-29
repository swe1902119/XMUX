import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:xmux/components/floating_card.dart';
import 'package:xmux/components/page_routes.dart';
import 'package:xmux/components/refreshable.dart';
import 'package:xmux/config.dart';
import 'package:xmux/generated/i18n.dart';
import 'package:xmux/globals.dart';
import 'package:xmux/modules/attendance/attendance.dart';
import 'package:xmux/modules/xmux_api/xmux_api_v3.dart';

part 'attendance_lecturer.dart';

// ignore: non_constant_identifier_names
Widget AttendancePage() =>
    store.state.user.isStudent ? _StudentPage() : _LecturerPage();

class _StudentPage extends StatelessWidget {
  final api = AttendanceApi(
    address: BackendApiConfig.attendanceAddress,
    uid: store.state.user.campusId,
  );

  Future<List<AttendanceRecord>> _handleUpdate() async =>
      await api.getHistory();

  @override
  Widget build(BuildContext context) {
    return Refreshable(
      onRefresh: _handleUpdate,
      builder: (context, history) => ListView.separated(
        padding: const EdgeInsets.all(15),
        itemCount: history.length,
        separatorBuilder: (_, index) => AnimationConfiguration.staggeredList(
          position: index,
          duration: const Duration(milliseconds: 250),
          child: SlideAnimation(
            verticalOffset: 50,
            child: Divider(),
          ),
        ),
        itemBuilder: (_, index) => AnimationConfiguration.staggeredList(
          position: index,
          duration: const Duration(milliseconds: 250),
          child: SlideAnimation(
            verticalOffset: 50,
            child: FadeInAnimation(
              child: AttendanceHistoryItem(history[index]),
            ),
          ),
        ),
      ),
    );
  }
}

class AttendanceHistoryItem extends StatelessWidget {
  final AttendanceRecord record;

  AttendanceHistoryItem(this.record);

  /// Localize message from response.
  static String parseMessage(BuildContext context, AttendanceRecord record) {
    var message = record.message;
    switch (record.status) {
      case AttendanceStatus.marked:
        message = S.of(context).Calendar_AttendanceSignInMarked;
        break;
      case AttendanceStatus.succeeded:
        message = S.of(context).Calendar_AttendanceSignInSucceeded;
        break;
      case AttendanceStatus.failed:
        message = S.of(context).Calendar_AttendanceSignInFailed(message);
        break;
    }
    return message;
  }

  @override
  Widget build(BuildContext context) {
    var course = store.state.queryState.timetable.timetable
        .firstWhere((c) => c.cid == record.cid, orElse: () => null);

    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                course?.name ?? 'Unknown',
                style: Theme.of(context).textTheme.subhead,
              ),
              Text(
                '${DateFormat.yMMMd(Localizations.localeOf(context).languageCode).format(record.timestamp)} '
                '${DateFormat.Hms(Localizations.localeOf(context).languageCode).format(record.timestamp)}',
                style: Theme.of(context).textTheme.caption,
              ),
              Text(AttendanceHistoryItem.parseMessage(context, record))
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(record.status == AttendanceStatus.succeeded
              ? Icons.done
              : record.status == AttendanceStatus.failed
                  ? Icons.error_outline
                  : Icons.access_time),
        )
      ],
    );
  }
}