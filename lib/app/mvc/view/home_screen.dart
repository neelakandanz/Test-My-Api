import 'dart:convert';

import 'package:flutter/material.dart';

import '../controller/api_controller.dart';

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
  bool _isLoading = false;
  late TabController _tabController;
  final ApiTestHandler _apiTestHandler =
      ApiTestHandler(); // Instantiate the handler

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

      String response = await _apiTestHandler.sendRequest(
        method: _selectedMethod,
        url: url,
        headers: headers,
        body: body,
      );

      setState(() {
        _response = response;
      });
    } catch (e) {
      setState(() {
        _response = 'Error: ${e.toString()}';
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
      appBar: AppBar(title: const Text('API Tester')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                DropdownButton<String>(
                  value: _selectedMethod,
                  items: _methods.map((method) {
                    return DropdownMenuItem(value: method, child: Text(method));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedMethod = value!;
                    });
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _urlController,
                    decoration: const InputDecoration(
                        labelText: 'API URL', border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _isLoading ? null : _sendRequest,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Send'),
                ),
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
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
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
                  padding: const EdgeInsets.all(8.0),
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
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Response:',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(5),
              ),
              child: SingleChildScrollView(
                child: Text(
                  _response,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}