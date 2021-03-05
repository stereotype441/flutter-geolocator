import 'dart:html' as html;

import 'package:geolocator_platform_interface/src/models/position.dart';

import 'geolocation_manager.dart';
import 'utils.dart';

class HtmlGeolocationManager implements GeolocationManager {
  final html.Geolocation _geolocation;

  HtmlGeolocationManager() : _geolocation = html.window.navigator.geolocation;

  @override
  bool get locationServicesEnabled => _geolocation != null;

  @override
  Future<Position> getCurrentPosition({
    bool? enableHighAccuracy,
    Duration? timeout,
  }) async {
    try {
      final geoPosition = await _geolocation.getCurrentPosition(
        enableHighAccuracy: enableHighAccuracy,
        timeout: timeout,
      );

      return toPosition(geoPosition);
    } on html.PositionError catch (e) {
      throw convertPositionError(e);
    }
  }

  @override
  Stream<Position> watchPosition({
    bool? enableHighAccuracy,
    Duration? timeout,
  }) {
    return _geolocation
        .watchPosition(
          enableHighAccuracy: enableHighAccuracy,
          timeout: timeout,
        ).handleError((error) => throw convertPositionError(error))
        .map((geoPosition) => toPosition(geoPosition));
  }
}