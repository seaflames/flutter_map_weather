import 'package:demo_app/pages/gallery.dart';
import 'package:demo_app/pages/mapbox.dart';
import 'package:demo_app/pages/windy_webview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:path_provider/path_provider.dart';

import 'package:path/path.dart' as path;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final int primaryColor = Color.fromRGBO(15, 76, 129, 1).value;
  static const String galleryPath = 'WindyGallery';

  static const Map<int, Color> swatch = {
    50: Color.fromRGBO(15, 76, 129, .1),
    100: Color.fromRGBO(15, 76, 129, .2),
    200: Color.fromRGBO(15, 76, 129, .3),
    300: Color.fromRGBO(15, 76, 129, .4),
    400: Color.fromRGBO(15, 76, 129, .5),
    500: Color.fromRGBO(15, 76, 129, .6),
    600: Color.fromRGBO(15, 76, 129, .7),
    700: Color.fromRGBO(15, 76, 129, .8),
    800: Color.fromRGBO(15, 76, 129, .9),
    900: Color.fromRGBO(15, 76, 129, 1),
  };

  static Future<String> windyGalleryPath() async {
    var documentsDir = await getApplicationDocumentsDirectory();
    var galleryPath = path.join(documentsDir.path, MyApp.galleryPath);
    return galleryPath;
  }

  @override
  Widget build(BuildContext context) {
    var mapBoxPage = MapBoxPage();
    final flutterWebViewPlugin = FlutterWebviewPlugin();
    return MaterialApp(
      title: 'Plugin Demo',
      theme: ThemeData(
        primarySwatch: MaterialColor(primaryColor, swatch),
      ),
      home: mapBoxPage,
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        MapBoxPage.route: (context) {
          return mapBoxPage;
        },
        WindyWebView.route: (context) => WindyWebView(),
        Gallery.route: (context) => Gallery(),
      },
    );
  }
}
