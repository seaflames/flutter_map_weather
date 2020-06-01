import 'package:demo_app/pages/gallery.dart';
import 'package:demo_app/pages/mapbox.dart';
import 'package:demo_app/pages/windy_webview.dart';
import 'package:flutter/material.dart';

Widget _buildMenuItem(
    BuildContext context, Widget title, String routeName, String currentRoute) {
  var isSelected = routeName == currentRoute;

  return ListTile(
    title: title,
    selected: isSelected,
    onTap: () {
      if (isSelected) {
        Navigator.pop(context);
      } else {
        Navigator.pushReplacementNamed(context, routeName);
      }
    },
  );
}

Drawer buildDrawer(BuildContext context, String currentRoute) {
  return Drawer(
    child: ListView(
      children: <Widget>[
        const DrawerHeader(
          child: Center(
            child: Text('Flutter Map Examples'),
          ),
        ),
        _buildMenuItem(
          context,
          const Text('Map'),
          MapBoxPage.route,
          currentRoute,
        ),
        _buildMenuItem(
          context,
          const Text('Windy'),
          WindyWebView.route,
          currentRoute,
        ),
        _buildMenuItem(
          context,
          const Text('Gallery'),
          Gallery.route,
          currentRoute,
        ),
      ],
    ),
  );
}
