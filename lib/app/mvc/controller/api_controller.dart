import 'package:dio/dio.dart';
import 'dart:convert';

class ApiTestHandler {
  final Dio _dio = Dio();

  Future<String> sendRequest({
    required String method,
    required String url,
    Map<String, dynamic>? headers,
    String? body,
  }) async {
    try {
      Response response;

      // Setting headers and options
      Options options = Options(headers: headers);

      // Sending the request based on the HTTP method
      switch (method.toUpperCase()) {
        case 'POST':
          response = await _dio.post(url, data: body, options: options);
          break;
        case 'PUT':
          response = await _dio.put(url, data: body, options: options);
          break;
        case 'DELETE':
          response = await _dio.delete(url, options: options);
          break;
        case 'GET':
        default:
          response = await _dio.get(url, options: options);
          break;
      }

      return _formatResponse(response);
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }

  String _formatResponse(Response response) {
    try {
      return json.encode(response.data, toEncodable: (obj) => obj.toString());
    } catch (e) {
      return response.toString();
    }
  }
}
