import 'dart:convert';

import './Exceptions.dart';

class Response {
  late int code;
  late String status;
  late String message;
  late var data;

  static String SUCCESS = 'success';

  Response({code = 0, status = 'unknown', message = 'Unknown', data = null}) {
    this.code = code;

    this.status = status.trim().toLowerCase();

    this.message = message;

    this.data = data;
  }

  Response.fromJson(jsonText) {
    var json;

    try {
      json = jsonDecode(jsonText);
    } catch (e) {
      throw InvalidResponseException();
    }

    this.code = json.containsKey('code') ? _parseInt(json['code']) : 0;

    this.status = json['status'].trim().toLowerCase();

    this.message = json.containsKey('message') ? json['message'] : '';

    this.data = json.containsKey('data') ? json['data'] : '';
  }

  _parseInt(v) {
    if (v is int) {
      return v;
    } else if (v is String) {
      return int.parse(v);
    }
    return null;
  }
}
