import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'dart:async';

import 'package:flutter_map_weather/src/weather_options.dart';
import 'package:flutter_map_weather/src/weather_plugin_layer.dart';

class WeatherPlugin implements MapPlugin {
  @override
  Widget createLayer(
      LayerOptions options, MapState mapState, Stream<Null> stream) {
    if (options is WeatherOptions) {
      return WeatherPluginLayer(options, mapState, stream);
    }
    throw Exception('Unknown options type for MyCustom'
        'plugin: $options');
  }

  @override
  bool supportsLayer(LayerOptions options) {
    return options is WeatherOptions;
  }
}
