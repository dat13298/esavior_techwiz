import 'package:esavior_techwiz/models/account.dart';
import 'package:esavior_techwiz/models/booking.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../services/address_service.dart';
import '../services/open_route_service.dart';
import '../views/map/map_screen.dart';

Future<void> showMapScreen(BuildContext context, String? address, Account account, Booking? booking) async {
  String endLatitude;
  String endLongitude;
  LatLng end = const LatLng(0.0, 0.0);
  bool isBookingShow = false;

  if(address!=null){
    endLatitude = await getLatitudeFromAddress(address);
    endLongitude = await getLongitudeFromAddress(address);
    end = LatLng(double.parse(endLatitude), double.parse(endLongitude));
    isBookingShow = true;
  }

  if(booking != null && account.role == 'user'){
    isBookingShow = true;
  }

  if(booking != null && account.role == 'driver'){
    isBookingShow = true;
    double? driverEndLa = booking.startLatitude;
    double? driverEndLo = booking.startLongitude;
    end = LatLng(driverEndLa!, driverEndLo!);
  }

  //get current location
  Position userPosition = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.bestForNavigation,
  );
  LatLng currentPosition = LatLng(userPosition.latitude, userPosition.longitude);

  List<LatLng> routePoints = await getRouteCoordinates(currentPosition, end);

  double routeDistance = await getRouteDistance(currentPosition, end);

  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => MapScreen(
        endPosition: end,
        startPosition: currentPosition,
        routeDistance: routeDistance,
        routePoints: routePoints,
        isOnBookingShow: isBookingShow,
        currentAccount: account,
        booking: booking,
      ),
    ),
  );
}
