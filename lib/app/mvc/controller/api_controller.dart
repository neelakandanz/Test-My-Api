import 'package:dio/dio.dart';
import 'dart:convert';

class ApiTestHandler {
  final Dio _dio = Dio();

  Future<Map<String, String>> sendRequest({
    required String method,
    required String url,
    Map<String, dynamic>? headers,
    String? body,
  }) async {
    final stopwatch = Stopwatch()..start(); // Start tracking the request time

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

      stopwatch.stop(); // Stop the stopwatch after the request completes

      // Get the elapsed time
      String elapsedTime = '${stopwatch.elapsed.inMilliseconds} ms';

      // Return the status code, response, and time taken
      return {
        'statusCode': response.statusCode.toString(),
        'response': _formatResponse(response),
        'time': elapsedTime,
      };
    } catch (e) {
      stopwatch.stop(); // Ensure we stop the stopwatch in case of an error

      String errorMessage =
          'An unknown error occurred\nError details:\n${e.toString()}';
      String errorCode = 'Error';
      String elapsedTime = '${stopwatch.elapsed.inMilliseconds} ms';

      // Return error details along with the time taken
      return {
        'statusCode': errorCode,
        'response': errorMessage,
        'time': elapsedTime,
      };
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
