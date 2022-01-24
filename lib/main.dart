import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

// TODO PRINT REDIRECT URL

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  late WebViewController _webViewController;
  late String _myCode;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          child: WebView(
            javascriptMode: JavascriptMode.unrestricted,
            initialUrl: 'http://smartids-uat.cpf.co.th/ids-portal/authorize?'
                'client_id=CIEJaa_EqGP6cNhepd4IYA'
                '&response_type=code'
                '&redirect_uri=https%3A%2F%2Fcrminsight-uat.cpf.co.th%2F'
                'app&scope=openid%20profile%20email%20phone'
                '&state=z5VxDzlglY',
            onWebViewCreated: (controller) {
              _webViewController = controller;
            },
            onPageStarted: (url) {
              print('New WEBSITE $url');
              // TODO BREAK  https://crminsight-uat.cpf.co.th/app/?code=
              if (url.contains('https://crminsight-uat.cpf.co.th/app/?code=')) {
                Future.delayed(Duration(milliseconds: 300), () {
                  // Print code
                  _myCode = url;
                  print("NEED01 $_myCode");
                });
              }
            },
            onPageFinished: (url) {
              if (url.contains('https://crminsight-uat.cpf.co.th/app/?code=')) {
                Future.delayed(
                  Duration(milliseconds: 300),
                  () {
                    // Print code
                    _myCode = url;
                    print("NEED02 $_myCode");
                  },
                );
              }

              print('CURRENT $url');

              final start = 'code=';
              // final end = '#main';
              final end = '&state=';

              final startIndex = url.indexOf(start);
              final endIndex = url.indexOf(end);
              final result =
                  url.substring(startIndex + start.length, endIndex).trim();

              print('your code = $result');
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final username = 'WANCHAI.WEC';
          final password = 'Pass@1';

          _webViewController.evaluateJavascript(
              "document.getElementsByName('username')[0].value=$username");
          _webViewController.evaluateJavascript(
              "document.getElementsByName('password')[0].value=$password");

          final url = await _webViewController.currentUrl();
          print('Previous Website: $url');

          // _webViewController.loadUrl('https://www.youtube.com');
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
