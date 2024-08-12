import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:task_tracker_app/screens/admin_view_screen.dart';
import 'package:task_tracker_app/screens/login_screen.dart.dart';
import '../models/user_model.dart';

class AllUsersScreen extends StatelessWidget {
  const AllUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Users'),
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No users found'));
          }

          final users = snapshot.data!.docs
              .map((doc) => UserModel.fromFirestore(doc))
              .toList();

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final UserModel user = users[index];
              return ListTile(
                title: Text(user.name),
                subtitle: Text(user.email),
                trailing: Text(
                  user.taskStatus
                      ? 'Task Done'
                      : user.taskLatitude == 0.1
                          ? 'No Task'
                          : 'Task Pending',
                  style: TextStyle(
                      color: user.taskStatus
                          ? Colors.green
                          : user.taskLatitude == 0.1
                              ? Colors.blue
                              : Colors.red),
                ),
                onTap: () {
                  Get.to(() => AdminViewScreen(
                        userModel: user,
                      ));
                },
              );
            },
          );
        },
      ),
    );
  }
}
