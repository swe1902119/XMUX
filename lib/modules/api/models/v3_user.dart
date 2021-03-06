import 'package:json_annotation/json_annotation.dart';

part 'v3_user.g.dart';

@JsonSerializable(createToJson: false)
class LoginResp {
  final String customToken;

  LoginResp(this.customToken);

  static LoginResp fromJson(Map<String, dynamic> json) =>
      _$LoginRespFromJson(json);
}

@JsonSerializable(createToJson: false)
class Device {
  final String deviceId;
  final String deviceModel;
  final String deviceName;
  @JsonKey(name: 'lastSeenS')
  final DateTime lastSeen;

  Device(this.deviceId, this.deviceModel, this.deviceName, this.lastSeen);

  static Device fromJson(Map<String, dynamic> json) => _$DeviceFromJson(json);
}

@JsonSerializable()
class Profile {
  final String displayName;
  final String avatar;
  final String name;
  final String nationality;
  final String id;

  Profile(this.displayName, this.avatar, this.name, this.nationality, this.id);

  static Profile fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileToJson(this);
}
