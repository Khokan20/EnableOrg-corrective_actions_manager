import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_string/random_string.dart';

class Department {
  String did;
  final String name;
  final String description;
  final Timestamp creationTimestamp;
  final String cid;

  Department({
    required this.did,
    required this.name,
    required this.description,
    required this.creationTimestamp,
    required this.cid,
  });

  factory Department.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    final did = snapshot.id;
    final name = data['name'] as String;
    final description = data['description'] as String;
    final creationTimestamp = data['creationTimestamp'] as Timestamp;
    final cid = data['cid'] as String;

    return Department(
      did: did,
      name: name,
      description: description,
      creationTimestamp: creationTimestamp,
      cid: cid,
    );
  }

  @override
  String toString() {
    return '======\nName: $name\nDescription: $description\nCreation Timestamp: $creationTimestamp\n======';
  }

  static Future<String?> getDepartmentNameWithDid(String did) async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Department')
        .where('did', isEqualTo: did)
        .limit(1)
        .get();
    if (snapshot.docs.isNotEmpty) {
      final departmentDoc = snapshot.docs.first;
      return Department.fromDocumentSnapshot(departmentDoc).name;
    } else {
      return null;
    }
  }

  static Future<Department> getOrCreateDepartment(
      String department, String cid) async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Department')
        .where('name', isEqualTo: department)
        .where('cid', isEqualTo: cid)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final departmentDoc = snapshot.docs.first;
      return Department.fromDocumentSnapshot(departmentDoc);
    } else {
      final newDepartment = Department(
        did: randomAlpha(30),
        name: department,
        description: '',
        creationTimestamp: Timestamp.now(),
        cid: cid,
      );

      final newDepartmentRef = FirebaseFirestore.instance
          .collection('Department')
          .doc(newDepartment.did);

      await newDepartmentRef.set({
        'did': newDepartment.did,
        'name': department,
        'description': '',
        'creationTimestamp': newDepartment.creationTimestamp,
        'cid': cid,
      });

      return newDepartment;
    }
  }

  static Future<String?> getDidWithNameAndCidOrCreate(
      String name, String cid) async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Department')
        .where('name', isEqualTo: name)
        .where('cid', isEqualTo: cid)
        .limit(1)
        .get();
    if (snapshot.docs.isNotEmpty) {
      final departmentDoc = snapshot.docs.first;
      return Department.fromDocumentSnapshot(departmentDoc).did;
    } else {
      final newDepartment = Department(
        did: randomAlpha(30),
        name: name,
        description: '',
        creationTimestamp: Timestamp.now(),
        cid: cid,
      );

      final newDepartmentRef = FirebaseFirestore.instance
          .collection('Department')
          .doc(newDepartment.did);

      await newDepartmentRef.set({
        'did': newDepartment.did,
        'name': name,
        'description': '',
        'creationTimestamp': newDepartment.creationTimestamp,
        'cid': cid,
      });

      return newDepartment.did;
    }
  }
}
