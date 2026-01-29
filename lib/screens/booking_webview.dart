import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BookingWebViewPage extends StatefulWidget {
  final String url;

  const BookingWebViewPage({
    super.key,
    required this.url,
  });

  @override
  State<BookingWebViewPage> createState() => _BookingWebViewPageState();
}

class _BookingWebViewPageState extends State<BookingWebViewPage> {
  late final WebViewController _controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    if (!kIsWeb) {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadRequest(Uri.parse(widget.url));
    }

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            setState(() => isLoading = false);
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Booking")),
      body: kIsWeb 
        ? Center(child: Text("WebView is not supported on Web. Use URL Launcher instead."))
        : WebViewWidget(controller: _controller),
    );
  }
}