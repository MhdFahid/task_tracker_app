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
  final DateTime dateAndTime;

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
    required this.dateAndTime,
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
      startButton: data['startButton'] ?? false,
      taskStatus: data['taskStatus'] ?? false,
      dateAndTime: (data['dateAnd'] as Timestamp).toDate(),
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
      'startButton': startButton,
      'taskStatus': taskStatus,
      'dateAnd': Timestamp.fromDate(dateAndTime),
    };
  }
}
