import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../services/open_route_service.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<LatLng> routePoints = [];
  late LatLng start;
  final LatLng end = LatLng(21.035000, 105.825649); // Điểm kết thúc 21.035000, 105.825649
  bool isLocationLoaded = false;  // Để kiểm tra xem vị trí hiện tại đã được lấy chưa

  double routeDistance = 0.0;

  @override
  void initState() {
    super.initState();
    _getCurrentLocationAndLoadRoute();  // Lấy vị trí hiện tại và tải tuyến đường
  }

  Future<void> _getCurrentLocationAndLoadRoute() async {
    start = await getCurrentLocation();
    await _loadRoute();  // Sau khi có vị trí, tải tuyến đường
    setState(() {
      isLocationLoaded = true;  // Cập nhật trạng thái để hiển thị bản đồ
    });
  }

  Future<LatLng> getCurrentLocation() async {
    Position userPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
    );
    return LatLng(userPosition.latitude, userPosition.longitude);
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
      body: isLocationLoaded
          ? FlutterMap(
        options: MapOptions(
          initialCenter: start,  // Sử dụng vị trí hiện tại làm initialCenter
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
      )
          : Center(
        child: CircularProgressIndicator(),  // Hiển thị vòng xoay khi chưa có vị trí
      ),
    );
  }
}
