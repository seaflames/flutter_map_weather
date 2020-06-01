import 'dart:async';
import 'dart:io';

import 'package:demo_app/main.dart';
import 'package:demo_app/widgets/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:path/path.dart' as path;

class WindyWebView extends StatefulWidget {
  static const String route = '/windy';

  @override
  State<StatefulWidget> createState() {
    return WindyWebViewState();
  }
}

class WindyWebViewState extends State<WindyWebView> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  WebViewState actualState;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            extendBodyBehindAppBar: true,
            drawer: buildDrawer(context, WindyWebView.route),
            body: _createWebView(),
            floatingActionButton: _screenshotButton()));
  }

  StatefulWidget _createWebView() {
    var webView = WebView(
        initialUrl: 'https://www.windy.com/',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
        navigationDelegate: (NavigationRequest request) {
          return NavigationDecision.prevent;
        });
    return webView;
  }

  _screenshotButton() {
    return FutureBuilder<WebViewController>(
      future: _controller.future,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> controller) {
        if (controller.hasData) {
          return FloatingActionButton(
              onPressed: () async {
                var format = CompressFormat.JPEG;
                var data = await controller.data.takeScreenshot(format, 100);
                var currentTime = DateTime.now();
                var galleryPath = await MyApp.windyGalleryPath();
                var filePath = path.join(galleryPath,
                    "Screenshot ${DateFormat("yyyyMMddhhmmssSS").format(currentTime)}.${format.toString().split(('.')).last.toLowerCase()}");
                var file = File(filePath)..createSync(recursive: true);
                file.writeAsBytesSync(data, flush: true);
//                  String savedURI = await ImageGallerySaver.saveImage(data);
//                  if (savedURI != null && savedURI.isNotEmpty) {
//                    Scaffold.of(context).showSnackBar(
//                      SnackBar(content: Text('Saved screenshot for later.')),
//                    );
//                  }
              },
              child: Icon(Icons.camera),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16.0))));
        }
        return Container();
      },
    );
  }
}
