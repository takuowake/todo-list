import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';

class PrivacyPolicyScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final webViewController = WebViewController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy'),
      ),
      body: FutureBuilder(
        future: _loadHtmlFromAssets(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final htmlData = snapshot.data;
            if (htmlData != null) {
              webViewController.loadRequest(Uri.dataFromString(
                htmlData,
                mimeType: 'text/html',
                encoding: Encoding.getByName('utf-8'),
              ));
            }
            return WebViewWidget(controller: webViewController);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Future<String> _loadHtmlFromAssets(BuildContext context) async {
    return await DefaultAssetBundle.of(context).loadString('assets/privacy_policy.html');
  }
}
