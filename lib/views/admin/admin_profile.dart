  import 'package:bcrypt/bcrypt.dart';
import 'package:esavior_techwiz/models/account.dart';
  import 'package:flutter/cupertino.dart';
  import 'package:flutter/material.dart';
  
  import '../../services/account_service.dart';
import '../../services/admin_notification_service.dart';
import '../welcome/welcome_page.dart';
  import 'customAppBar.dart';
  
  class ProfileTab extends StatefulWidget {
    final Account account;
    const ProfileTab({super.key, required this.account});
  
    @override
    State<ProfileTab> createState() => _ProfileTabState();
  }
  
  class _ProfileTabState extends State<ProfileTab> {
    late AdminNotificationService _notificationService;

    String currentTab = 'Profile'; // Biến để theo dõi tab hiện tại

    @override
    void initState() {
      super.initState();
      _notificationService = AdminNotificationService((tab) {
        // Cập nhật tab hiện tại
        setState(() {
          currentTab = tab;
        });
        return currentTab; // Trả về tab hiện tại
      });

      _notificationService.listenForNotifications();
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: CustomAppBar(
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
              // User Name
              Text(
                widget.account.fullName,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              // User Email
              Text(
                'Phone Number: ${widget.account.phoneNumber}',
                // Hiển thị số điện thoại
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 5),
              // User Phone
              Text(
                'Email: ${widget.account.email}', // Hiển thị email
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 5),
              // User Phone
              Text(
                'Address: ${widget.account.addressHome}', // Hiển thị email
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
  
              // Edit Profile Button
              _buildProfileOption(
                icon: Icons.edit,
                text: 'Edit profile',
                onTap: () {
                  _showEditDialog(context);
                },
              ),
              const SizedBox(height: 10),
  
              // Change Password Button
              _buildProfileOption(
                icon: Icons.lock,
                text: 'Change password',
                onTap: () {
                  _showChangePasswordDialog(context);
                },
              ),
              const SizedBox(height: 10),
  
              // About this app Button

              const Spacer(),
  
              // Log Out Button
  
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
                    MaterialPageRoute(builder: (context) => WelcomePage()),
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
      final TextEditingController _passwordController = TextEditingController();
      final TextEditingController _newPasswordController = TextEditingController();
      final TextEditingController _confirmPasswordController = TextEditingController();

      bool _obscureCurrentPassword = true;
      bool _obscureNewPassword = true;
      bool _obscureConfirmPassword = true;

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
                      const Text('Change Password', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),

                      // Current Password Field
                      TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Current Password',
                          suffixIcon: IconButton(
                            icon: Icon(_obscureCurrentPassword ? Icons.visibility_off : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                _obscureCurrentPassword = !_obscureCurrentPassword;
                              });
                            },
                          ),
                        ),
                        obscureText: _obscureCurrentPassword,
                      ),

                      // New Password Field
                      TextField(
                        controller: _newPasswordController,
                        decoration: InputDecoration(
                          labelText: 'New Password',
                          suffixIcon: IconButton(
                            icon: Icon(_obscureNewPassword ? Icons.visibility_off : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                _obscureNewPassword = !_obscureNewPassword;
                              });
                            },
                          ),
                        ),
                        obscureText: _obscureNewPassword,
                      ),

                      // Confirm Password Field
                      TextField(
                        controller: _confirmPasswordController,
                        decoration: InputDecoration(
                          labelText: 'Confirm New Password',
                          suffixIcon: IconButton(
                            icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword = !_obscureConfirmPassword;
                              });
                            },
                          ),
                        ),
                        obscureText: _obscureConfirmPassword,
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
                              String currentPassword = _passwordController.text;
                              String newPassword = _newPasswordController.text;
                              String confirmPassword = _confirmPasswordController.text;

                              if (newPassword != confirmPassword) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('New password and confirmation do not match!')),
                                );
                                return;
                              }

                              // So sánh mật khẩu hiện tại với mật khẩu đã lưu trên Firebase
                              bool passwordMatches = BCrypt.checkpw(currentPassword, widget.account.passwordHash);
                              if (!passwordMatches) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Current password is incorrect!')),
                                );
                                return;
                              }

                              // Hash mật khẩu mới
                              String hashedNewPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());

                              // Tạo đối tượng Account mới với mật khẩu được băm
                              Account updatedAccount = Account(
                                fullName: widget.account.fullName,
                                phoneNumber: widget.account.phoneNumber,
                                email: widget.account.email,
                                addressHome: widget.account.addressHome,
                                passwordHash: hashedNewPassword,  // Lưu mật khẩu đã băm
                                addressCompany: widget.account.addressCompany,
                                role: widget.account.role,
                                feedbacks: widget.account.feedbacks,
                                status: widget.account.status,
                              );

                              // Cập nhật mật khẩu mới lên Firebase bằng email
                              await AccountService().updateAccountByEmail(widget.account.email, updatedAccount);

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Password has been updated successfully!')),
                              );

                              Navigator.of(context).pop(); // Đóng dialog
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
      final TextEditingController _nameController = TextEditingController(text: widget.account.fullName);
      final TextEditingController _phoneController = TextEditingController(text: widget.account.phoneNumber);
      final TextEditingController _emailController = TextEditingController(text: widget.account.email);
      final TextEditingController _addressController = TextEditingController(text: widget.account.addressHome);

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
                  const Text('Edit Information', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  TextField(
                    controller: _phoneController,
                    decoration: const InputDecoration(labelText: 'Phone Number'),
                    keyboardType: TextInputType.phone,
                  ),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  TextField(
                    controller: _addressController,
                    decoration: const InputDecoration(labelText: 'Address'),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop(); // Đóng dialog
                        },
                      ),
                      TextButton(
                        child: const Text('Save'),
                        onPressed: () async {
                          String name = _nameController.text;
                          String phone = _phoneController.text;
                          String email = _emailController.text;
                          String address = _addressController.text;

                          // Cập nhật thông tin tài khoản
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

                          // Cập nhật tài khoản theo email
                          await AccountService().updateAccountByEmail(email, updatedAccount);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Information has been updated successfully!')),
                          );

                          Navigator.of(context).pop(); // Đóng dialog
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
  
