import 'package:bcrypt/bcrypt.dart';
import 'package:esavior_techwiz/models/account.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../services/account_service.dart';
import '../login/login.dart';

class AccountPage extends StatefulWidget {
  final int currentStep;
  final String fullName;
  final String phone_number;
  final String address;

  const AccountPage({
    super.key,
    required this.currentStep,
    required this.fullName,
    required this.phone_number,
    required this.address,
  });

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String? _emailError;
  String? _passwordError;
  bool _passwordsMatch = true;
  bool _isButtonEnabled = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  void _checkFields() {
    setState(() {
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();
      String confirmPassword = _confirmPasswordController.text.trim();

      if (email.isEmpty) {
        _emailError = 'Email cannot be empty';
      } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
        _emailError = 'Invalid email format';
      } else if (email.length > 50) {
        _emailError = 'Email cannot exceed 50 characters';
      } else {
        _emailError = null;
      }
      if (password.isEmpty || confirmPassword.isEmpty) {
        _passwordError = 'Password cannot be empty';
        _passwordsMatch = true;
      } else if (password.length < 8) {
        _passwordError = 'Password must be at least 8 characters';
        _passwordsMatch = false;
      } else if (password.length > 255) {
        _passwordError = 'Password cannot exceed 255 characters';
        _passwordsMatch = false;
      } else if (password != confirmPassword) {
        _passwordError = 'Passwords don\'t match. Try again!';
        _passwordsMatch = false;
      } else {
        _passwordError = null;
        _passwordsMatch = true;
      }
      _isButtonEnabled =
          _emailError == null && _passwordError == null && _passwordsMatch;
    });
  }

  Future<void> _handleRegister() async {
    if (_isButtonEnabled) {
      try {
        final password = _passwordController.text;
        final hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
        Account newAccount = Account(
          fullName: widget.fullName,
          phoneNumber: widget.phone_number,
          passwordHash: hashedPassword,
          email: _emailController.text,
          addressHome: widget.address,
          addressCompany: "",
          feedbacks: [],
          role: "user",
          status: " ",
        );
        await AccountService().addAccount(newAccount);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đăng ký thất bại: $e')),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_checkFields);
    _passwordController.addListener(_checkFields);
    _confirmPasswordController.addListener(_checkFields);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return CupertinoPageScaffold(
      child: Material(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
          child: Container(
            height: screenHeight,
            width: screenWidth,
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.1),
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
                            'Enter your email',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          CupertinoTextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            padding: const EdgeInsets.symmetric(
                                vertical: 19, horizontal: 16),
                            cursorColor: Colors.black,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          if (_emailError != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  _emailError!,
                                  style: const TextStyle(
                                    fontSize: 18,
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
                            'Enter your password',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          _buildPasswordField(
                              _passwordController, _obscurePassword, () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          }),
                          const SizedBox(height: 5),
                          const Text(
                            'Re-enter your password',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          _buildPasswordField(_confirmPasswordController,
                              _obscureConfirmPassword, () {
                            setState(() {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                            });
                          }),
                          if (!_passwordsMatch)
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  _passwordError!,
                                  style: const TextStyle(
                                    fontSize: 18,
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
                    onTap: _isButtonEnabled ? _handleRegister : null,
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
                            'Register',
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
    );
  }

  Widget _buildPasswordField(TextEditingController controller, bool obscureText,
      VoidCallback toggleVisibility) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        CupertinoTextField(
          controller: controller,
          obscureText: obscureText,
          padding: const EdgeInsets.symmetric(vertical: 19, horizontal: 16),
          cursorColor: Colors.black,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        Positioned(
          right: 10,
          child: GestureDetector(
            onTap: toggleVisibility,
            child: Icon(
              obscureText ? Icons.visibility_off : Icons.visibility,
              color: Colors.black38,
            ),
          ),
        ),
      ],
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
