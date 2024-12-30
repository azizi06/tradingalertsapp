import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stocksalertapp/models/alert_model.dart';

class FirestoreService{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addAlert(AlertModel alert) async {
    try {
      await _firestore.collection('alerts').add(alert.toJson());
      print('Alert added successfully!');
    } catch (e) {
      print('Error adding alert: $e');
    }
  }

  Future<List<AlertModel>> getAlerts() async {
  try {
    QuerySnapshot snapshot = await _firestore.collection('alerts').get();
    return snapshot.docs.map((doc) {
      return AlertModel.fromJson(doc.data() as Map<String, dynamic>);
    }).toList();
  } catch (e) {
    print('Error fetching alerts: $e');
    return [];
  }
}

}
