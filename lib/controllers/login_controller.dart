import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:task_tracker_app/screens/admin_screen.dart';
import 'package:task_tracker_app/screens/user_screen.dart';

import 'location_controller.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;
  LocationController locationController = Get.put(LocationController());

  Future<void> loginUser(String email, String password) async {
    isLoading.value = true;

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (email == "admin@example.com") {
        print(email);
        Get.offAll(() => const AllUsersScreen());
      } else {
        FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .update({
          "latitude": locationController.currentPosition.value!.latitude,
          "longitude": locationController.currentPosition.value!.longitude,
        });
        Get.offAll(() => UserScreen());
      }
    } on FirebaseAuthException catch (e) {
      String message;

      switch (e.code) {
        case 'invalid-email':
          message = 'The email address is not valid.';
          break;

        case 'user-not-found':
          message = 'No user found for the given email address.';
          break;

        case 'wrong-password':
          message = 'Wrong password provided.';
          break;

        case 'user-disabled':
          message = 'This user account has been disabled.';
          break;

        default:
          message = 'An undefined error occurred.';
      }

      Get.showSnackbar(GetSnackBar(
        message: message,
        duration: const Duration(seconds: 2),
      ));
    } catch (e) {
      Get.showSnackbar(GetSnackBar(
        message: e.toString(),
        duration: const Duration(seconds: 2),
      ));
    } finally {
      isLoading.value = false;
    }
  }
}
