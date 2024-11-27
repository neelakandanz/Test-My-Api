import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/ui/status_row.dart';

import '../../ui/url_input_field.dart';
import '../../utils/copyutils.dart';
import '../../utils/pretty_json.dart';
import '../controller/tester_home_controller.dart';
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
  late TabController _tabController;
  final ApiController _apiController = Get.put(ApiController());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: DropdownButton<String>(
                      underline: Container(),
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
                  const SizedBox(width: 2),
                  Expanded(
                    child: UrlInputField(controller: _urlController),
                  ),
                  const SizedBox(width: 0),
                  Obx(
                    () => ElevatedButton(
                      onPressed: _apiController.isLoading.value
                          ? null
                          : () {
                              _apiController.sendRequest(
                                method: _selectedMethod,
                                url: _urlController.text.trim(),
                                headers: _headersController.text.isNotEmpty
                                    ? json.decode(_headersController.text)
                                    : {},
                                body: _bodyController.text.trim(),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 32,
                        ),
                      ),
                      child: _apiController.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Send'),
                    ),
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
                      final formattedResponse =
                          formatResponse(_apiController.response.value);
                      CopyUtils.copyToClipboard(context, formattedResponse);
                    },
                    icon: const Icon(Icons.copy),
                  )
                ],
              ),
            ),
            Obx(
              () => StatusRow(
                status: _apiController.statusCode.value,
                size: '${_apiController.response.value.length} KB',
                time: _apiController.time.value,
              ),
            ),
            Obx(
              () => ResponseViewer(
                response: _apiController.response.value,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
