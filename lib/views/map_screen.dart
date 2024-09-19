import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../services/open_route_service.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<LatLng> routePoints = [];
  final LatLng start = LatLng(40.748817, -73.985428); // Điểm bắt đầu
  final LatLng end = LatLng(40.712776, -74.005974); // Điểm kết thúc

  double routeDistance = 0.0;

  @override
  void initState() {
    super.initState();
    _loadRoute();
    _loadDistance();
  }

  Future<void> _loadRoute() async {
    // Giả sử bạn đã có hàm getRouteCoordinates
    List<LatLng> points = await getRouteCoordinates(start, end);
    setState(() {
      routePoints = points;
    });
  }

  Future<void> _loadDistance() async {
    routeDistance = await getRouteDistance(start, end);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Route Map: $routeDistance' ),
      ),
      body: FlutterMap(
        options: const MapOptions(
          // initialCenter: LatLng(40.730610, -73.935242), // Sử dụng initialCenter thay cho center
          initialCenter: LatLng(40.748817, -73.985428), // Sử dụng initialCenter thay cho center
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
                point: start,
                width: 80,
                height: 80,
                child: Icon(Icons.location_on, color: Colors.red),
                // builder: (ctx) => Icon(Icons.location_on, color: Colors.red), // Thay builder bằng widget
              ),
              Marker(
                point: end,
                width: 80,
                height: 80,
                // widget: Icon(Icons.location_on, color: Colors.green), // Thay builder bằng widget
                child: Icon(Icons.location_on, color: Colors.red), // Thay builder bằng widget
              ),
            ],
          ),
        ],
      ),
    );
  }
}