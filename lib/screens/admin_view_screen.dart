import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:task_tracker_app/models/user_model.dart';
import 'package:task_tracker_app/suported_widgets/square_button.dart';

import '../consts/app_color_constants.dart';
import '../consts/constants.dart';
import 'login_screen.dart';
import 'user_current_location.dart';

// ignore: must_be_immutable
class AdminViewScreen extends StatelessWidget {
  AdminViewScreen({super.key, required this.userModel});
  final UserModel userModel;
  final TextEditingController _searchController = TextEditingController();

  final RxDouble _currentLatitude = 37.7749.obs;
  final RxDouble _currentLongitude = (-122.4194).obs;
  final RxDouble _selectedLatitude = 37.7749.obs;
  final RxDouble _selectedLongitude = (-122.4194).obs;
  GoogleMapController? _mapController;

  void _updateSelectedLocation(LatLng latLng) {
    _selectedLatitude.value = latLng.latitude;
    _selectedLongitude.value = latLng.longitude;
  }

  void _searchLocation(String query) async {
    try {
      List<Location> locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        final LatLng latLng =
            LatLng(locations.first.latitude, locations.first.longitude);
        _selectedLatitude.value = latLng.latitude;
        _selectedLongitude.value = latLng.longitude;
        _currentLatitude.value = latLng.latitude;
        _currentLongitude.value = latLng.longitude;
        _mapController?.animateCamera(CameraUpdate.newLatLng(latLng));
      }
    } catch (e) {
      Get.snackbar('Error', 'Location not found.');
    }
  }

  Future<void> updateLocationTask(id) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(id).update({
        "taskLatitude": _selectedLatitude.value,
        "taskLongitude": _selectedLongitude.value
      });
      Get.snackbar('Success', 'Task location updated successfully.');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update task location.');
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users View'),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Get.offAll(() => LoginPage());
            },
            icon: const Row(
              children: [
                Text("Logout",
                    style: TextStyle(fontSize: 15, color: Colors.red)),
                Icon(Icons.login_outlined, color: Colors.red),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              gapH(20),
              Text(
                "Username: ${userModel.name}",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColorsConstants.blackColor,
                ),
              ),
              gapH(10),
              userModel.taskLatitude != 0.1
                  ? Text(
                      "Task Status: ${userModel.taskStatus ? 'Done' : userModel.startButton && userModel.taskStatus == false ? "Running" : 'Pending'}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColorsConstants.primaryColor,
                      ),
                    )
                  : SizedBox(),
              gapH(10),
              InkWell(
                onTap: () {
                  Get.to(UserCurrentLocation(
                    latitude: userModel.latitude,
                    longitude: userModel.longitude,
                  ));
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.lightBlueAccent,
                      borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "User Location",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),
              gapH(15),
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search Location',
                  border: OutlineInputBorder(),
                  suffixIcon: InkWell(
                    onTap: () {
                      _searchLocation(_searchController.text);
                    },
                    child: const Icon(Icons.search),
                  ),
                ),
                onSubmitted: _searchLocation,
              ),
              gapH(10),
              Expanded(
                child: Obx(
                  () => GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                          _currentLatitude.value, _currentLongitude.value),
                      zoom: 15.0,
                    ),
                    onMapCreated: (controller) {
                      _mapController = controller;
                    },
                    onTap: (latLng) {
                      _updateSelectedLocation(latLng);
                    },
                    markers: {
                      Marker(
                        markerId: MarkerId('currentLocation'),
                        position: LatLng(
                            _currentLatitude.value, _currentLongitude.value),
                        infoWindow: const InfoWindow(title: 'Current Location'),
                      ),
                      Marker(
                        markerId: MarkerId('selectedLocation'),
                        position: LatLng(
                            _selectedLatitude.value, _selectedLongitude.value),
                        infoWindow:
                            const InfoWindow(title: 'Selected Location'),
                      ),
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: SquareButton(
                  onTap: () async {
                    await updateLocationTask(userModel.id);
                  },
                  text: 'Set Task Location',
                  active: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
