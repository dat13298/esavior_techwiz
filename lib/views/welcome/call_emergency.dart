import 'package:esavior_techwiz/services/emergency_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';


class CallEmergency extends StatefulWidget {
  const CallEmergency({super.key});

  @override
  State<CallEmergency> createState() => _CallEmergencyState();
}

class _CallEmergencyState extends State<CallEmergency> {
  double screenHeight = 0;
  double screenWidth = 0;
  final EmergencyService _emergencyService = EmergencyService();

  @override
  void initState() {
    super.initState();
    _initialize();//TODO call dispatcher and get current location
  }

  Future<void> _initialize() async {
    await _callDispatcher();///call Dispatcher when widget start
    await _getCurrentLocation();
  }

  /// CALL HOT LINE
  Future<void> _callDispatcher() async {
    // Yêu cầu quyền gọi điện thoại
    final PermissionStatus status = await Permission.phone.request();
    final PermissionStatus status2 = await Permission.phone.status;
    print('Phone permission status: $status2');

    // Kiểm tra xem quyền đã được cấp chưa
    if (status.isGranted) {
      final Uri phoneUri = Uri(scheme: 'tel', path: '0915799025'); // HOT LINE
      try {
        if (await canLaunchUrl(phoneUri)) {
          await launchUrl(phoneUri);
        } else {
          print('Could not launch $phoneUri');
        }
      } catch (e) {
        print('Error: $e');
      }
    } else {
      print('Phone permission denied');
    }
  }


  /// GET CURRENT LOCATION and INSERT REALTIME
  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
      );
      // Xử lý vị trí của người dùng ở đây, ví dụ lưu vào biến, gửi đến server, v.v.
      await _emergencyService.sendLocationToFirebase(position.latitude, position.longitude);
    } catch (e) {
      print('Error getting location: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return CupertinoPageScaffold(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.05),
              const Text(
                'eSavior',
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: Colors.black,
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  decoration: TextDecoration.none,
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              const Text(
                'Connect to hospital with just a touch!',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.none,
                ),
              ),

              SizedBox(height: screenHeight * 0.03),
              Image.asset(
                'assets/wellcome_page.png',
                height: screenHeight * 0.3,
                width: screenWidth,
                fit: BoxFit.cover,
              ),
              SizedBox(height: screenHeight * 0.01),
              const Text(
                'A product of NextGen Creators team',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15,
                  color: Color(0xFFA3A3A3),
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.none,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              const Text(
                'The system sent your location.\nPlease wait ambulance!',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.none,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenHeight * 0.05),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => CallEmergency(),
                    ),
                  );
                  setState(() {
                    // Simulate login error
                  });
                },
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF20202),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Calling to dispatcher',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.125),

              SizedBox(height: screenHeight * 0.01),
              GestureDetector(
                onTap: () {
                  // Navigate to register page
                  Navigator.pop(context);
                },
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                  ),
                  child: const Text(
                    'Back',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
