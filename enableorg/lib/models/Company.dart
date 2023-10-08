import 'package:cloud_firestore/cloud_firestore.dart';

enum CompanyStatus { ACTIVE, REMOVED }

class Company {
  final String cid;
  final CompanyStatus status;
  final DateTime creationTimestamp;

  Company({
    required this.cid,
    required this.status,
    required this.creationTimestamp,
  });

  factory Company.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    final cid = data['cid'] as String;
    final statusValue = data['status'] as String;
    final creationTimestamp = (data['creationTimestamp'] as Timestamp).toDate();

    // Determine the CompanyStatus based on the status value from Firestore
    final status =
        statusValue == 'ACTIVE' ? CompanyStatus.ACTIVE : CompanyStatus.REMOVED;

    return Company(
      cid: cid,
      status: status,
      creationTimestamp: creationTimestamp,
    );
  }

  @override
  String toString() {
    return '======\nCID: $cid\nStatus: $status\nCreation Timestamp: $creationTimestamp\n======';
  }
}
