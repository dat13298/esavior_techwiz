import 'package:bcrypt/bcrypt.dart';
import 'package:esavior_techwiz/models/account.dart';
import 'package:flutter/material.dart';
import '../../services/account_service.dart';
import '../welcome/welcome_page.dart';
import 'custom_app_bar.dart';

class ProfileTab extends StatefulWidget {
  final Account account;

  const ProfileTab({super.key, required this.account});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Profile',
        subtitle: 'Profile page',
        showBackButton: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Picture
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[300],
              child: Icon(
                Icons.person,
                size: 60,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.account.fullName,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Phone Number: ${widget.account.phoneNumber}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 5),
            Text(
              'Email: ${widget.account.email}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 5),
            Text(
              'Address: ${widget.account.addressHome}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            _buildProfileOption(
              icon: Icons.edit,
              text: 'Edit profile',
              onTap: () {
                _showEditDialog(context);
              },
            ),
            const SizedBox(height: 10),
            _buildProfileOption(
              icon: Icons.lock,
              text: 'Change password',
              onTap: () {
                _showChangePasswordDialog(context);
              },
            ),
            const SizedBox(height: 10),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10CCC6),
                padding:
                    const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () async {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const WelcomePage()),
                );
              },
              child: const Text(
                'Log out',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(
      {required IconData icon, required String text, required Function onTap}) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.black),
            const SizedBox(width: 10),
            Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();

    bool obscureCurrentPassword = true;
    bool obscureNewPassword = true;
    bool obscureConfirmPassword = true;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Change Password',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: 'Current Password',
                        suffixIcon: IconButton(
                          icon: Icon(obscureCurrentPassword
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              obscureCurrentPassword = !obscureCurrentPassword;
                            });
                          },
                        ),
                      ),
                      obscureText: obscureCurrentPassword,
                    ),
                    TextField(
                      controller: newPasswordController,
                      decoration: InputDecoration(
                        labelText: 'New Password',
                        suffixIcon: IconButton(
                          icon: Icon(obscureNewPassword
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              obscureNewPassword = !obscureNewPassword;
                            });
                          },
                        ),
                      ),
                      obscureText: obscureNewPassword,
                    ),
                    TextField(
                      controller: confirmPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Confirm New Password',
                        suffixIcon: IconButton(
                          icon: Icon(obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              obscureConfirmPassword = !obscureConfirmPassword;
                            });
                          },
                        ),
                      ),
                      obscureText: obscureConfirmPassword,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop(); // Close dialog
                          },
                        ),
                        TextButton(
                          child: const Text('Save'),
                          onPressed: () async {
                            String currentPassword = passwordController.text;
                            String newPassword = newPasswordController.text;
                            String confirmPassword =
                                confirmPasswordController.text;

                            if (newPassword != confirmPassword) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'New password and confirmation do not match!')),
                              );
                              return;
                            }
                            bool passwordMatches = BCrypt.checkpw(
                                currentPassword, widget.account.passwordHash);
                            if (!passwordMatches) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Current password is incorrect!')),
                              );
                              return;
                            }
                            String hashedNewPassword =
                                BCrypt.hashpw(newPassword, BCrypt.gensalt());
                            Account updatedAccount = Account(
                              fullName: widget.account.fullName,
                              phoneNumber: widget.account.phoneNumber,
                              email: widget.account.email,
                              addressHome: widget.account.addressHome,
                              passwordHash: hashedNewPassword,
                              addressCompany: widget.account.addressCompany,
                              role: widget.account.role,
                              feedbacks: widget.account.feedbacks,
                              status: widget.account.status,
                            );
                            await AccountService().updateAccountByEmail(
                                widget.account.email, updatedAccount);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Password has been updated successfully!')),
                            );
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showEditDialog(BuildContext context) {
    final TextEditingController nameController =
        TextEditingController(text: widget.account.fullName);
    final TextEditingController phoneController =
        TextEditingController(text: widget.account.phoneNumber);
    final TextEditingController emailController =
        TextEditingController(text: widget.account.email);
    final TextEditingController addressController =
        TextEditingController(text: widget.account.addressHome);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Edit Information',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                  keyboardType: TextInputType.phone,
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                ),
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(labelText: 'Address'),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: const Text('Save'),
                      onPressed: () async {
                        String name = nameController.text;
                        String phone = phoneController.text;
                        String email = emailController.text;
                        String address = addressController.text;
                        Account updatedAccount = Account(
                          fullName: name,
                          phoneNumber: phone,
                          email: email,
                          addressHome: address,
                          passwordHash: widget.account.passwordHash,
                          addressCompany: widget.account.addressCompany,
                          role: widget.account.role,
                          feedbacks: widget.account.feedbacks,
                          status: widget.account.status,
                        );
                        await AccountService()
                            .updateAccountByEmail(email, updatedAccount);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Information has been updated successfully!')),
                        );
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
