import 'package:flutter_map/plugin_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';

class DeviceMap extends StatelessWidget {
  final double lat;
  final double lon;
  final String name;
  const DeviceMap(
      {Key? key, required this.name, required this.lat, required this.lon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('$name\'s Location')),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: FlutterMap(
            options: MapOptions(
                interactiveFlags: InteractiveFlag.pinchZoom |
                    InteractiveFlag.pinchMove |
                    InteractiveFlag.drag,
                center: LatLng(lat, lon),
                zoom: 15,
                maxZoom: 20),
            layers: [
              TileLayerOptions(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                userAgentPackageName: 'com.monitax.app',
              ),
              MarkerLayerOptions(markers: [
                Marker(
                    point: LatLng(lat, lon),
                    builder: (context) {
                      return const Icon(
                        Icons.pin_drop,
                        size: 32,
                        color: Colors.blue,
                      );
                    }),
              ])
            ],
            nonRotatedChildren: [
              AttributionWidget.defaultWidget(
                source: 'OpenStreetMap',
                onSourceTapped: null,
              ),
            ],
          ),
        ));
  }
}
