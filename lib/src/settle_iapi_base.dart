import 'dart:convert';
import 'dart:io';

import './Request.dart';
import './Response.dart';
import './Exceptions.dart';

class SettleIAPI {
  String baseUrl = 'https://settle.africa/';

  var client;

  String id = 'settle';
  String token = 'africa';
  String expiry = '';

  bool isAuthorized = false;

  SettleIAPI._privateConstructor() {
    client = HttpClient();
    client.connectionTimeout = const Duration(seconds: 60);
  }

  factory SettleIAPI() {
    return _instance;
  }

  static final SettleIAPI _instance = SettleIAPI._privateConstructor();

  Future<dynamic> request(Request payload, [dynamic callback]) async {
    try {
      HttpClientRequest request =
          await client.openUrl(payload.method, payload.url);

      request.headers.removeAll(
          HttpHeaders.acceptEncodingHeader); //removes gzip encoding header

      List header;
      String key;
      String value;
      for (var i = 0; i < payload.headers.length; i++) {
        header = payload.headers[i].split(':');

        key = header.removeAt(0).trim();
        value = header.join(':').trim();

        request.headers.set(key, value);
      }

      if (payload.body != null) {
        request.write(payload.body);
      }

      HttpClientResponse response = await request.close();
      print(response.statusCode);
      if (response.statusCode == 200) {
        String responseText = await response.transform(utf8.decoder).join();
        Response responseBody = Response.fromJson(responseText);
        if (callback is Function) {
          return callback(responseBody);
        } else {
          return responseBody;
        }
      } else {
        throw NetworkErrorException(response.statusCode);
      }
    } on SocketException {
      throw NetworkErrorException(0);
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> fetchCountries([dynamic callback]) async {
    Request payload = Request('${baseUrl}countries',
        method: 'get',
        headers: ['Content-Type: application/json', 'id: $id', 'token: $token'],
        body: null);
    return await request(payload, (Response response) {
      if (response.status != Response.SUCCESS) {
        throw ServerErrorException(response.code, response.message);
      }
      if (callback is Function) {
        return callback(response.data);
      } else {
        return response.data;
      }
    });
  }

  Future<dynamic> fetchRegions(Map data, [dynamic callback]) async {
    Request payload = Request('${baseUrl}regions/${data['countryId']}',
        method: 'get',
        headers: ['Content-Type: application/json', 'id: $id', 'token: $token'],
        body: null);
    return await request(payload, (Response response) {
      if (response.status != Response.SUCCESS) {
        throw ServerErrorException(response.code, response.message);
      }
      if (callback is Function) {
        return callback(response.data);
      } else {
        return response.data;
      }
    });
  }

  Future<dynamic> fetchCities(Map data, [dynamic callback]) async {
    Request payload = Request('${baseUrl}cities/${data['regionId']}',
        method: 'get',
        headers: ['Content-Type: application/json', 'id: $id', 'token: $token'],
        body: null);
    return await request(payload, (Response response) {
      if (response.status != Response.SUCCESS) {
        throw ServerErrorException(response.code, response.message);
      }
      if (callback is Function) {
        return callback(response.data);
      } else {
        return response.data;
      }
    });
  }

  Future<dynamic> fetchLanguages([dynamic callback]) async {
    Request payload = Request('${baseUrl}languages',
        method: 'get',
        headers: ['Content-Type: application/json', 'id: $id', 'token: $token'],
        body: null);
    return await request(payload, (Response response) {
      if (response.status != Response.SUCCESS) {
        throw ServerErrorException(response.code, response.message);
      }
      if (callback is Function) {
        return callback(response.data);
      } else {
        return response.data;
      }
    });
  }

  Future<dynamic> fetchIdTypes(Map data, [dynamic callback]) async {
    Request payload = Request('${baseUrl}idtypes/${data['countryId']}',
        method: 'get',
        headers: ['Content-Type: application/json', 'id: $id', 'token: $token'],
        body: null);
    return await request(payload, (Response response) {
      if (response.status != Response.SUCCESS) {
        throw ServerErrorException(response.code, response.message);
      }
      if (callback is Function) {
        return callback(response.data);
      } else {
        return response.data;
      }
    });
  }

  Future<dynamic> fetchAccategories([dynamic callback]) async {
    Request payload = Request('${baseUrl}accategories',
        method: 'get',
        headers: ['Content-Type: application/json', 'id: $id', 'token: $token'],
        body: null);
    return await request(payload, (Response response) {
      if (response.status != Response.SUCCESS) {
        throw ServerErrorException(response.code, response.message);
      }
      if (callback is Function) {
        return callback(response.data);
      } else {
        return response.data;
      }
    });
  }

  Future<dynamic> register(Map data, [dynamic callback]) async {
    Request payload = Request('${baseUrl}register',
        method: 'post',
        headers: ['Content-Type: application/json', 'id: $id', 'token: $token'],
        body: jsonEncode(data));
    return await request(payload, (Response response) {
      if (response.status != Response.SUCCESS) {
        throw ServerErrorException(response.code, response.message);
      }
      if (callback is Function) {
        return callback();
      }
    });
  }

  Future<dynamic> confirmRegistration(Map data, [dynamic callback]) async {
    Request payload = Request('${baseUrl}register',
        method: 'post',
        headers: ['Content-Type: application/json', 'id: $id', 'token: $token'],
        body: jsonEncode(data));
    return await request(payload, (Response response) {
      if (response.status != Response.SUCCESS) {
        throw ServerErrorException(response.code, response.message);
      }
      if (callback is Function) {
        return callback();
      }
    });
  }

  Future<dynamic> recoverPassword(Map data, [dynamic callback]) async {
    Request payload = Request('${baseUrl}recover',
        method: 'post',
        headers: ['Content-Type: application/json', 'id: $id', 'token: $token'],
        body: jsonEncode(data));
    return await request(payload, (Response response) {
      if (response.status != Response.SUCCESS) {
        throw ServerErrorException(response.code, response.message);
      }
      if (callback is Function) {
        return callback();
      }
    });
  }

  Future<dynamic> changePassword(Map data, [dynamic callback]) async {
    Request payload = Request('${baseUrl}recover',
        method: 'post',
        headers: ['Content-Type: application/json', 'id: $id', 'token: $token'],
        body: jsonEncode(data));
    return await request(payload, (Response response) {
      if (response.status != Response.SUCCESS) {
        throw ServerErrorException(response.code, response.message);
      }
      if (callback is Function) {
        return callback();
      }
    });
  }

  Future<dynamic> resendOTP(Map data,
      {String type = 'signup', required String phone, dynamic callback}) async {
    String url = (type == 'recover') ? 'recover/${phone}' : 'reotp/${phone}';
    Request payload = Request(
      '${baseUrl}$url',
      method: 'get',
      headers: ['Content-Type: application/json', 'id: $id', 'token: $token'],
      body: null,
    );
    print(url);

    return await request(payload, (Response response) {
      if (response.status != Response.SUCCESS) {
        throw ServerErrorException(response.code, response.message);
      }
      if (callback is Function) {
        return callback(
            response.message); // Pass response.message to the callback
      }
    });
  }

  Future<dynamic> login(Map data, [dynamic callback]) async {
    Request payload = Request('${baseUrl}login',
        method: 'post',
        headers: ['Content-Type: application/json', 'id: $id', 'token: $token'],
        body: jsonEncode(data));
    return await request(payload, (Response response) {
      if (response.status != Response.SUCCESS) {
        throw ServerErrorException(response.code, response.message);
      }

      id = response.data['id'];
      token = response.data['token'];
      expiry = response.data['expiry'];
      isAuthorized = true;

      if (callback is Function) {
        return callback();
      }
    });
  }

  Future<dynamic> updateProfile(Map data, [dynamic callback]) async {
    if (!isAuthorized) {
      throw UnauthorizedRequestException();
    }

    Request payload = Request('${baseUrl}profile',
        method: 'post',
        headers: [
          'Content-Type: application/json',
          'id: $id',
          'token: $token',
          'expiry: $expiry'
        ],
        body: null);
    return await request(payload, (Response response) {
      if (response.status != Response.SUCCESS) {
        throw ServerErrorException(response.code, response.message);
      }
      if (callback is Function) {
        return callback();
      }
    });
  }

  Future<dynamic> fetchTransaction(Map data, [dynamic callback]) async {
    if (!isAuthorized) {
      throw UnauthorizedRequestException();
    }

    Request payload = Request('${baseUrl}transaction/${data['id']}',
        method: 'get',
        headers: [
          'Content-Type: application/json',
          'id: $id',
          'token: $token',
          'expiry: $expiry'
        ],
        body: null);
    return await request(payload, (Response response) {
      if (response.status != Response.SUCCESS) {
        throw ServerErrorException(response.code, response.message);
      }
      if (callback is Function) {
        return callback(response.data);
      } else {
        return response.data;
      }
    });
  }

  Future<dynamic> fetchTransactions(Map data, [dynamic callback]) async {
    if (!isAuthorized) {
      throw UnauthorizedRequestException();
    }

    String limit;
    if (data.containsKey('from') && data.containsKey('to')) {
      limit = '/${data['from']}/${data['to']}';
    } else {
      limit = '';
    }

    Request payload = Request('${baseUrl}transactions${limit}',
        method: 'get',
        headers: [
          'Content-Type: application/json',
          'id: $id',
          'token: $token',
          'expiry: $expiry'
        ],
        body: null);
    return await request(payload, (Response response) {
      if (response.status != Response.SUCCESS) {
        throw ServerErrorException(response.code, response.message);
      }
      if (callback is Function) {
        return callback(response.data);
      } else {
        return response.data;
      }
    });
  }

  Future<dynamic> fetchProfile([dynamic callback]) async {
    if (!isAuthorized) {
      throw UnauthorizedRequestException();
    }

    Request payload = Request('${baseUrl}profile',
        method: 'get',
        headers: [
          'Content-Type: application/json',
          'id: $id',
          'token: $token',
          'expiry: $expiry'
        ],
        body: null);
    return await request(payload, (Response response) {
      if (response.status != Response.SUCCESS) {
        throw ServerErrorException(response.code, response.message);
      }
      if (callback is Function) {
        return callback(response.data);
      } else {
        return response.data;
      }
    });
  }

  Future<dynamic> fetchMethods(Map data, [dynamic callback]) async {
    if (!isAuthorized) {
      throw UnauthorizedRequestException();
    }

    Request payload = Request('${baseUrl}fis/${data['countryId']}',
        method: 'get',
        headers: [
          'Content-Type: application/json',
          'id: $id',
          'token: $token',
          'expiry: $expiry'
        ],
        body: null);
    return await request(payload, (Response response) {
      if (response.status != Response.SUCCESS) {
        throw ServerErrorException(response.code, response.message);
      }
      if (callback is Function) {
        return callback(response.data);
      } else {
        return response.data;
      }
    });
  }

  Future<dynamic> validateFIN(Map data, [dynamic callback]) async {
    if (!isAuthorized) {
      throw UnauthorizedRequestException();
    }

    Request payload = Request(
        '${baseUrl}fisit/${data['fid']}/${data['accountNumber']}',
        method: 'get',
        headers: [
          'Content-Type: application/json',
          'id: $id',
          'token: $token',
          'expiry: $expiry'
        ],
        body: null);
    return await request(payload, (Response response) {
      if (response.status != Response.SUCCESS) {
        throw ServerErrorException(response.code, response.message);
      }
      if (callback is Function) {
        return callback(response.data);
      } else {
        return response.data;
      }
    });
  }

  Future<dynamic> fetchRates(Map data, [dynamic callback]) async {
    if (!isAuthorized) {
      throw UnauthorizedRequestException();
    }

    Request payload = Request(
        '${baseUrl}rates/${data['source']}/${data['destination']}/${data['amount']}',
        method: 'get',
        headers: [
          'Content-Type: application/json',
          'id: $id',
          'token: $token',
          'expiry: $expiry'
        ],
        body: null);
    return await request(payload, (Response response) {
      if (response.status != Response.SUCCESS) {
        throw ServerErrorException(response.code, response.message);
      }
      if (callback is Function) {
        return callback(response.data);
      } else {
        return response.data;
      }
    });
  }

  Future<dynamic> fetchCharges(Map data, [dynamic callback]) async {
    if (!isAuthorized) {
      throw UnauthorizedRequestException();
    }

    Request payload = Request(
        '${baseUrl}rates/${data['source']}/${data['destination']}/${data['method']}/${data['amount']}',
        method: 'get',
        headers: [
          'Content-Type: application/json',
          'id: $id',
          'token: $token',
          'expiry: $expiry'
        ],
        body: null);
    return await request(payload, (Response response) {
      if (response.status != Response.SUCCESS) {
        throw ServerErrorException(response.code, response.message);
      }
      if (callback is Function) {
        return callback(response.data);
      } else {
        return response.data;
      }
    });
  }

  Future<dynamic> transfer(Map data, [dynamic callback]) async {
    if (!isAuthorized) {
      throw UnauthorizedRequestException();
    }

    Request payload = Request('${baseUrl}transfer',
        method: 'post',
        headers: [
          'Content-Type: application/json',
          'id: $id',
          'token: $token',
          'expiry: $expiry'
        ],
        body: jsonEncode(data));
    return await request(payload, (Response response) {
      if (response.status != Response.SUCCESS) {
        throw ServerErrorException(response.code, response.message);
      }
      if (callback is Function) {
        return callback();
      }
    });
  }

  Future<dynamic> report(Map data, [dynamic callback]) async {
    Request payload = Request('${baseUrl}transfer/dispute',
        method: 'post',
        headers: [
          'Content-Type: application/json',
          'id: $id',
          'token: $token',
          'expiry: $expiry'
        ],
        body: jsonEncode(data));
    return await request(payload, (Response response) {
      if (response.status != Response.SUCCESS) {
        throw ServerErrorException(response.code, response.message);
      }
      if (callback is Function) {
        return callback();
      }
    });
  }

  void _resetToken() {
    id = '';
    token = '';
    expiry = '';
    isAuthorized = false;
  }

  Future<void> logout() async {
    _resetToken();
  }
}
