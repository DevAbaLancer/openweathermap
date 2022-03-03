import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TileOverlayBody extends StatefulWidget {
  final double? lat;
  final double? lon;
  const TileOverlayBody({Key? key, this.lat, this.lon}) : super(key: key);

  @override
  State<StatefulWidget> createState() => TileOverlayBodyState();
}

class TileOverlayBodyState extends State<TileOverlayBody> {
  TileOverlayBodyState();

  GoogleMapController? controller;
  TileOverlay? _tileOverlay;
  int counter = 0;

  void _onMapCreated(GoogleMapController controller) {
    this.controller = controller;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _removeTileOverlay() {
    setState(() {
      _tileOverlay = null;
      counter = 0;
    });
  }

  void _addWeatherLayer() {
    _clearTileCache();
    switch (counter) {
      case 0:
        {
          _addTileOverlay('temp_new');
        }
        break;

      case 1:
        {
          _addTileOverlay('precipitation_new');
        }
        break;

      case 2:
        {
          _addTileOverlay('pressure_new');
        }
        break;

      case 3:
        {
          _addTileOverlay('wind_new');
        }
        break;

      default:
        {
          _addTileOverlay('clouds_new');

          counter = 0;
        }
        break;
    }
  }

  void _addTileOverlay(String weatherType) {
    final TileOverlay tileOverlay = TileOverlay(
      tileOverlayId: const TileOverlayId('tile_overlay_1'),
      tileProvider: DebugTileProvider(weatherLayerType: weatherType),
    );

    setState(() {
      _tileOverlay = tileOverlay;
      counter++;
    });
  }

  void _clearTileCache() {
    if (_tileOverlay != null && controller != null) {
      controller!.clearTileCache(_tileOverlay!.tileOverlayId);
    }
  }

  @override
  Widget build(BuildContext context) {
    Set<TileOverlay> overlays = <TileOverlay>{
      if (_tileOverlay != null) _tileOverlay!,
    };
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Center(
          child: SizedBox(
            width: 350.0,
            height: 300.0,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target:
                    LatLng(widget.lat ?? 51.5073219, widget.lon ?? -0.1276474),
                zoom: 7.0,
              ),
              tileOverlays: overlays,
              onMapCreated: _onMapCreated,
            ),
          ),
        ),
        TextButton(
          child: const Text('Add tile overlay'),
          onPressed: _addWeatherLayer,
        ),
        TextButton(
          child: const Text('Remove tile overlay'),
          onPressed: _removeTileOverlay,
        ),
        TextButton(
          child: const Text('Clear tile cache'),
          onPressed: _clearTileCache,
        ),
      ],
    );
  }
}

class DebugTileProvider implements TileProvider {
  DebugTileProvider({Key? key, required this.weatherLayerType});
  final String weatherLayerType;
  static const int width = 100;
  static const int height = 100;

  @override
  Future<Tile> getTile(
    int x,
    int y,
    int? zoom,
  ) async {
    final Uint8List byteData = (await NetworkAssetBundle(Uri.parse(
                'https://tile.openweathermap.org/map/$weatherLayerType/$zoom/$x/$y.png?appid=bbac3eaf85ac5dc3e1678ad48bbc5ac7'))
            .load(
                'https://tile.openweathermap.org/map/$weatherLayerType/$zoom/$x/$y.png?appid=bbac3eaf85ac5dc3e1678ad48bbc5ac7'))
        .buffer
        .asUint8List();
    print(weatherLayerType);
    return Tile(width, height, byteData);
  }
}
