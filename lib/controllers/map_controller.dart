import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../services/open_route_service.dart';
import '../views/map/map_screen.dart';

//TODO: add account to this
Future<void> showMapScreen(BuildContext context) async {
  // Lấy vị trí hiện tại
  Position userPosition = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.bestForNavigation,
  );
  LatLng currentPosition = LatLng(userPosition.latitude, userPosition.longitude);

  // Điểm kết thúc
  LatLng end = LatLng(21.035000, 105.825649);

  // Tải tuyến đường
  List<LatLng> routePoints = await getRouteCoordinates(currentPosition, end);

  // Tải khoảng cách
  double routeDistance = await getRouteDistance(currentPosition, end);

  // Hiển thị MapScreen
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => MapScreen(
        currentPositionDevice: end,
        currentPosition: currentPosition,
        role: 'user', // Thay đổi nếu cần
        routeDistance: routeDistance,
        routePoints: routePoints,
      ),
    ),
  );
}
