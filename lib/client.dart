import 'package:dio/dio.dart';

enum Method {
  post,
  put,
  delete,
  get;
}

enum Endpoint {
  profileChange(Method.put, '/api/users/alter_user '),
  profileLoad(Method.get, 'load-profile'),
  ;

  final String url;
  final Method method;
  const Endpoint(this.method, this.url);
}

class Client {
  static final _instance = Client._private();
  final _dio = Dio()..options.baseUrl = 'http://localhost:3000/';
  factory Client() {
    return _instance;
  }
  Client._private();
  set authToken(String token) {
    _dio.options.headers['Authorization'] = 'Token $token';
  }

  Future<Response?> request({
    required Endpoint endpoint,
    dynamic body,
  }) async {
    Response? response;
    if (endpoint.method == Method.post) {
      response = await _dio.post(endpoint.url, data: body);
    } else if (endpoint.method == Method.get) {
      response = await _dio.get(endpoint.url, data: body);
    } else if (endpoint.method == Method.delete) {
      response = await _dio.delete(endpoint.url, data: body);
    } else if (endpoint.method == Method.put) {
      response = await _dio.put(endpoint.url, data: body);
    }
    return response;
  }
}
