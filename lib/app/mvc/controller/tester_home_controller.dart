import 'package:get/get.dart';

import 'api_controller.dart';

class ApiController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxString statusCode = ''.obs;
  final RxString response = ''.obs;
  final RxString time = ''.obs;

  Future<void> sendRequest({
    required String method,
    required String url,
    required Map<String, dynamic> headers,
    required String body,
  }) async {
    isLoading.value = true;

    try {
      // Call your API handler and fetch the result
      final result = await ApiTestHandler().sendRequest(
        method: method,
        url: url,
        headers: headers,
        body: body,
      );

      statusCode.value = result['statusCode'] ?? 'N/A';
      response.value = result['response'] ?? 'No Response';
      time.value = result['time'] ?? 'N/A'; // Time taken for the request
    } catch (e) {
      response.value = 'Error: ${e.toString()}';
      statusCode.value = 'error';
    } finally {
      isLoading.value = false;
    }
  }
}
