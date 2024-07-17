import './Exceptions.dart';

class Request {
  late Uri url;
  late String method;
  late List headers;
  late var body;

  Request(url, {method = 'get', headers = null, body = null}) {
    if (url is Uri) {
      this.url = url;
    } else if (url is String) {
      this.url = Uri.parse(url);
    } else {
      throw InvalidURLException();
    }

    if (method != null) {
      method = method.toLowerCase();
      if (!['get', 'post', 'put', 'patch', 'delete'].contains(method)) {
        throw InvalidRequestMethodException();
      }
      this.method = method;
    }

    this.headers = (headers == null) ? [] : headers;

    this.body = body;
  }
}
