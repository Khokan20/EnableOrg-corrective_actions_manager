import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enableorg/models/wellness_message.dart';

import '../../models/user.dart';

class ManagerWellnessFeedbackController {
  Future<List<WellnessMessage>> getAllMessagesForManager(User user) async {
    try {
      final QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('WellnessMessage').get();

      final List<WellnessMessage> messages = [];

      for (var doc in snapshot.docs) {
        final WellnessMessage message =
            WellnessMessage.fromDocumentSnapshot(doc);
        if (message.recipientUID == user.uid) {
          messages.add(message);
        }
      }
      return messages;
    } catch (e) {
      print('Error fetching messages: $e');
      return []; // Return an empty list if there's an error
    }
  }

  Future<String> findSenderDisplayName(String uid, bool isAnon) async {
    try {
      final userDoc =
          await FirebaseFirestore.instance.collection('User').doc(uid).get();

      if (userDoc.exists) {
        final user = User.fromDocumentSnapshot(userDoc);
        return isAnon ? 'Anonymous' : user.email;
      }
    } catch (e) {
      print('Error getting Display name: $e');
    }
    return 'Error getting name';
  }

  Future<void> setRead(String wmid) async {
    try {
      final messageRef =
          FirebaseFirestore.instance.collection('WellnessMessage').doc(wmid);

      await messageRef.update({'readStatus': true});
    } catch (e) {
      print('Error setting message as read: $e');
    }
  }
}
