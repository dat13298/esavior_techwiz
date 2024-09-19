import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatelessWidget {
  final LatLng currentPositionDevice;
  final LatLng currentPosition;
  final String role;
  final double routeDistance;
  final List<LatLng> routePoints;

  const MapScreen({
    Key? key,
    required this.currentPositionDevice,
    required this.currentPosition,
    required this.role,
    required this.routeDistance,
    required this.routePoints,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LatLng end = LatLng(21.035000, 105.825649); // Điểm kết thúc 21.035000, 105.825649

    return Scaffold(
      appBar: AppBar(
        title: Text('Route Map: $routeDistance'),
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: currentPosition, // Sử dụng vị trí hiện tại làm initialCenter
          initialZoom: 13.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          PolylineLayer(
            polylines: [
              Polyline(
                points: routePoints,
                strokeWidth: 4.0,
                color: Colors.blue,
              ),
            ],
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: currentPosition,
                width: 80,
                height: 80,
                child: Icon(Icons.person, color: Colors.red),
              ),
              Marker(
                point: end,
                width: 80,
                height: 80,
                child: Icon(Icons.car_crash_rounded, color: Colors.green),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
