import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ApiTesterHome extends StatefulWidget {
  const ApiTesterHome({super.key});

  @override
  ApiTesterHomeState createState() => ApiTesterHomeState();
}

class ApiTesterHomeState extends State<ApiTesterHome> with SingleTickerProviderStateMixin {
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _headersController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  final List<String> _methods = ['GET', 'POST', 'PUT', 'DELETE'];
  String _selectedMethod = 'GET';
  String _response = '';
  bool _isLoading = false;
  late TabController _tabController;

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
      Dio dio = Dio();
      String url = _urlController.text.trim();
      Map<String, dynamic> headers = {};
      if (_headersController.text.isNotEmpty) {
        headers = json.decode(_headersController.text);
      }

      Response response;
      switch (_selectedMethod) {
        case 'POST':
          response = await dio.post(url, data: _bodyController.text, options: Options(headers: headers));
          break;
        case 'PUT':
          response = await dio.put(url, data: _bodyController.text, options: Options(headers: headers));
          break;
        case 'DELETE':
          response = await dio.delete(url, options: Options(headers: headers));
          break;
        default:
          response = await dio.get(url, options: Options(headers: headers));
      }

      setState(() {
        _response = _formatResponse(response);
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

  String _formatResponse(Response response) {
    try {
      return json.encode(response.data, toEncodable: (obj) => obj.toString());
    } catch (e) {
      return response.toString();
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
      appBar: AppBar(title: Text('API Tester')),
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
                    decoration: InputDecoration(labelText: 'API URL', border: OutlineInputBorder()),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _isLoading ? null : _sendRequest,
                  child: _isLoading ? CircularProgressIndicator(color: Colors.white) : Text('Send'),
                ),
              ],
            ),
          ),
          TabBar(
            controller: _tabController,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            tabs: [
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
                    decoration: InputDecoration(
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
                    decoration: InputDecoration(
                      hintText: '{"key": "value"}',
                      labelText: 'Body (JSON format)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Response:', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(5),
              ),
              child: SingleChildScrollView(
                child: Text(
                  _response,
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
