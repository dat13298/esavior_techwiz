import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esavior_techwiz/models/hospital.dart';

class CityService{
  final CollectionReference _cityCollection = FirebaseFirestore.instance.collection('city');

  // GET,ADD,DEL,EDIT HOSPITAL
  Stream<List<Hospital>> getAllHospital() {
    return _cityCollection.snapshots().map((snapshot) {
      if (snapshot.docs.isEmpty) return [];

      List<Hospital> allHospital = [];
      var doc = snapshot.docs.first;
      final data = doc.data() as Map<String, dynamic>;
      String cityID = doc.id;

      final List<dynamic>? cityData = data['city'] as List<dynamic>?;

      if (cityData != null) {
        for (var city in cityData) {
          cityID = city['id'];
          String cityName = city['name'];

          final List<dynamic>? cityHospital = city['hospital'] as List<dynamic>?;
          if (cityHospital != null) {
            allHospital.addAll(
              cityHospital.map((hospitalData) {
                hospitalData['cityID'] = cityID;
                hospitalData['cityName'] = cityName;
                return Hospital.fromMap(hospitalData as Map<String, dynamic>);
              }).toList(),
            );
          }
        }
      }
      return allHospital;
    });
  }

  Future<void> deleteHospital(String hospitalID, String cityID) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final DocumentReference _cityDocRef = _firestore.collection('city').doc('v4NkyzRqkXjx8YEiYgSC');

    try {
      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot cityDocSnapshot = await transaction.get(_cityDocRef);

        if (!cityDocSnapshot.exists) {
          throw Exception('City document does not exist');
        }

        Map<String, dynamic> cityDocData = cityDocSnapshot.data() as Map<String, dynamic>;
        List<dynamic> cities = cityDocData['city'] as List<dynamic>;

        bool hospitalFound = false;
        for (int i = 0; i < cities.length; i++) {
          if (cities[i]['id'] == cityID) {
            List<dynamic> hospitals = cities[i]['hospital'] as List<dynamic>;
            int originalLength = hospitals.length;
            hospitals.removeWhere((hospital) => hospital['id'] == hospitalID);

            if (hospitals.length < originalLength) {
              hospitalFound = true;
              cities[i]['hospital'] = hospitals;
              break;
            }
          }
        }

        if (!hospitalFound) {
          throw Exception('Hospital with ID $hospitalID not found in city $cityID');
        }

        transaction.update(_cityDocRef, {'city': cities});
      });

      print('Hospital deleted successfully');
    } catch (e) {
      print('Error deleting hospital: $e');
      rethrow;
    }
  }

  Future<void> updateHospital(String cityID, String hospitalID, String newName, String newAddress) async {
    try {
      // Lấy reference đến document chứa tất cả các thành phố
      DocumentReference cityDocRef = _cityCollection.doc('v4NkyzRqkXjx8YEiYgSC');

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot cityDocSnapshot = await transaction.get(cityDocRef);

        if (!cityDocSnapshot.exists) {
          throw Exception('City document does not exist');
        }

        Map<String, dynamic> cityDocData = cityDocSnapshot.data() as Map<String, dynamic>;
        List<dynamic> cities = cityDocData['city'] as List<dynamic>;

        bool hospitalFound = false;
        for (int i = 0; i < cities.length; i++) {
          if (cities[i]['id'] == cityID) {
            List<dynamic> hospitals = cities[i]['hospital'] as List<dynamic>;
            for (int j = 0; j < hospitals.length; j++) {
              if (hospitals[j]['id'] == hospitalID) {
                hospitals[j]['name'] = newName;
                hospitals[j]['address'] = newAddress;
                hospitalFound = true;
                break;
              }
            }
            if (hospitalFound) {
              cities[i]['hospital'] = hospitals;
              break;
            }
          }
        }

        if (!hospitalFound) {
          throw Exception('Hospital with ID $hospitalID not found in city $cityID');
        }

        transaction.update(cityDocRef, {'city': cities});
      });

      print('Hospital updated successfully');
    } catch (e) {
      print('Error updating hospital: $e');
      rethrow;
    }
  }

  Future<void> addHospital(String cityId, String hospitalName, String hospitalAddress) async {
    try {
      DocumentSnapshot citySnapshot = await _cityCollection.doc('v4NkyzRqkXjx8YEiYgSC').get();
      if (citySnapshot.exists) {
        Map<String, dynamic> data = citySnapshot.data() as Map<String, dynamic>;
        List cities = data['city'];

        // Tìm city có ID tương ứng
        int cityIndex = cities.indexWhere((city) => city['id'] == cityId);
        if (cityIndex != -1) {
          List hospitals = cities[cityIndex]['hospital'] ?? [];

          // Thêm bệnh viện mới vào danh sách hospital
          hospitals.add({
            'id': DateTime.now().millisecondsSinceEpoch.toString(), // Tạo ID bệnh viện mới
            'name': hospitalName,
            'address': hospitalAddress,
          });

          // Cập nhật lại city trong Firestore
          cities[cityIndex]['hospital'] = hospitals;
          await _cityCollection.doc('v4NkyzRqkXjx8YEiYgSC').update({'city': cities});
          print('Hospital added successfully');
        }
      }
    } catch (e) {
      print('Error adding hospital: $e');
    }
  }
  //GET LIST CITY
  Future<List<Map<String, dynamic>>> getCities() async {
    try {
      DocumentSnapshot docSnapshot = await _cityCollection.doc('v4NkyzRqkXjx8YEiYgSC').get();
      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
        List<dynamic> cities = data['city'] ?? [];
        return List<Map<String, dynamic>>.from(cities);
      }
    } catch (e) {
      print('Error getting cities: $e');
    }
    return [];
  }


  Future<List<Hospital>> getHospitalsByName(String name) async {
    final snapshot = await _cityCollection.get();
    if (snapshot.docs.isEmpty) return [];

    List<Hospital> matchingHospitals = [];

    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final hospital = Hospital.fromMap(data);

      if (hospital.name.toLowerCase().contains(name.toLowerCase())) {
        matchingHospitals.add(hospital);
      }
    }

    return matchingHospitals;
  }

  Future<List<Hospital>> getHospitalsByLocation(String address) async {
    final snapshot = await _cityCollection.get();
    if (snapshot.docs.isEmpty) return [];

    List<Hospital> matchingHospitals = [];

    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final hospital = Hospital.fromMap(data);

      if (hospital.address.toLowerCase().contains(address.toLowerCase())) {
        matchingHospitals.add(hospital);
      }
    }

    return matchingHospitals;
  }
}


// GET,ADD,DEL,EDIT CAR
