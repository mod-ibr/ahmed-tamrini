import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

// https://github.com/furkansarihan/firestore_collection/blob/master/lib/firestore_document.dart
extension FirestoreDocumentExtension on DocumentReference {
  Future<DocumentSnapshot> getSavy() async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      return this.get(GetOptions(source: Source.server));
    }
    try {
      DocumentSnapshot ds = await this.get(GetOptions(source: Source.cache));
      if (ds == null) return this.get(GetOptions(source: Source.server));
      return ds;
    } catch (_) {
      return this.get(GetOptions(source: Source.server));
    }
  }
}

// https://github.com/furkansarihan/firestore_collection/blob/master/lib/firestore_query.dart
extension FirestoreQueryExtension on Query {
  Future<QuerySnapshot> getSavy() async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      return this.get(GetOptions(source: Source.server));
    }
    try {
      QuerySnapshot qs = await this.get(GetOptions(source: Source.cache));
      if (qs.docs.isEmpty) return this.get(GetOptions(source: Source.server));
      return qs;
    } catch (_) {
      return this.get(GetOptions(source: Source.server));
    }
  }
}
