import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stocksalertapp/models/alert_model.dart';

class AlertService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName = 'alerts';

  /// Adds a new alert to Firestore.
  Future<void> addAlert(AlertModel alert) async {
    await _firestore.collection(collectionName).add(alert.toJson());
  }

  /// Fetches all alerts for a given FCM token.
  Future<List<AlertModel>> fetchAlertsByToken(String uid) async {
    final querySnapshot = await _firestore
        .collection(collectionName)
        .where('uid', isEqualTo: uid)
        .get();

    return querySnapshot.docs
        .map((doc) => AlertModel.fromJson(doc.data()))
        .toList();
  }

  /// Updates the `isNotified` status of an alert by its document ID.
  Future<void> updateNotificationStatus(String documentId, bool status) async {
    await _firestore
        .collection(collectionName)
        .doc(documentId)
        .update({'isNotified': status});
  }

  /// Deletes an alert from Firestore by its document ID.
  Future<void> deleteAlert(String documentId) async {
    await _firestore.collection(collectionName).doc(documentId).delete();
  }
}
