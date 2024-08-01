import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ContactUsScreen extends StatefulWidget {
  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    // WebViewControllerを初期化
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('https://forms.gle/fozePqWKkAWmFune8'));  // GoogleフォームのURLを指定
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('お問い合わせ'),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}