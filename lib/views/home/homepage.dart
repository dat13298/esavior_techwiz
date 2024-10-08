import 'package:esavior_techwiz/models/hospital.dart';
import 'package:esavior_techwiz/views/home/profile_tab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../controllers/map_controller.dart';
import '../../models/account.dart';
import '../../services/city_service.dart';
import '../booking_history/booking_history.dart';
import '../welcome/call_emergency.dart';
import 'gallery.dart';
import 'about.dart';

class HomePage extends StatefulWidget {
  final Account account;

  const HomePage({super.key, required this.account});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late List<Widget> _tabs;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabs = [
      HomeTabState(
        account: widget.account,
      ),
      BookingHistory(currentAccount: widget.account),
      Notifications(account: widget.account),
      ProfileUserTab(account: widget.account),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentIndex],
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      backgroundColor: Colors.white,
      selectedItemColor: const Color(0xFF10CCC6),
      unselectedItemColor: Colors.black,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(
            icon: Icon(Icons.access_time), label: "Activity"),
        BottomNavigationBarItem(
          icon: Icon(Icons.info),
          label: "About",
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}

class HomeTabState extends StatefulWidget {
  final Account account;

  const HomeTabState({super.key, required this.account});

  @override
  State<HomeTabState> createState() => _HomeTabStateState();
}

class _HomeTabStateState extends State<HomeTabState> {
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = '';
  final CityService _cityService = CityService();
  bool _isHospitalListVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(110.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: const Color(0xFF10CCC6),
            title: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('eSavior',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
                Text('Your health is our care!',
                    style: TextStyle(fontSize: 20)),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Hospital',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      _searchTerm = _searchController.text.trim();
                      _isHospitalListVisible = true;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_isHospitalListVisible) _buildHospitalList(),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 70, vertical: 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const CallEmergency(),
                    ),
                  );
                },
                child: const Text(
                  'Call emergency',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Ambulance gallery',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.35,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 6,
                itemBuilder: (context, index) {
                  final carList = [
                    {'imagePath': 'assets/ford/1.jpg', 'title': 'Ford Transit'},
                    {
                      'imagePath': 'assets/mercedes/1.png',
                      'title': 'Mercedes-Benz Sprinter'
                    },
                    {
                      'imagePath': 'assets/toyota/1.jpg',
                      'title': 'Toyota Hiace'
                    },
                    {
                      'imagePath': 'assets/landrover/1.jpg',
                      'title': 'Nissan NV350'
                    },
                    {
                      'imagePath': 'assets/vokswa/1.jpg',
                      'title': 'Volkswagen Crafter'
                    }
                  ];
                  if (index < 5) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: AmbulanceCard(
                        imagePath: carList[index]['imagePath']!,
                        title: carList[index]['title']!,
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const GalleryPage()),
                          );
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.35,
                          height: MediaQuery.of(context).size.width * 0.3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[300],
                          ),
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'See More',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Icon(Icons.arrow_forward, size: 16),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHospitalList() {
    return StreamBuilder<List<Hospital>>(
      stream: _cityService.getAllHospital(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final hospitals = snapshot.data!;
        final filteredHospitals = hospitals.where((hospital) {
          return hospital.name
              .toLowerCase()
              .contains(_searchTerm.toLowerCase());
        }).toList();
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filteredHospitals.length,
          itemBuilder: (context, index) {
            final hospital = filteredHospitals[index];
            return ListTile(
              title: Text(hospital.name),
              subtitle: Text(hospital.address),
              trailing: IconButton(
                icon: const Icon(Icons.directions_car, color: Colors.blue),
                onPressed: () {
                  showMapScreen(
                      context, hospital.address, widget.account, null);
                },
              ),
            );
          },
        );
      },
    );
  }
}

class AmbulanceCard extends StatelessWidget {
  final String imagePath;
  final String title;

  const AmbulanceCard(
      {super.key, required this.imagePath, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 120,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(title),
      ],
    );
  }
}
