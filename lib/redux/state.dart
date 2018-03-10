import 'package:firebase_auth/firebase_auth.dart';

class MainAppState {
  final bool drawerIsOpen;

  /// Personal info state include uid, password, etc.
  final PersonalInfoState personalInfoState;

  /// Settings state include ePaymentPassword, etc.
  final SettingState settingState;

  /// Homepage state include sliders and announcements.
  final HomePageState homePageState;

  /// AC state include timetable, exams and examResult.
  final ACState acState;

  /// Moodle state.
  final MoodleState moodleState;

  /// Init mainAppState as default.
  MainAppState()
      : this.drawerIsOpen = false,
        this.personalInfoState = new PersonalInfoState(),
        this.settingState = new SettingState(),
        this.homePageState = new HomePageState(),
        this.acState = new ACState(),
        this.moodleState = new MoodleState();

  MainAppState.raw(this.drawerIsOpen, this.personalInfoState, this.settingState,
      this.homePageState, this.acState, this.moodleState);

  MainAppState.fromJson(Map<String, Map> json, {FirebaseUser firebaseUser})
      : this.drawerIsOpen = false,
        this.personalInfoState =
            new PersonalInfoState.fromJson(json["personalInfoState"]),
        this.settingState =
            new SettingState.raw(json["settingState"]["ePaymentPassword"]),
        this.homePageState = new HomePageState(),
        this.acState = new ACState.fromJson(json["acState"]),
        this.moodleState = new MoodleState();

  Map<String, Map> toMap() => {
        "personalInfoState": this.personalInfoState.toMap(),
        "settingState": this.settingState.toMap(),
        "homePageState": {},
        "acState": this.acState.toMap(),
        "moodleState": this.moodleState.toMap(),
      };
}

class PersonalInfoState {
  /// User authentication (Campus ID).
  final String uid, password;

  PersonalInfoState()
      : this.uid = null,
        this.password = null;

  PersonalInfoState.fromJson(Map piJson)
      : this.uid = piJson["uid"],
        this.password = piJson["password"];

  Map<String, String> toMap() => {
        "uid": this.uid,
        "password": this.password,
      };
}

class SettingState {
  /// E-payment password.
  final String ePaymentPassword;

  SettingState() : ePaymentPassword = null;

  SettingState.raw(this.ePaymentPassword);

  Map<String, String> toMap() => {
        "ePaymentPassword": this.ePaymentPassword,
      };
}

class HomePageState {
  /// News for homepage slider.
  final List<Map<String, dynamic>> news;

  /// Announcements for homepage.
  final Map<String, dynamic> announcements;

  HomePageState()
      : this.news = const [],
        this.announcements = const {};
}

class ACState {
  /// AC status (success/error/init).
  final String status;

  /// Error message (available when error).
  String error;

  /// Last update timestamp.
  final int timestamp;

  /// Timetable map.
  final Map<String, dynamic> timetable;

  /// Exams map.
  final Map<String, dynamic> exams;

  /// Exam result Map.
  final Map<String, dynamic> examResult;

  ACState()
      : this.status = "init",
        this.timestamp = null,
        this.timetable = null,
        this.exams = null,
        this.examResult = null;

  ACState.raw(this.status, this.error, this.timestamp, this.timetable,
      this.exams, this.examResult);

  ACState.fromJson(Map<String, dynamic> acJson)
      : this.status = acJson["status"],
        this.timestamp = acJson["timestamp"],
        this.timetable = acJson["data"]["timetable"],
        this.exams = acJson["data"]["exams"],
        this.examResult = acJson["data"]["examResult"],
        this.error = acJson["error"] ?? null;

  Map<String, dynamic> toMap() => {
        "status": this.status,
        "timestamp": this.timestamp,
        "data": {
          "timetable": this.timetable,
          "exams": this.exams,
          "examResult": this.examResult,
        },
        "error": this.error ?? null,
      };

  ACState copyWith(
          {String status,
          String error,
          int timestamp,
          Map<String, dynamic> timetable,
          Map<String, dynamic> exams,
          Map<String, dynamic> examResult}) =>
      new ACState.raw(
        status ?? this.status,
        error ?? this.error,
        timestamp ?? this.timestamp,
        timetable ?? this.timetable,
        exams ?? this.exams,
        examResult ?? this.examResult,
      );
}

class MoodleState {
  /// Moodle token.
  final String token;

  MoodleState() : token = null;

  MoodleState.raw(this.token);

  Map<String, dynamic> toMap() => {"token": this.token};
}