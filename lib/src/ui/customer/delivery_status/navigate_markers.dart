import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;


class NavigateMarkers {
/*  HereMapController? hereMapController;
  List<MapMarker> _mapMarkerList = [];
  MapImage? _driverMarker;
  MapImage? _customerMarker;*/
  Function endInitListener;

  NavigateMarkers(this.endInitListener);

/*
  setHereMapController(HereMapController hereMapController) {
    this.hereMapController = hereMapController;
    endInitListener.call();
  }

  Future<void> addDriverMarker(
      GeoCoordinates geoCoordinates, int drawOrder) async {
    // Reuse existing MapImage for new map markers.
    if (_driverMarker == null) {
      Uint8List imagePixelData =
          await _loadFileAsUint8List('driver_icon_map.png');
      _driverMarker =
          MapImage.withPixelDataAndImageFormat(imagePixelData, ImageFormat.png);
    }

    MapMarker mapMarker = MapMarker(geoCoordinates, _driverMarker!);
    mapMarker.drawOrder = drawOrder;

    hereMapController!.mapScene.addMapMarker(mapMarker);
    _mapMarkerList.add(mapMarker);
  }

  Future<void> addCustomerMarker(
      GeoCoordinates geoCoordinates, int drawOrder) async {
    // Reuse existing MapImage for new map markers.
    if (_customerMarker == null) {
      Uint8List imagePixelData =
          await _loadFileAsUint8List('customer_icon_map.png');
      _customerMarker =
          MapImage.withPixelDataAndImageFormat(imagePixelData, ImageFormat.png);
    }

    MapMarker mapMarker = MapMarker(geoCoordinates, _customerMarker!);
    mapMarker.drawOrder = drawOrder;

    hereMapController!.mapScene.addMapMarker(mapMarker);
    _mapMarkerList.add(mapMarker);
  }
*/

  Future<Uint8List> _loadFileAsUint8List(String fileName) async {
    // The path refers to the assets directory as specified in pubspec.yaml.
    ByteData fileData = await rootBundle.load('assets/images/' + fileName);
    return Uint8List.view(fileData.buffer);
  }
}
