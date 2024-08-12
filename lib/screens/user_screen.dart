import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:task_tracker_app/models/user_model.dart';
import 'package:task_tracker_app/suported_widgets/square_button.dart';

import '../controllers/location_controller.dart';
import 'login_screen.dart.dart';

class UserScreen extends StatelessWidget {
  UserScreen({super.key});

  final LocationController locationController = Get.put(LocationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Dashboard'),
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
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('User data not found'));
          }

          var userModel = UserModel.fromFirestore(snapshot.data!);

          LatLng userLocation =
              LatLng(userModel.taskLatitude, userModel.taskLongitude);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Username: ${userModel.name}',
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 10),
                Text(
                  'Email: ${userModel.email}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                userModel.taskLatitude != 0.1
                    ? Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Task Status: ',
                                  style: TextStyle(fontSize: 16),
                                ),
                                userModel.taskStatus
                                    ? const Text(
                                        'Done',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.blue),
                                      )
                                    : const Text(
                                        'Pending',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold),
                                      ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            SquareButton(
                              text: userModel.taskStatus
                                  ? "Completed"
                                  : 'Start Task',
                              onTap: () {
                                if (userModel.taskStatus) {
                                  _updateStartButtonStatus();
                                } else if (userModel.taskStatus) {
                                  _completeTask();
                                }
                              },
                              active: false, 
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              child: Text(
                                'Task Location',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            Expanded(
                              child: GoogleMap(
                                initialCameraPosition: CameraPosition(
                                  target: userLocation,
                                  zoom: 14.0,
                                ),
                                markers: {
                                  Marker(
                                    markerId: const MarkerId('task_location'),
                                    position: userLocation,
                                    infoWindow: const InfoWindow(
                                        title: 'Task Location'),
                                  ),
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    : const Text("No task assigned, please check with admin"),
              ],
            ),
          );
        },
      ),
    );
  }

  void _updateStartButtonStatus() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({"startButtom": true});
  }

  _completeTask() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({"task_status": true});
  }
}
