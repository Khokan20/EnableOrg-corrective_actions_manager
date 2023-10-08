import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enableorg/models/notification.dart';

class ManagerNotificationController {
  Future<List<Notification>> getAllNotifications() async {
    try {
      final QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('Notification').get();

      final List<Notification> notifications = [];

      for (var doc in snapshot.docs) {
        final Notification notification = Notification.fromFirestore(doc);
        notifications.add(notification);
      }
      // Sort the list of notifications by creationTimestamp
      notifications
          .sort((a, b) => b.creationTimestamp.compareTo(a.creationTimestamp));

      return notifications;
    } catch (e) {
      print('Error fetching notifications: $e');
      return []; // Return an empty list if there's an error
    }
  }

  Future<void> createNotification(Notification notification) async {
    try {
      final notificationRef =
          FirebaseFirestore.instance.collection('Notification').doc();

      await notificationRef.set({
        'title': notification.title,
        'message': notification.message,
        'senderUID': notification.senderUID,
        'recipientUID': notification.recipientUID,
        'creationTimestamp': notification.creationTimestamp,
        'nid': notificationRef.id,
      });

      // Send email to every recipient UID
    } catch (e) {
      print('Error creating notification: $e');
    }
  }

  Future<void> onNotificationSend(Notification notification) async {
    try {
      createNotification(notification);
    } catch (e) {
      print('Error sending notification');
    }
  }
  // Add more controller functions here as needed
}
