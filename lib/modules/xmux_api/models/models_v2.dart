import 'package:flutter/material.dart' show TimeOfDay;
import 'package:json_annotation/json_annotation.dart';
import 'package:xmux/modules/common/duration_of_day.dart';

part 'ac_v2.dart';
part 'models_v2.g.dart';
part 'moodle_v2.dart';

@JsonSerializable()
class BillingRecord {
  final String item;
  @JsonKey(fromJson: _amountFromJson, toJson: _amountToJson)
  final double amount;
  final String balance;
  BillingRecord(this.item, this.amount, this.balance);

  factory BillingRecord.fromJson(Map<String, dynamic> json) =>
      _$BillingRecordFromJson(json);

  get isPaid => balance == '-';

  Map<String, dynamic> toJson() => _$BillingRecordToJson(this);

  static double _amountFromJson(String amount) =>
      double.parse(amount.replaceAll(',', ''));

  static String _amountToJson(double amount) => amount.toStringAsFixed(2);
}
