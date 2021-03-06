// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueryState _$QueryStateFromJson(Map<String, dynamic> json) {
  return QueryState(
    (json['assignments'] as List)
        ?.map((e) => e == null
            ? null
            : AssignmentCourse.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['courses'] as List)
        ?.map((e) =>
            e == null ? null : Course.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['ePaymentRecords'] as List)
        ?.map((e) => e == null
            ? null
            : BillingRecord.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['emgsApplicationResult'] == null
        ? null
        : EmgsApplicationResult.fromJson(
            json['emgsApplicationResult'] as Map<String, dynamic>),
    json['timetable'] == null
        ? null
        : Timetable.fromJson(json['timetable'] as Map<String, dynamic>),
    (json['transcript'] as List)
        ?.map((e) => e == null
            ? null
            : TranscriptSession.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$QueryStateToJson(QueryState instance) =>
    <String, dynamic>{
      'assignments': instance.assignments,
      'courses': instance.courses,
      'ePaymentRecords': instance.ePaymentRecords,
      'emgsApplicationResult': instance.emgsApplicationResult,
      'timetable': instance.timetable,
      'transcript': instance.transcript,
    };
