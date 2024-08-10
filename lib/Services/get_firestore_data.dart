import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../class/user_class.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;

class GetFirestoreData{
  Future<Users?> getUserData() async {
    try {
      DocumentSnapshot userDoc = await firestore
          .collection("Users")
          .doc(auth.currentUser!.uid)
          .get();
      if (userDoc.exists && userDoc.data() != null) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        Users user = Users.fromMap(data);
        return user; // Return the User instance
      } else {
        print('User document does not exist');
        return null; // Or return a default User if preferred
      }
    } catch (e) {
      print('Error retrieving user data: $e');
      return null; // Or handle the error as needed
    }
  }

  Future<Map<String, dynamic>?> getTransactionData() async {
    try {
      DocumentSnapshot userDoc = await firestore
          .collection("Transactions")
          .doc(auth.currentUser!.uid)
          .get();
      if (userDoc.exists && userDoc.data() != null) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        return data; // Return the User instance
      } else {
        print('User document does not exist');
        return null; // Or return a default User if preferred
      }
    } catch (e) {
      print('Error retrieving user data: $e');
      return null; // Or handle the error as needed
    }
  }
}