import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

Future<String> getLatitudeFromAddress(String address) async {
  const apiKey = 'pk.842d94f6c5f85464e07a7dcc0ac594a5';

  final String url =
      'https://us1.locationiq.com/v1/search?key=$apiKey&q=$address&format=json&';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    String latitude = data[0]['lat'];
    return latitude;
  } else {
    throw Exception("No location found for the given address.");
  }
}

Future<String> getLongitudeFromAddress(String address) async {
  const apiKey = 'pk.842d94f6c5f85464e07a7dcc0ac594a5';

  final String url =
      'https://us1.locationiq.com/v1/search?key=$apiKey&q=$address&format=json&';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    String longitude = data[0]['lon'];
    return longitude;
  } else {
    throw Exception("No location found for the given address.");
  }
}

Future<String> getAddressFromLatlon(LatLng location) async {
  const apiKey = 'pk.842d94f6c5f85464e07a7dcc0ac594a5';

  final String url =
      'https://us1.locationiq.com/v1/reverse?key=$apiKey&lat=${location.latitude}&lon=${location.longitude}&format=json&';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    String latitude = data['display_name'];
    return latitude;
  } else {
    throw Exception("No location found for the given address.");
  }
}

