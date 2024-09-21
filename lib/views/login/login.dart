import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/account.dart';
import '../../services/account_service.dart';
import '../home/homepage.dart';
import '../register/register.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isErrorVisible = false;
  bool isPasswordVisible = false;
  double screenHeight = 0;
  double screenWidth = 0;

  final AccountService _accountService = AccountService();

  void showErrorDialog(BuildContext context, String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: [
            CupertinoDialogAction(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void handleLogin() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        isErrorVisible = true;
      });
      return;
    }
    if (!_isValidEmail(email)) {
      setState(() {
        isErrorVisible = true;
      });
      return;
    }
    setState(() {
      isErrorVisible = false;
    });
    try {
      Account? accountLogged = await _accountService.authenticate(email, password);

      if (accountLogged != null) {
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(
            builder: (context) => HomePage(account: accountLogged),
          ),
        );
      } else {
        showErrorDialog(context, 'Đăng nhập thất bại');
      }
    } catch (e) {
      showErrorDialog(context, 'Đã xảy ra lỗi, vui lòng thử lại sau.');
    }
  }


  bool _isValidEmail(String email) {
    String emailPattern =
        r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
    RegExp regex = RegExp(emailPattern);
    return regex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return CupertinoPageScaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      navigationBar: CupertinoNavigationBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 24,
          ),
        ),
        border: null,
      ),
      child: ScaffoldMessenger( // Thêm ScaffoldMessenger
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
            child: SingleChildScrollView(
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
                    'Login your account',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 19,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Image.asset(
                    'assets/login.png',
                    height: screenHeight * 0.3,
                    width: screenWidth,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Email',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 19,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  CupertinoTextField(
                    controller: emailController,
                    placeholder: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    padding: const EdgeInsets.symmetric(vertical: 19, horizontal: 16),
                    suffix: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Icon(
                        Icons.email,
                        color: Colors.grey.withOpacity(0.7),
                        size: 22,
                      ),
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Password',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 19,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  CupertinoTextField(
                    controller: passwordController,
                    placeholder: 'Password',
                    obscureText: !isPasswordVisible,
                    padding: const EdgeInsets.symmetric(vertical: 19, horizontal: 16),
                    suffix: GestureDetector(
                      onTap: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Icon(
                          isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey.withOpacity(0.7),
                          size: 22,
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  if (isErrorVisible)
                    const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Invalid email or password!',
                          style: TextStyle(
                            fontSize: 19,
                            color: Color(0xFFF20202),
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Inter',
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ),
                  SizedBox(height: screenHeight * 0.02),
                  GestureDetector(
                    onTap: () {
                      handleLogin();
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
                        'Login',
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
                  SizedBox(height: screenHeight * 0.02),
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
                    child: const Text(
                      'Register new account',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: Color(0xFF1F10CC),
                        decoration: TextDecoration.underline,
                        decorationStyle: TextDecorationStyle.solid,
                        decorationThickness: 1.5,
                        decorationColor: Color(0xFF1F10CC),
                        fontSize: 19,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );


  }
}
