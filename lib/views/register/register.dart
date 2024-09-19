import 'package:esavior_techwiz/views/register/phone_address.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _fullNameController = TextEditingController();

  final FocusNode _focusNode = FocusNode();
  bool _isButtonEnabled = false;
  String? _fullNameError;

  int _currentStep = 0;

  void _checkFields() {
    final fullName = _fullNameController.text.trim();


    if (fullName.isEmpty || fullName.length > 40 || !RegExp(r"^[a-zA-Z\s]+$").hasMatch(fullName)) {
      setState(() {
        _fullNameError = 'Invalid full name!';
        _isButtonEnabled = false;
      });
    } else {
      setState(() {
        _fullNameError = null;
        _isButtonEnabled = true;
      });
    }
  }

  void _handleContinue() async {
    if (_isButtonEnabled) {
      setState(() {
        _currentStep++;
      });


      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => PhoneAddressPage(
            currentStep: _currentStep,
            fullName: _fullNameController.text,
          ),
        ),
      ).then((_) {
        setState(() {
          _currentStep = 0;
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fullNameController.addListener(_checkFields);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return CupertinoPageScaffold(
      child: RawKeyboardListener(
        focusNode: _focusNode,
        onKey: (RawKeyEvent event) {
          if (event is RawKeyDownEvent && event.logicalKey == LogicalKeyboardKey.enter) {
            _handleContinue();
          }
        },
        child: Material(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
            child: Container(
              height: screenHeight,
              width: screenWidth,
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.1),

                  // Nút back
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                        size: 24,
                      ),
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 50.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(3, (index) {
                                return _buildStepIndicator(isActive: index <= _currentStep);
                              }),
                            ),
                            SizedBox(height: screenHeight * 0.05),

                            const Text(
                              'Enter your full name',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            CupertinoTextField(
                              controller: _fullNameController,
                              keyboardType: TextInputType.name,
                              padding: const EdgeInsets.symmetric(vertical: 19, horizontal: 16),
                              cursorColor: Colors.black,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            if (_fullNameError != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    _fullNameError!,
                                    style: const TextStyle(
                                      fontSize: 19,
                                      color: Color(0xFFF20202),
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Inter',
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                ),
                              ),

                            const SizedBox(height: 34),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: screenHeight * 0.06),
                    child: GestureDetector(
                      onTap: _isButtonEnabled ? _handleContinue : null,
                      child: FractionallySizedBox(
                        child: Container(
                          height: screenHeight * 0.07,
                          decoration: BoxDecoration(
                            color: _isButtonEnabled
                                ? const Color(0xFF10CCC6)
                                : const Color(0xFF10CCC6).withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: const Center(
                            child: Text(
                              'Continue',
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
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

  Widget _buildStepIndicator({required bool isActive}) {
    return Container(
      width: 90,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF10CCC6) : Colors.grey[300],
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
