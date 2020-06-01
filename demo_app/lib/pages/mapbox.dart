import 'dart:async';

import 'package:demo_app/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong/latlong.dart';
import 'package:user_location/user_location.dart';

class MapBoxPage extends StatefulWidget {
  static const String route = '/mapbox';

  @override
  _MapBoxPageState createState() => _MapBoxPageState();
}

class _MapBoxPageState extends State<MapBoxPage> {
  final MapController mapController = MapController();

  final List<Marker> markers = [];
  MapPosition mapPosition =
      MapPosition(center: LatLng(39.991967, 32.647947), zoom: 13);

  UserLocationOptions userLocationOptions;

  @override
  Widget build(BuildContext context) {
    userLocationOptions = UserLocationOptions(
        context: context,
        mapController: mapController,
        markers: markers,
        updateMapLocationOnPositionChange: false,
        showMoveToCurrentLocationFloatingActionButton: true,
        zoomToCurrentLocationOnLoad: false,
        fabBottom: 50,
        fabRight: 50,
        verbose: false);

    //You can also change the value of updateMapLocationOnPositionChange programatically in runtime.
    //userLocationOptions.updateMapLocationOnPositionChange = false;

    return Scaffold(
        appBar: AppBar(title: Text("Map Test")),
        body: FlutterMap(
          options: MapOptions(
            center: mapPosition.center,
            zoom: mapPosition.zoom,
            onPositionChanged: (MapPosition currentPosition, bool hasGesture) =>
                mapPosition = currentPosition,
            plugins: [
              UserLocationPlugin(),
            ],
          ),
          layers: [
            TileLayerOptions(
                urlTemplate: "https://api.tiles.mapbox.com/v4/"
                    "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
                additionalOptions: {
                  'accessToken':
                      'pk.eyJ1IjoiaWdhdXJhYiIsImEiOiJjazFhOWlkN2QwYzA5M2RyNWFvenYzOTV0In0.lzjuSBZC6LcOy_oRENLKCg',
                  'id': 'mapbox.streets',
                },
                keepBuffer: 4),
            MarkerLayerOptions(markers: markers),
            userLocationOptions
          ],
          mapController: mapController,
        ),
        drawer: buildDrawer(context, MapBoxPage.route));
  }
}
