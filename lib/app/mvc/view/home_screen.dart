import 'dart:convert';

import 'package:flutter/material.dart';

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
      appBar: AppBar(
        title: const Text('TEST MY API'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(

        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Row(
                children: [
                  Container(
                    height: 50,
                    color: Colors.amber,
                    child: DropdownButton<String>(
                      underline: Container(),
                      value: _selectedMethod,
                      items: _methods.map((method) {
                        return DropdownMenuItem(
                            value: method, child: Text(method));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedMethod = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                   // width: MediaQuery.of(context).size.width /2,
                    child: TextField(
                      controller: _urlController,
                      decoration: const InputDecoration(
                          labelText: 'API URL', border: OutlineInputBorder()),
                    ),
                  ),
                  const SizedBox(width: 0),
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
            SizedBox(
              height: MediaQuery.of(context).size.height / 4,
              child: TabBarView(
                controller: _tabController,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(2.0),
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
                    padding: const EdgeInsets.all(2.0),
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
                      onPressed: () {
                        final formattedResponse = formatResponse(_response);
                        CopyUtils.copyToClipboard(context, formattedResponse);
                      },
                      icon: const Icon(Icons.copy))
                ],
              ),
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
