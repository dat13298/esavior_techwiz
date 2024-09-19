  import 'dart:convert';
  import 'package:http/http.dart' as http;
  import 'package:latlong2/latlong.dart';

  Future<List<LatLng>> getRouteCoordinates(LatLng start, LatLng end) async {
    const apiKey = '5b3ce3597851110001cf62487b52a77ea88c42fdafe9bffcc7690979'; // Thay YOUR_API_KEY bằng OpenRouteService API Key của bạn

    final String url =
        'https://api.openrouteservice.org/v2/directions/driving-car?api_key=$apiKey&start=${start.longitude},${start.latitude}&end=${end.longitude},${end.latitude}';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<LatLng> routePoints = [];

      for (var point in data['features'][0]['geometry']['coordinates']) {
        routePoints.add(LatLng(point[1], point[0]));
      }

      return routePoints;
    } else {
      throw Exception('Failed to load directions');
    }
  }

  Future<double> getRouteDistance(LatLng start, LatLng end) async {
    const apiKey = '5b3ce3597851110001cf62487b52a77ea88c42fdafe9bffcc7690979';

    final String url =
        'https://api.openrouteservice.org/v2/directions/driving-car?api_key=$apiKey&start=${start.longitude},${start.latitude}&end=${end.longitude},${end.latitude}';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      double distance = data['features'][0]['properties']['summary']['distance'];
      return distance;
    } else {
      throw Exception('Failed to load directions');
    }
  }