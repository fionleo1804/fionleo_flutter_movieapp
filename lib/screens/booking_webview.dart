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
      appBar: AppBar(
        title: const Text('Book Movie'),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}