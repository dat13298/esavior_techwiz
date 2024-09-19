import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../login/login.dart';
import '../register/register.dart';
import 'call_emergency.dart';


class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  double screenHeight = 0;
  double screenWidth = 0;

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
              SizedBox(height: screenHeight * 0.05 + 5),
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
                    'Call emergency',
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
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                  );

                  setState(() {
                    // Simulate login error
                  });
                },
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10CCC6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Login as User',
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
              SizedBox(height: screenHeight * 0.01),
              GestureDetector(
                onTap: () {
                  // Navigate to register page
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => RegisterPage(),
                    ),
                  );
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
                    'Register',
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
