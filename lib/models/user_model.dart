import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final double latitude;
  final double longitude;
  final double taskLatitude;
  final double taskLongitude;
  final bool startButton;
  final bool taskStatus;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.latitude,
    required this.longitude,
    required this.taskLatitude,
    required this.taskLongitude,
    required this.startButton,
    required this.taskStatus,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return UserModel(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      latitude: data['latitude']?.toDouble() ?? 0.1,
      longitude: data['longitude']?.toDouble() ?? 0.1,
      taskLatitude: data['taskLatitude']?.toDouble() ?? 0.1,
      taskLongitude: data['taskLongitude']?.toDouble() ?? 0.1,
      startButton: data['startButtom'] ?? false,
      taskStatus: data['task_status'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'latitude': latitude,
      'longitude': longitude,
      'taskLatitude': taskLatitude,
      'taskLongitude': taskLongitude,
      'startButtom': startButton,
      'task_status': taskStatus,
    };
  }
}
