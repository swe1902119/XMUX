library xmux.api_v2;

import 'dart:ui';

import 'package:dio/dio.dart';

import 'models/models_v2.dart';

export 'models/models_v2.dart';

/// The authentication method for XMUX API.
class XMUXApiAuth {
  final String campusID;
  final String campusIDPassword;
  final String ePaymentPassword;

  /// Moodle key is only used for speeding up moodle fetching.
  final String moodleKey;

  XMUXApiAuth(
      {this.campusID,
      this.campusIDPassword,
      this.ePaymentPassword,
      this.moodleKey});
}

/// The general exception for XMUX API.
class XMUXApiException implements Exception {
  /// The error from server.
  final String message;

  /// The type of error.
  final String type;

  XMUXApiException(this.message, this.type);

  String toString() =>
      'XMUXApiV2/${type != null ? type : "Exception"}: $message';
}

/// The general response of XMUX API V2 from server.
class XMUXApiResponse<dataType> {
  /// Status of API call including *success* and *error*.
  ///
  /// **Attention:**
  /// This status *only* only represent the status of server-side processing.
  final String status;

  /// The time of this request being processed.
  final DateTime timestamp;

  /// Response data.
  final dataType data;

  /// Moodle token. Only available when moodle token refreshed.
  String moodleKey;

  XMUXApiResponse(this.status, this.timestamp, this.data, {this.moodleKey});
}

/// XMUX API V2
class XMUXApi {
  /// Back-end API addresses.
  final List<String> addresses;

  /// The API address currently used.
  String get currentAddress => _dio.options.baseUrl.replaceAll('/v2', '');

  set currentAddress(String a) => _dio.options.baseUrl = '$a/v2';

  /// Dio instance for http requests.
  final _dio = Dio();

  /// Callback to get ID token from firebaseUser.
  /// Should be assigned before using APIs need JWT token.
  Future<String> Function() getIdToken;

  /// Unique instance of XMUXApi.
  static XMUXApi instance;

  factory XMUXApi(List<String> addresses) {
    if (instance == null) instance = XMUXApi._(addresses);
    return instance;
  }

  XMUXApi._(this.addresses) {
    currentAddress = addresses[0];

    // Dio options.
    _dio.options.connectTimeout = 5000;
    configure();
  }

  /// Configure XMUX API V2.
  void configure({String jwt}) {
    // Add system language to header.
    _dio.options.headers.addAll({
      'Accept-Language':
          '${window.locale?.languageCode ?? 'en'}-${window.locale?.countryCode ?? 'US'},'
              '${window.locale?.languageCode ?? 'en'};q=0.9'
    });

    // Add JWT token if exist.
    if (jwt != null)
      _dio.options.headers.addAll({'Authorization': 'Bearer $jwt'});
    else
      _dio.options.headers.remove('Authorization');
  }

  XMUXApiResponse<ResponseType> _generateResponse<JsonType, ResponseType>(
      Response<Map<String, dynamic>> response,
      ResponseType fromJson(JsonType json)) {
    // If status is error, throw an Exception contains error message.
    if (response.data['status'] == 'error')
      throw XMUXApiException(
          response.data['error'], response.data['errorType']);
    // Construct response from json.
    return XMUXApiResponse<ResponseType>(
        response.data['status'],
        DateTime.fromMillisecondsSinceEpoch(response.data['timestamp']),
        fromJson(response.data['data']),
        moodleKey: response.data['moodleKey']);
  }

  Future<XMUXApiResponse<AcData>> ac(XMUXApiAuth auth) async {
    var response = await _dio.post<Map<String, dynamic>>('/ac',
        data: {'id': auth.campusID, 'pass': auth.campusIDPassword});
    return _generateResponse<Map<String, dynamic>, AcData>(
        response, AcData.fromJson);
  }

  Future<XMUXApiResponse<List<BillingRecord>>> bill(XMUXApiAuth auth) async {
    var response = await _dio.post<Map<String, dynamic>>('/bill',
        data: {'id': auth.campusID, 'pass': auth.ePaymentPassword});
    return _generateResponse<List, List<BillingRecord>>(
        response, (b) => b.map((b) => BillingRecord.fromJson(b)).toList());
  }

  Future<XMUXApiResponse<List<Announcement>>> homepageAnnouncements(
      XMUXApiAuth auth) async {
    var response = await _dio.post<Map<String, dynamic>>(
        '/homepage/announcements',
        data: {'id': auth.campusID});
    return _generateResponse<Map<String, dynamic>, List<Announcement>>(
        response,
        (n) => (n['announcements'] as List)
            .map((n) => Announcement.fromJson(n))
            .toList());
  }

  Future<XMUXApiResponse<List<News>>> homepageNews() async {
    var response = await _dio.get<Map<String, dynamic>>('/homepage/news');
    return _generateResponse<Map<String, dynamic>, List<News>>(response,
        (n) => (n['news'] as List).map((n) => News.fromJson(n)).toList());
  }
}
