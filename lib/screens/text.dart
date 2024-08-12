import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatelessWidget {
  final LocationController locationController = Get.put(LocationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Get.to(() => UserScreen()),
              child: Text('Login as User'),
            ),
            ElevatedButton(
              onPressed: () => Get.to(() => AdminScreen()),
              child: Text('Login as Admin'),
            ),
          ],
        ),
      ),
    );
  }
}

class UserScreen extends StatelessWidget {
  final LocationController locationController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Screen')),
      body: Center(
        child: ElevatedButton(
          onPressed: locationController.startTracking,
          child: Text('Start Tracking'),
        ),
      ),
    );
  }
}

class AdminScreen extends StatelessWidget {
  final LocationController locationController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin Screen')),
      body: Obx(() => GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(0, 0),
              zoom: 2,
            ),
            markers: locationController.markers.values.toSet(),
            onMapCreated: (GoogleMapController controller) {
              locationController.mapController = controller;
            },
          )),
    );
  }
}

class LocationController extends GetxController {
  final String userId = "user_123"; // Mock user ID
  GoogleMapController? mapController;
  final markers = <String, Marker>{}.obs;

  void startTracking() async {
    if (await Permission.location.request().isGranted) {
      Geolocator.getPositionStream().listen((Position position) {
        FirebaseFirestore.instance.collection('users').doc(userId).set({
          'location': GeoPoint(position.latitude, position.longitude),
        });
      });
    }
  }

  @override
  void onInit() {
    super.onInit();
    _listenToUserLocations();
  }

  void _listenToUserLocations() {
    FirebaseFirestore.instance.collection('users').snapshots().listen((snapshot) {
      for (var doc in snapshot.docs) {
        var data = doc.data();
        GeoPoint location = data['location'];
        _updateMarker(doc.id, LatLng(location.latitude, location.longitude));
      }
    });
  }

  void _updateMarker(String userId, LatLng position) {
    markers[userId] = Marker(
      markerId: MarkerId(userId),
      position: position,
      infoWindow: InfoWindow(title: userId),
    );
  }
}
