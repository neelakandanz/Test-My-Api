import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:myapp/app/ui/status_row.dart';

import '../../ui/url_input_field.dart';
import '../../utils/copyutils.dart';
import '../../utils/pretty_json.dart';
import '../controller/api_controller.dart';
import 'widget/response_viewer.dart';

class ApiTesterHome extends StatefulWidget {
  const ApiTesterHome({super.key});

  @override
  ApiTesterHomeState createState() => ApiTesterHomeState();
}

class ApiTesterHomeState extends State<ApiTesterHome>
    with SingleTickerProviderStateMixin {
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _headersController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  final List<String> _methods = ['GET', 'POST', 'PUT', 'DELETE'];
  String _selectedMethod = 'GET';
  String _response = '';
  String _statusCode = ''; // Store the status code
  bool _isLoading = false;
  late TabController _tabController;
  final ApiTestHandler _apiTestHandler = ApiTestHandler(); // Instantiate the handler

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<void> _sendRequest() async {
    setState(() {
      _isLoading = true;
    });

    try {
      String url = _urlController.text.trim();
      Map<String, dynamic> headers = {};
      if (_headersController.text.isNotEmpty) {
        headers = json.decode(_headersController.text);
      }

      String body = _bodyController.text;

      // Send the request and get the response and status code
      final result = await _apiTestHandler.sendRequest(
        method: _selectedMethod,
        url: url,
        headers: headers,
        body: body,
      );
      setState(() {
        _statusCode = result['statusCode'] ?? 'N/A';
        _response = result['response'] ?? 'No Response';
      });
    } catch (e) {
      setState(() {
        _response = 'Error: ${e.toString()}';
        _statusCode = 'error';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    _headersController.dispose();
    _bodyController.dispose();
    _tabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TEST MY API'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Row(
                children: [
                  Container(
                    //     height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.black,
                          width: 2), // Set border color and width
                      borderRadius: BorderRadius
                          .zero, // No rounded corners, rectangular shape
                    ),
                    child: DropdownButton<String>(
                      underline: Container(), // Hide the default underline
                      value: _selectedMethod,
                      items: _methods.map((method) {
                        return DropdownMenuItem(
                          value: method,
                          child: Text(method),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedMethod = value!;
                        });
                      },
                    ),
                  ),

                  const SizedBox(
                    width: 2,
                  ),
                  Expanded(
                    child: UrlInputField(controller: _urlController),
                  ), // Use the new class here

                  const SizedBox(width: 0),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _sendRequest,
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius
                            .zero, // No rounded corners, fully rectangular
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 32), // Adjust padding as needed
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Send'),
                  )
                ],
              ),
            ),
            TabBar(
              controller: _tabController,
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(text: 'Headers'),
                Tab(text: 'Body'),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 4,
              child: TabBarView(
                controller: _tabController,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 6.0, horizontal: 2),
                    child: TextField(
                      controller: _headersController,
                      maxLines: 10,
                      decoration: const InputDecoration(
                        hintText: '{"key": "value"}',
                        labelText: 'Headers (JSON format)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 6.0, horizontal: 2),
                    child: TextField(
                      controller: _bodyController,
                      maxLines: 10,
                      decoration: const InputDecoration(
                        hintText: '{"key": "value"}',
                        labelText: 'Body (JSON format)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Response',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () async {
                      final formattedResponse = formatResponse(_response);
                      CopyUtils.copyToClipboard(context, formattedResponse);
                    },
                    icon: const Icon(Icons.copy),
                  )
                ],
              ),
            ),
              // Display status code and response
            StatusRow(
              status: _statusCode,
              size: '${_response.length} KB',  // Estimate size from response length
              time: 'N/A',  // You can add time tracking logic here if needed
            ),
            ResponseViewer(
              response: _response,
            ),
          ],
        ),
      ),
    );
  }
}
