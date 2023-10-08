import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enableorg/models/user.dart';
import 'package:enableorg/models/wellness_message.dart';

class UserWellnessCheckController {
  Future<DateTime?> getLastWellnessMessageTimestamp(String userUID) async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('WellnessMessage')
          .where('senderUID', isEqualTo: userUID)
          .orderBy('creationTimestamp', descending: true)
          .limit(1)
          .get();

      final List<QueryDocumentSnapshot> documents = snapshot.docs;

      if (documents.isNotEmpty) {
        final wellnessMessage =
            WellnessMessage.fromDocumentSnapshot(documents.first);
        return wellnessMessage.creationTimestamp.toDate();
      }
    } catch (e) {
      print('Error retrieving last wellness message timestamp: $e');
    }

    return null;
  }

  Future<String> onSendMessage(User user, WellnessMessage message) async {
    try {
      final DateTime? lastSubmission =
          await getLastWellnessMessageTimestamp(user.uid);
      if (lastSubmission != null) {
        final DateTime now = DateTime.now();
        final Duration difference = now.difference(lastSubmission);

        if (difference.inHours <= 24) {
          return "Wellness message has already been submitted";
        }
      }

      final CollectionReference wellnessMessageCollection =
          FirebaseFirestore.instance.collection('WellnessMessage');

      await wellnessMessageCollection.doc(message.wmid).set(message.toMap());
      return "Message sent succesfully";

      // Perform any additional logic or actions after sending the message
    } catch (e) {
      print('Error sending message: $e');
      return "Message could not be sent";

      // Handle the error gracefully
    }
  }

  // Add your controller methods and logic here
}
