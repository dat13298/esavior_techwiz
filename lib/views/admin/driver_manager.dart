import 'package:esavior_techwiz/services/booking_service.dart';
import 'package:esavior_techwiz/services/driver_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../models/account.dart';
import 'custom_app_bar.dart';

class DriverManager extends StatefulWidget {
  const DriverManager({super.key});

  @override
  DriverManagerState createState() => DriverManagerState();
}

class DriverManagerState extends State<DriverManager> {
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = '';
  final DriverService _driverService = DriverService();
  final BookingService _bookingService = BookingService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Driver Manager',
        subtitle: 'Manage all drivers',
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Driver',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      _searchTerm = _searchController.text;
                    });
                  },
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _showAddDriverDialog(context);
            },
            child: const Text('Add Driver'),
          ),
          Expanded(
            child: StreamBuilder<List<Account>>(
              stream: _driverService.getAllDriver(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No drivers found"));
                }
                final filteredDrivers = snapshot.data!.where((driver) {
                  final nameMatch = driver.fullName
                      .toLowerCase()
                      .contains(_searchTerm.toLowerCase());
                  final phoneMatch = driver.phoneNumber
                      .toLowerCase()
                      .contains(_searchTerm.toLowerCase());
                  return nameMatch || phoneMatch;
                }).toList();
                return ListView.builder(
                  itemCount: filteredDrivers.length,
                  itemBuilder: (context, index) {
                    final driver = filteredDrivers[index];
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(driver.fullName[0]),
                      ),
                      title: Text(driver.fullName),
                      subtitle: Text(driver.phoneNumber),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              _showEditDriverDialog(driver);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _confirmDeleteDriver(driver);
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        _showBookingHistory(driver.phoneNumber);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDriverDialog(Account driver) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController nameController =
            TextEditingController(text: driver.fullName);
        TextEditingController addHomeController =
            TextEditingController(text: driver.addressHome);
        TextEditingController addCompanyController =
            TextEditingController(text: driver.addressCompany);

        return AlertDialog(
          title: const Text('Edit Driver'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Driver name'),
              ),
              TextField(
                controller: addHomeController,
                decoration: const InputDecoration(labelText: 'Home Address'),
              ),
              TextField(
                controller: addCompanyController,
                decoration: const InputDecoration(labelText: 'Company Address'),
              ),
              Text('Phone number: ${driver.phoneNumber}'),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _editDriver(
                  driver.phoneNumber,
                  nameController.text,
                  addHomeController.text,
                  addCompanyController.text,
                );
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showBookingHistory(String phoneNumber) async {
    try {
      final bookings =
          await _bookingService.getBookingsByDriverPhoneNumber(phoneNumber);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Booking History'),
            content: bookings.isEmpty
                ? const Text('No bookings found for this driver.')
                : SizedBox(
                    width: double.maxFinite,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: bookings.length,
                      itemBuilder: (context, index) {
                        final booking = bookings[index];
                        return ListTile(
                          title: Text(
                              'User phone number: ${booking.userPhoneNumber}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Cost: ${booking.cost}'),
                              Text('Status: ${booking.status}'),
                              Text('Date: ${booking.formattedDateTime}'),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching booking history: $e');
      }
    }
  }

  void _editDriver(String phoneNumber, String newFullName, String newHomeAdd,
      String newCompAdd) async {
    try {
      await DriverService().editDriver(
        phoneNumber,
        newFullName: newFullName,
        newHomeAdd: newHomeAdd,
        newCompAdd: newCompAdd,
      );
      if (kDebugMode) {
        print('Driver $newFullName updated');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating driver: $e');
      }
    }
  }

  void _showAddDriverDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController addHomeController = TextEditingController();
    final TextEditingController addCompanyController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Driver'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: addHomeController,
                decoration: const InputDecoration(labelText: 'Home Address'),
              ),
              TextField(
                controller: addCompanyController,
                decoration: const InputDecoration(labelText: 'Company Address'),
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _driverService.addDriver(
                  nameController.text,
                  phoneController.text,
                  emailController.text,
                  addHomeController.text,
                  addCompanyController.text,
                  passwordController.text,
                );
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDeleteDriver(Account account) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: Text('Are you sure you want to delete ${account.fullName}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
            ElevatedButton(
              onPressed: () {
                _deleteDriver(account);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _deleteDriver(Account account) async {
    await DriverService().deleteDriver(account.phoneNumber);
    setState(() {
      if (kDebugMode) {
        print('Driver ${account.fullName} deleted');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchTerm = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
