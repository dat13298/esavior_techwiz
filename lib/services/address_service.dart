import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlng/latlng.dart';

Future<String> getLatitudeFromAddress(String address) async {
  // OpenRouteService API Key (replace with your own key)
  const apiKey = 'pk.842d94f6c5f85464e07a7dcc0ac594a5';

  // Construct the request URL
  final String url =
      'https://us1.locationiq.com/v1/search?key=$apiKey&q=$address&format=json&';

  // Send the GET request
  final response = await http.get(Uri.parse(url));

  // Check if the response status is OK (200)
  if (response.statusCode == 200) {
    // Parse the JSON data
    final data = jsonDecode(response.body);

    // Extract the latitude from the response
    String latitude = data[0]['lat'];
    return latitude;
  } else {
    // Throw an exception if no location is found
    throw Exception("No location found for the given address.");
  }
}

Future<String> getLongitudeFromAddress(String address) async {
  // OpenRouteService API Key (replace with your own key)
  const apiKey = 'pk.842d94f6c5f85464e07a7dcc0ac594a5';

  // Construct the request URL
  final String url =
      'https://us1.locationiq.com/v1/search?key=$apiKey&q=$address&format=json&';

  // Send the GET request
  final response = await http.get(Uri.parse(url));

  // Check if the response status is OK (200)
  if (response.statusCode == 200) {
    // Parse the JSON data
    final data = jsonDecode(response.body);

    // Extract the latitude from the response
    String latitude = data[0]['lon'];
    return latitude;
  } else {
    // Throw an exception if no location is found
    throw Exception("No location found for the given address.");
  }
}

Future<String> getAddressFromLatlon(LatLng location) async {
  // OpenRouteService API Key (replace with your own key)
  const apiKey = 'pk.842d94f6c5f85464e07a7dcc0ac594a5';

  // Construct the request URL
  final String url =
      'https://us1.locationiq.com/v1/search?key=$apiKey&lat=${location.latitude}&lon=${location.longitude}&format=json&';

  // Send the GET request
  final response = await http.get(Uri.parse(url));

  // Check if the response status is OK (200)
  if (response.statusCode == 200) {
    // Parse the JSON data
    final data = jsonDecode(response.body);

    // Extract the latitude from the response
    String latitude = data[0]['display_name'];
    return latitude;
  } else {
    // Throw an exception if no location is found
    throw Exception("No location found for the given address.");
  }
}

void main() async {
  // Ensure you await the result of the asynchronous function call
  try {
    String latitude = await getLatitudeFromAddress("Bach Mai Hospital");
    print("Latitude: $latitude");
  } catch (e) {
    print("Error: $e");
  }
}
