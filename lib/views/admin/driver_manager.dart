import 'package:esavior_techwiz/services/booking_service.dart';
import 'package:esavior_techwiz/services/drver_service.dart';
import 'package:flutter/material.dart';
import '../../models/account.dart';
import '../../services/account_service.dart';
import 'customAppBar.dart';

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
      appBar: CustomAppBar(
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
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
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
              //display form to add driver
              _showAddDriverDialog(context);
            },
            child: Text('Add Driver'),
          ),
          Expanded(
            child: StreamBuilder<List<Account>>(
              stream: _driverService.getAllDriver(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text("No drivers found"));
                }
                final filteredDrivers = snapshot.data!.where((driver) {
                  final nameMatch = driver.fullName.toLowerCase().contains(_searchTerm.toLowerCase());
                  final phoneMatch = driver.phoneNumber.toLowerCase().contains(_searchTerm.toLowerCase());
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
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              // Implement edit functionality
                              _showEditDriverDialog(driver);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              // Implement delete functionality
                              _confirmDeleteDriver(driver);
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        // Show the booking history dialog when tapped
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
        TextEditingController nameController = TextEditingController(
            text: driver.fullName);
        TextEditingController addHomeController = TextEditingController(
            text: driver.addressHome);
        TextEditingController addCompanyController = TextEditingController(
            text: driver.addressCompany);

        return AlertDialog(
          title: Text('Edit Driver'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Driver name'),
              ),
              TextField(
                controller: addHomeController,
                decoration: InputDecoration(labelText: 'Home Address'),
              ),
              TextField(
                controller: addCompanyController,
                decoration: InputDecoration(labelText: 'Company Address'),
              ),
              // Display phone number as read-only text
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
              child: Text('Save'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showBookingHistory(String phoneNumber) async {
    try {
      // Assuming getBookingsByDriverPhoneNumber is a method in DriverService
      final bookings = await _bookingService.getBookingsByDriverPhoneNumber(phoneNumber);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Booking History'),
            content: bookings.isEmpty
                ? Text('No bookings found for this driver.')
                : SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final booking = bookings[index];
                  return ListTile(
                    title: Text('User phone number: ${booking.userPhoneNumber}'),
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
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Error fetching booking history: $e');
      // Optionally, show an error dialog to the user
    }
  }

  void _editDriver(String phoneNumber, String newFullName, String newHomeAdd, String newCompAdd) async {
    try {
      await DriverService().editDriver(
        phoneNumber,
        newFullName: newFullName,
        newHomeAdd: newHomeAdd,
        newCompAdd: newCompAdd,
      );
      print('Driver $newFullName updated');
    } catch (e) {
      print('Error updating driver: $e');
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
          title: Text('Add New Driver'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Full Name'),
              ),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(labelText: 'Phone Number'),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: addHomeController,
                decoration: InputDecoration(labelText: 'Home Address'),
              ),
              TextField(
                controller: addCompanyController,
                decoration: InputDecoration(labelText: 'Company Address'),
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
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
              child: Text('Save'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
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
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete ${account.fullName}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
            ElevatedButton(
              onPressed: () {
                _deleteDriver(account);
                Navigator.of(context).pop();
              },
              child: Text('Yes'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            ),
          ],
        );
      },
    );
  }

  void _deleteDriver(Account account) async {
    await DriverService().deleteDriver(account.phoneNumber);
    setState(() {
      print('Driver ${account.fullName} deleted');
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