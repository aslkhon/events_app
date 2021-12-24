import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SingleEventScreen extends StatelessWidget {
  static const routeName = '/event';

  const SingleEventScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: Center(
          child: Text(
            args.title,
            style: Theme.of(context)
                .textTheme
                .bodyText1
                ?.copyWith(color: Colors.black87),
          ),
        ),
      ),
      body: WebView(
        initialUrl: args.url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}

class ScreenArguments {
  final String title;
  final String url;

  ScreenArguments({required this.title, required this.url});
}
