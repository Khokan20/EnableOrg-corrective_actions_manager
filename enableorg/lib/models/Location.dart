import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_string/random_string.dart';

class Location {
  String lid;
  final String country;
  final String siteLocation;
  final String cid;

  Location({
    required this.lid,
    required this.country,
    required this.siteLocation,
    required this.cid,
  });

  factory Location.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    final lid = snapshot.id;
    final country = data['country'] as String;
    final siteLocation = data['siteLocation'] as String;
    final cid = data['cid'] as String;

    return Location(
      lid: lid,
      country: country,
      siteLocation: siteLocation,
      cid: cid,
    );
  }

  @override
  String toString() {
    return '======\nCountry: $country\nSite Location: $siteLocation\nCID: $cid\n======';
  }

  static Future<String?> getLocationNameWithlid(String lid) async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Location')
        .where('lid', isEqualTo: lid)
        .limit(1)
        .get();
    if (snapshot.docs.isNotEmpty) {
      final departmentDoc = snapshot.docs.first;
      return Location.fromDocumentSnapshot(departmentDoc).siteLocation;
    } else {
      return null;
    }
  }

  static Future<String?> getLocationCountryWithlid(String lid) async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Location')
        .where('lid', isEqualTo: lid)
        .limit(1)
        .get();
    if (snapshot.docs.isNotEmpty) {
      final departmentDoc = snapshot.docs.first;
      return Location.fromDocumentSnapshot(departmentDoc).country;
    } else {
      return null;
    }
  }

  static Future<Location> getOrCreateLocation(
      String country, String siteLocation, String cid) async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Location')
        .where('country', isEqualTo: country)
        .where('siteLocation', isEqualTo: siteLocation)
        .where('cid', isEqualTo: cid)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final locationDoc = snapshot.docs.first;
      return Location.fromDocumentSnapshot(locationDoc);
    } else {
      final newLocation = Location(
        lid: randomAlpha(30),
        country: country,
        siteLocation: siteLocation,
        cid: cid,
      );

      final newLocationRef = FirebaseFirestore.instance
          .collection('Location')
          .doc(newLocation.lid);

      await newLocationRef.set({
        'lid': newLocation.lid,
        'country': country,
        'siteLocation': siteLocation,
        'cid': cid,
      });

      return newLocation;
    }
  }

  static Future<String?> getLidWithLocationAndCidOrCreate(
      String siteLocation, String country, String cid) async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Location')
        .where('siteLocation', isEqualTo: siteLocation)
        .where('cid', isEqualTo: cid)
        .where('country', isEqualTo: country)
        .limit(1)
        .get();
    if (snapshot.docs.isNotEmpty) {
      final locationDoc = snapshot.docs.first;
      return Location.fromDocumentSnapshot(locationDoc).lid;
    } else {
      final newLocation = Location(
        lid: randomAlpha(30),
        country: country,
        siteLocation: siteLocation,
        cid: cid,
      );

      final newLocationRef = FirebaseFirestore.instance
          .collection('Location')
          .doc(newLocation.lid);

      await newLocationRef.set({
        'lid': newLocation.lid,
        'country': country,
        'siteLocation': siteLocation,
        'cid': cid,
      });

      return newLocation.lid;
    }
  }
}
