import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  String email;
  String name;
  bool isManager;
  String managerId;
  String did;
  String lid;
  String cid;

  User({
    required this.uid,
    required this.email,
    required this.isManager,
    required this.managerId,
    required this.did,
    required this.lid,
    required this.cid,
    required this.name,
  });

  factory User.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    try {
      final data = snapshot.data() as Map<String, dynamic>;
      final uid = data['uid'] as String;
      final email = data['email'] as String;
      final isManager = data['isManager'] as bool;
      final managerId = data['managerId'] as String;
      final did = data['did'] as String;
      final lid = data['lid'] as String;
      final cid = data['cid'] as String;
      final name = data['name'] as String;

      return User(
        name: name,
        uid: uid,
        email: email,
        isManager: isManager,
        managerId: managerId,
        did: did,
        lid: lid,
        cid: cid,
      );
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'isManager': isManager,
      'managerId': managerId,
      'did': did,
      'lid': lid,
      'cid': cid,
      'name': name,
    };
  }

  Future<bool> updateInFirestore() async {
    try {
      final CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('User');

      // Update the user in the database using the 'uid' field as the document ID
      await usersCollection.doc(uid).update(toMap());
      return true;
    } catch (e) {
      print('Error updating user in Firestore: $e');
      // Handle the error as per your requirement
      return false;
    }
  }

  Future<bool> deleteFromFirestore() async {
    try {
      print("Deleting user...");
      final CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('User');

      await usersCollection.doc(uid).delete();
      return true;
    } catch (e) {
      print('Error deleting user from Firestore: $e');
      return false;
      // Handle the error as per your requirement
    }
  }

  @override
  String toString() {
    return '======\nID: $uid\nEmail: $email\nisManager: $isManager\nDepartment ID: $did\nLocation ID: $lid\nCompany ID: $cid\n======';
  }

  static Future<String?> getCurrentUserCid(String managerUID) async {
    try {
      final userDocSnapshot = await FirebaseFirestore.instance
          .collection('User')
          .doc(managerUID)
          .get();

      if (userDocSnapshot.exists) {
        return userDocSnapshot['cid'];
      } else {
        return null; // User document not found
      }
    } catch (e) {
      print("Error getting current user's cid: $e");
      return null;
    }
  }
}
