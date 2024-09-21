import 'package:esavior_techwiz/models/account.dart';
import 'package:esavior_techwiz/models/booking.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../services/address_service.dart';
import '../services/open_route_service.dart';
import '../views/map/map_screen.dart';

//TODO: add account to this
Future<void> showMapScreen(BuildContext context, String? address, Account account, Booking? booking) async {
  String endLatitude;
  String endLongitude;
  LatLng end;
  bool isBookingShow = false;

  if(address!=null){
    endLatitude = await getLatitudeFromAddress(address);
    endLongitude = await getLongitudeFromAddress(address);
    end = LatLng(double.parse(endLatitude), double.parse(endLongitude));
    isBookingShow = true;
  } else {
    end = LatLng(21.035000, 105.825649);
  }

  //get current location
  Position userPosition = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.bestForNavigation,
  );
  LatLng currentPosition = LatLng(userPosition.latitude, userPosition.longitude);

  // Điểm kết thúc
  // end = LatLng(21.035000, 105.825649);

  // Tải tuyến đường
  List<LatLng> routePoints = await getRouteCoordinates(currentPosition, end);

  // Tải khoảng cách
  double routeDistance = await getRouteDistance(currentPosition, end);

  // Hiển thị MapScreen
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
