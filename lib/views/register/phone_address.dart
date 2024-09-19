import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'account.dart';

class PhoneAddressPage extends StatefulWidget {
  final int currentStep;
  const PhoneAddressPage({super.key, required TextEditingController fullName, required this.currentStep});

  @override
  State<PhoneAddressPage> createState() => _PhoneAddressPageState();
}

class _PhoneAddressPageState extends State<PhoneAddressPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  final FocusNode _focusNode = FocusNode();
  bool _isButtonEnabled = false;
  String? _phoneError;
  String? _addressError;

  void _checkFields() {
    setState(() {
      String phoneText = _phoneController.text.trim();
      if (phoneText.isEmpty) {
        _phoneError = 'Phone number cannot be empty';
      } else if (!RegExp(r'^[0-9]+$').hasMatch(phoneText)) {
        _phoneError = 'Phone number can only contain numbers';
      } else if (phoneText.length > 10) {
        _phoneError = 'Phone number cannot exceed 10 digits';
      } else {
        _phoneError = null;
      }

      String addressText = _addressController.text.trim();
      if (addressText.isEmpty) {
        _addressError = 'Address cannot be empty';
      } else if (addressText.length > 100) {
        _addressError = 'Address cannot exceed 100 characters';
      } else {
        _addressError = null;
      }

      _isButtonEnabled = _phoneError == null && _addressError == null;
    });
  }

  void _handleContinue() async {
    if (_isButtonEnabled) {
      try {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => AccountPage(
              currentStep: widget.currentStep + 1,
            ),
          ),
        );
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _addressController.addListener(_checkFields);
    _phoneController.addListener(_checkFields);
  }

  @override
  void dispose() {
    _addressController.dispose();
    _phoneController.dispose();
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
          if (event is RawKeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.enter) {
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0.0, vertical: 50.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(3, (index) {
                                return _buildStepIndicator(
                                    isActive: index <= widget.currentStep);
                              }),
                            ),
                            SizedBox(height: screenHeight * 0.05),

                            const Text(
                              'Enter your phone number',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            CupertinoTextField(
                              controller: _phoneController,
                              keyboardType: TextInputType.number,
                              maxLength: 15,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 19, horizontal: 16),
                              cursorColor: Colors.black,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            if (_phoneError != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    _phoneError!, //
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
                            const SizedBox(height: 5),
                            const Text(
                              'Enter your address',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            CupertinoTextField(
                              controller: _addressController,
                              keyboardType: TextInputType.streetAddress,
                              maxLength: 100,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 19, horizontal: 16),
                              cursorColor: Colors.black,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            if (_addressError != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    _addressError!, //
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
