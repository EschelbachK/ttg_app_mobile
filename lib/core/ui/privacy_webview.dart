import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyWebView extends StatefulWidget {
  const PrivacyWebView({super.key});

  @override
  State<PrivacyWebView> createState() => _PrivacyWebViewState();
}

class _PrivacyWebViewState extends State<PrivacyWebView> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()..setJavaScriptMode(JavaScriptMode.unrestricted);
    _load();
  }

  Future<void> _load() async {
    final html = await rootBundle.loadString('assets/legal/privacy.html');
    controller.loadHtmlString(html);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Datenschutz')),
      body: WebViewWidget(controller: controller),
    );
  }
}