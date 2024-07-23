import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DbjMapPage extends StatefulWidget {
  const DbjMapPage({super.key});

  @override
  State<DbjMapPage> createState() => _DbjMapPageState();
}

class _DbjMapPageState extends State<DbjMapPage> {
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DBJ Map'),
      ),
      body: GoogleMap(
        onMapCreated: (controller) {
          _mapController.complete(controller);
        },
        initialCameraPosition: const CameraPosition(
          target: LatLng(17.522916831686306, 73.52660881363643),
          zoom: 17,
        ),
        markers: {
          const Marker(
            markerId: MarkerId('dbj_college_canteen'),
            position: LatLng(17.52335992200932, 73.52656525176889),
          ),
        },
        polygons: {
          Polygon(
            polygonId: const PolygonId('dbj_map_polygon'),
            fillColor: Colors.green.withOpacity(0.3),
            strokeWidth: 1,
            strokeColor: Colors.green.withOpacity(0.7),
            points: const [
              LatLng(17.523746064726765, 73.52562839294892),
              LatLng(17.523102579829576, 73.52548564685847),
              LatLng(17.52286333486282, 73.52599607227278),
              LatLng(17.52261171481609, 73.52609556197217),
              LatLng(17.522198412173978, 73.52725616011291),
              LatLng(17.521857827115106, 73.52818253524306),
              LatLng(17.522379347726513, 73.52843366103137),
              LatLng(17.52279975610791, 73.5284504027506),
              LatLng(17.522890223606932, 73.52808766550083),
              LatLng(17.52314566100782, 73.52795373174706),
              LatLng(17.523390454846254, 73.52670368337867),
            ],
          ),
        },
      ),
    );
  }
}
